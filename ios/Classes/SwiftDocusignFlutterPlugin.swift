import Flutter
import UIKit
import DocuSignSDK

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
        
        guard let jsonData = params[0].data(using: .utf8),
              let createEnvelope: CreateEnvelopeModel = try? JSONDecoder().decode(CreateEnvelopeModel.self, from: jsonData) else {
            loginResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect json: \(params)"))
            return
        }
        
        print("hello from Mbola : ")
        
        let tabA = DSMTabBuilder.init(for: .signHere)
            .addName("signTab1")
            .addRecipientId("1")
            .addDocumentId("1")
            .addPageNumber(1)
            .addFrame(CGRect(x: 150, y: 600, width: 50, height: 40))
            .build()
        
        let recipientA = DSMRecipientBuilder.init(for: .inPersonSigner)
            .addRecipientId("1")
            .addHostName(createEnvelope.hostName)
            .addHostEmail(createEnvelope.hostEmail)
            .addSignerName(createEnvelope.inPersonSignerName)
            .addSignerEmail(createEnvelope.inPersonSignerEmail)
            .addRoutingOrder(1)
            .add([tabA])
            .build()
        
        let recipientB = DSMRecipientBuilder.init(for: .CC)
            .addRecipientId("2")
            .addSignerName(createEnvelope.inPersonSignerName)
            .addSignerEmail(createEnvelope.inPersonSignerEmail)
            .build()
        
        let filename = createEnvelope.envelopeName
        
        let document = DSMDocumentBuilder.init()
            .addName("doc1")
            .addDocumentId("1")
            .addFilePath(createEnvelope.filePath)
            .build()
        
        let envelopeDefinition = DSMEnvelopeBuilder.init()
            .addEnvelopeName("Test Envelope -- name")
            .addEmailSubject("Test Envelope -- Subject")
            .addEmailMessage("Message blurb -- \n -- there goes the docusign email message -- sent via sdk -- ")
            .add([recipientA, recipientB])
            .add(document)
            .build()
        
        DSMEnvelopesManager.init().composeEnvelope(with: envelopeDefinition, signingMode: .offline) { (envelopeId, error) in
            if envelopeId != nil {
                self.createEnvelopeResult?(envelopeId)
            } else {
                self.createEnvelopeResult?(self.buildError(title: "Create envelope cancelled", details: error.localizedDescription))
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
        
        guard let jsonData = params[0].data(using: .utf8),
              let captiveSignModel: CaptiveSignModel = try? JSONDecoder().decode(CaptiveSignModel.self, from: jsonData) else {
            captiveSignResult?(buildError(title: Constants.IncorrectArguments, details: "incorrect json: \(params)"))
            return
        }
        
        guard let viewController: UIViewController = getPresentingViewController() else {
            captiveSignResult?(buildError(title: "Singing cancelled"))
            return
        }
        
        DSMEnvelopesManager().presentCaptiveSigning(withPresenting: viewController,
                                               envelopeId: captiveSignModel.envelopeId,
                                               recipientUserName: captiveSignModel.recipientUserName,
                                               recipientEmail: captiveSignModel.recipientEmail,
                                               recipientClientUserId: captiveSignModel.recipientClientUserId,
                                               animated: true) { vc, error in
            if error != nil {
                self.captiveSignResult?(self.buildError(title: "Singing cancelled"))
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
