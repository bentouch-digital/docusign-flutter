import Flutter
import UIKit
import DocuSignSDK
import DocuSignAPI

enum ChannelName {
  static let methods = "docusign_flutter/methods"
  static let observer = "docusign_flutter/observer"
}

public class SwiftDocusignFlutterPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?
    
    private var loginResult: FlutterResult?
    private var captiveSignResult: FlutterResult?
    private var createEnvelopeResult: FlutterResult?
    private var offlineSigningResult: FlutterResult?
    private var syncEnvelopesResult: FlutterResult?
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channelMethods = FlutterMethodChannel(name: ChannelName.methods, binaryMessenger: registrar.messenger())
        let instance = SwiftDocusignFlutterPlugin()
        registrar.addMethodCallDelegate(instance, channel: channelMethods)
        
        var configurations = DSMManager.defaultConfigurations()
        configurations[DSM_SETUP_CAPTIVE_SIGNING_USE_LANGUAGE_CODE] = DSM_LANGUAGE_CODE_FOR_FRENCH
        DSMManager.setup(withConfiguration: configurations)
        
        let channelObserver = FlutterEventChannel(name: ChannelName.observer, binaryMessenger: registrar.messenger())
        channelObserver.setStreamHandler(instance)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "login":
            loginResult = result
            login(call: call)
        case "createEnvelope":
            createEnvelopeResult = result
            createEnvelope(call: call)
        case "offlineSigning":
            offlineSigningResult = result
            offlineSigning(call: call)
        case "captiveSinging":
            captiveSignResult = result
            captiveSigning(call: call)
        case "syncEnvelopes":
            syncEnvelopesResult = result
            syncEnvelopes(call: call)
        default:
            result(buildError(title: Constants.IncorrectCommand))
        }
    }
    
    func login(call: FlutterMethodCall) {
        guard let params = call.arguments as? Array<String> else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect params string"))
            return
        }
        
        guard let jsonData = params[0].data(using: .utf8),
              let authModel: AuthModel = try? JSONDecoder().decode(AuthModel.self, from: jsonData) else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect json: \(params)"))
            return
        }
        
        guard let hostUrl = URL(string: authModel.host) else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect host url: \(authModel.host)"))
            return
        }
        
        DSMManager.login(withAccessToken: authModel.accessToken,
                         accountId: authModel.accountId,
                         userId: authModel.userId,
                         userName: authModel.userName,
                         email: authModel.email,
                         host: hostUrl,
                         integratorKey: authModel.integratorKey,
                         completion: { (accountInfo, error) in
            if (error != nil) {
                self.loginResult?(self.buildError(title: "auth failed", details: error?.localizedDescription))
            } else {
                do {
                    let data = try JSONEncoder().encode(AccountInfoCodable(accountId: accountInfo?.accountId ?? "", 
                        accountName: accountInfo?.accountName ?? "", email: accountInfo?.email ?? "",
                        userName: accountInfo?.userName ?? "", userId: accountInfo?.userId ?? ""))
                    if let jsonString = String(data: data, encoding: .utf8) {
                        self.loginResult?(jsonString)
                    }
                } catch {
                    self.loginResult?(self.buildError(title: "auth failed", details: error.localizedDescription))
                }
            }
        })
    }
    
    func createEnvelope(call: FlutterMethodCall) {
        guard let params = call.arguments as? Array<String> else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect params string"))
            return
        }
        
        let accountId = params[0];

        guard let jsonData = params[1].data(using: .utf8),
              let envelopeDefinitionModel: EnvelopeDefinitionModel = try? JSONDecoder().decode(EnvelopeDefinitionModel.self, from: jsonData) else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect json: \(params)"))
            return
        }
        
        // documents
        var documents = [DSAPIDocument]()
        for document in envelopeDefinitionModel.documents {
            documents.append(DSAPIDocument.init(documentBase64: document.documentBase64, documentId: document.documentId, fileExtension: document.fileExtension, includeInDownload: document.includeInDownload, name: document.name));
        }
        
        // carbon copies
        var carbonCopies = [DSAPICarbonCopy]()
        for carbonCopy in envelopeDefinitionModel.recipients.carbonCopies {
            carbonCopies.append(DSAPICarbonCopy.init(email: carbonCopy.email, firstName: carbonCopy.firstName, lastName: carbonCopy.lastName, name: carbonCopy.name, recipientId: carbonCopy.recipientId, routingOrder: carbonCopy.routingOrder, status: carbonCopy.status))
        }
        
        // signers
        var signers = [DSAPISigner]()
        for signer in envelopeDefinitionModel.recipients.signers {
            // sms authentication
            let smsAuthentication = DSAPIRecipientSMSAuthentication.init(senderProvidedNumbers: signer.smsAuthentication.senderProvidedNumbers)
            
            // sign here tabs
            var signHereTabs = [DSAPISignHere]()
            for signHereTab in signer.tabs.signHereTabs {
                signHereTabs.append(DSAPISignHere.init(anchorString: signHereTab.anchorString, anchorUnits: signHereTab.anchorUnits, anchorXOffset: signHereTab.anchorXOffset, anchorYOffset: signHereTab.anchorYOffset, status: signHereTab.status))
            }
            // tabs
            let tabs = DSAPITabs.init(signHereTabs: signHereTabs)
            
            signers.append(DSAPISigner.init(clientUserId: signer.clientUserId, email: signer.email, firstName: signer.firstName, idCheckConfigurationName: signer.idCheckConfigurationName, lastName: signer.lastName, name: signer.name, recipientId: signer.recipientId, requireIdLookup: signer.requireIdLookup, routingOrder: signer.routingOrder, smsAuthentication: smsAuthentication, status: signer.status, tabs: tabs))
        }
        
        let recipients = DSAPIRecipients.init(carbonCopies: carbonCopies, signers: signers)
        
        let envelopeDefinition = DSAPIEnvelopeDefinition.init(documents: documents, emailSubject: envelopeDefinitionModel.emailSubject, recipients: recipients, status: envelopeDefinitionModel.status)
        
        EnvelopesAPI.envelopesPostEnvelopes(accountId: accountId, body: envelopeDefinition) { data, error in
            if error != nil {
                self.createEnvelopeResult?(self.buildError(title: "Create envelope cancelled", details: error?.localizedDescription))
                return
            } else {
                self.createEnvelopeResult?(data?.envelopeId)
                return
            }
        }
    }
    
    func offlineSigning(call: FlutterMethodCall) {
        loginResult?(buildError(title: Constants.IncorrectArguments, details: call.arguments as? String))
        guard let params = call.arguments as? Array<String> else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect params string"))
            return
        }
        
        guard let viewController: UIViewController = getPresentingViewController() else {
            captiveSignResult?(buildError(title: "Offline singing cancelled"))
            return
        }
        
        DSMEnvelopesManager().resumeSigningEnvelope(withPresenting: viewController,
            envelopeId: params[0]) { (viewController, error) in
            if error != nil {
                self.offlineSigningResult?(self.buildError(title: "Offline singing cancelled"))
                return
            }
        }
    }
    
    func syncEnvelopes(call: FlutterMethodCall) {
        DSMEnvelopesManager().syncEnvelopes()
    }
    
    func captiveSigning(call: FlutterMethodCall) {
        guard let params = call.arguments as? Array<String> else {
            captiveSignResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect params string"))
            return
        }
        
        let accountId = params[0]
        let envelopeId = params[1]
        
        guard let jsonData = params[2].data(using: .utf8),
              let recipientViewRequestModel: RecipientViewRequestModel = try? JSONDecoder().decode(RecipientViewRequestModel.self, from: jsonData) else {
            captiveSignResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect json: \(params)"))
            return
        }
        
        let recipientViewRequest = DSAPIRecipientViewRequest.init(authenticationMethod: recipientViewRequestModel.authenticationMethod, clientUserId: recipientViewRequestModel.clientUserId, email: recipientViewRequestModel.email, recipientId: recipientViewRequestModel.recipientId, returnUrl: URL.init(string: recipientViewRequestModel.returnUrl), userName: recipientViewRequestModel.userName)
        
        EnvelopesAPI.viewsPostEnvelopeRecipientView(accountId: accountId, envelopeId: envelopeId, body: recipientViewRequest) { data, error in
            if error != nil {
                self.captiveSignResult?(self.buildError(title: "Signing cancelled"))
                return
            } else {
                self.captiveSignResult?(data?.url?.absoluteString)
                return
            }
        }
    }
    
    private func getPresentingViewController() -> UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }
    
    private func buildError(title: String, details: String? = nil) -> FlutterError {
        return FlutterError.init(code: "NATIVE_ERR",
                                 message: "Error: \(title)",
                                 details: details)
    }
}

extension SwiftDocusignFlutterPlugin {
    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSigningCancelled(notification:)), name: Notification.Name("DSMSigningCancelledNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onSigningCompleted(notification:)), name: Notification.Name("DSMSigningCompletedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onEnvelopeSyncingStarted(notification:)), name: Notification.Name("DSMEnvelopeSyncingStartedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onEnvelopeSyncingSucceeded(notification:)), name: Notification.Name("DSMEnvelopeSyncingSucceededNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onEnvelopeSyncingEnded(notification:)), name: Notification.Name("DSMEnvelopeSyncingEndedNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.onEnvelopeSyncingFailed(notification:)), name: Notification.Name("DSMEnvelopeSyncingFailedNotification"), object: nil)
      return nil
    }
    
    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)
        eventSink = nil
        return nil
    }
    
    @objc private func onSigningCompleted(notification: Notification) {
        eventSink?("DSMSigningCompletedNotification")
    }
    
    @objc private func onSigningCancelled(notification: Notification) {
        eventSink?(buildError(title: "DSMSigningCancelledNotification"))
    }
    
    @objc private func onEnvelopeSyncingStarted(notification: Notification) {
        eventSink?("DSMEnvelopeSyncingStartedNotification")
    }
    
    @objc private func onEnvelopeSyncingSucceeded(notification: Notification) {
        eventSink?("DSMEnvelopeSyncingSucceededNotification")
    }
    
    @objc private func onEnvelopeSyncingEnded(notification: Notification) {
        eventSink?(buildError(title: "DSMEnvelopeSyncingEndedNotification"))
    }
    
    @objc private func onEnvelopeSyncingFailed(notification: Notification) {
        eventSink?(buildError(title: "DSMEnvelopeSyncingFailedNotification"))
    }
}

struct Constants {
    static let IncorrectArguments = "IncorrectArguments"
    static let IncorrectCommand = "IncorrectCommand"
}
