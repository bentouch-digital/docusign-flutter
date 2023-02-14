import 'dart:convert';
import 'dart:io';
import 'package:docusign_flutter/model/access_token_model.dart';
import 'package:docusign_flutter/model/account_info.dart';
import 'package:docusign_flutter/model/add_documents_model.dart';
import 'package:docusign_flutter/model/auth_model.dart';
import 'package:docusign_flutter/model/carbon_copy_model.dart';
import 'package:docusign_flutter/model/delete_documents_model.dart';
import 'package:docusign_flutter/model/document_model.dart';
import 'package:docusign_flutter/model/envelope_definition_model.dart';
import 'package:docusign_flutter/model/input_token_model.dart';
import 'package:docusign_flutter/model/recipient_sms_authentication_model.dart';
import 'package:docusign_flutter/model/recipient_view_request_model.dart';
import 'package:docusign_flutter/model/recipients_model.dart';
import 'package:docusign_flutter/model/sign_here_tab_model.dart';
import 'package:docusign_flutter/model/signer_model.dart';
import 'package:docusign_flutter/model/tabs_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:docusign_flutter/docusign_flutter.dart';
import 'package:path_provider/path_provider.dart';

String accessToken = r'<<NEED_CHANGE>>';
const String accountId = r'056e5faa-6144-474d-a9ca-252154beb8be';
const String email = r'signature@technitoit.com';
const int expiresIn = 28800;
const String host = r'https://demo.docusign.net/restapi';
const String integratorKey = r'26341914-0453-45f9-ae36-b8d17c244660';
const String userId = r'70846eda-f780-440c-a5d3-ca33479f0e15';
const String userName = r'Signa Ture';
const String privateRSAKey =
    r'''-----BEGIN RSA PRIVATE KEY----- MIIEpAIBAAKCAQEAj10kEgcOitWNpVG34oaLssIGk34gSUlG7w9IoQHFDUEsrngW YVaUtTNsBqaGnwKpGAXvDRYMRXttNQf6CBw62UbFz5RT86v5M2RLcBtAIryBY/A8 lT3JpHxLbZhN9u25IrNowSIbUrozjmpz7jW7WXuyxw/6MdHgZZvOWNFADTZB4ue0 MDyDj6eAoQvu/rjXGfJujeoyZGMRBIIacIpbtkYCRyN3baV8dQSlCyzqM/4/cCFl k3I8iF1tqO3UClE9l+SmQimFJRcirsHcLEiwQgkNT6MrKBlG8UxZPUybFktxdeXA 3d+GMWArE2T8gzZQhzlBNCWLEsG0ldqi+pyDzQIDAQABAoIBACGDt+i5+xmUKmCd LbR4WSShLKniyJfxWDKPO16eXAtI8vHXc33uYGXK32RfniWCmPabfoKr5pMAs2s8 EeS++rfsDlbEWWrjx2ZO+j67NB9au5HaKcOG1gKMpxJ4EjPZZ5gX4nOR7lrE2kQf GTp1F7bnzsev8cCfTIrcZV0Ij+V2caJr/JsJs9CW8EUxSP1Oje4fcUOZAktLbyw+ 3n+iRvCcrsE5uxCFj4iDN36V7lDiJMhWtIQxYb3TTr6xzpv4c5vV5fDxq/CcTE3x 4NLiflU/0/O3IjH9rxgLPpo/cYyNWLd6eNR2jyTUh4KRqd+DVMH0DsSz4r8tqCuz zj9OV1ECgYEAzPkYhjPnAD/DIdih6JkxOFVlEzmD75IFRw0szwXRd6tiC+vNYZLp H7dEBdecLdHSTZrSCUkngeNOstURlrHmzdKmLeAZG5Okb096+v8ycgCXPcQFIKoE Cw+U25JmeiUhtVv3CIvGHMWruNM8fTdxtd717K53VNtM1N1K9FVbpH0CgYEAsw2y 8LqOgLAhLY8e+dvecknmMrq8TsWwQR4cWWPZnniEwS00xTkt4F0kn4WvTqsxN8ZW r5E0N+6qZ9UGYTc63i5hFU/LckgT0nfqfB8xIh4AVpb5XycRF75wCPcfQuqbOXZJ Q01LAfEEhBx9ORnlPck6wBjO3e1tZADDSBTiDZECgYEAq+4VgBxxG2hgiTdpN+2n t5UJn0KTRJS7EIogl9ZNiY+cQlucfsf3+76BtFTSkCx7ttSycU+HcA/2p1LJ2hmH fAXBlqFu7g690xBcG8WLzsxoEEsn8eoqUgzT1AnNI4+Z4sItSGHV37R/Ah1Nk8q5 +s/2gH0nY2o/3B1zDde7cxECgYBJuytjW78QmPaglx3vT63TLEEhxKmEWn2Q4wBT gv169y/biG0BheExUcmh8t/UqkQTLpZFp6p0GdCL/zmoUKDqGvkZWIlzXuDiu0SQ phuKbAZBodvAZgrw1xe1aWWzHX6b8+yJTUvE2eW9LSoXmGVAwxtxPQX6dymjk3jW ttq7MQKBgQCm6C26LFA7nz0ZvpVxzFvV7r0Ygab7ILp/dGjc/+1eVrTM5RtJS+qc qUqfSVs08WGPGksIhfZhl76CW/pCVbzT9b9k/1uBMsASqiKYNQTZRS+NZPkNeDYn TNzlfUZ5sbvPhKTy+Lw2EmxRTdQhQgbV7kokhytou5C6MVhQLzCkVA== -----END RSA PRIVATE KEY-----''';
const String publicRSAKey =
    r'''-----BEGIN PUBLIC KEY----- MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAj10kEgcOitWNpVG34oaL ssIGk34gSUlG7w9IoQHFDUEsrngWYVaUtTNsBqaGnwKpGAXvDRYMRXttNQf6CBw6 2UbFz5RT86v5M2RLcBtAIryBY/A8lT3JpHxLbZhN9u25IrNowSIbUrozjmpz7jW7 WXuyxw/6MdHgZZvOWNFADTZB4ue0MDyDj6eAoQvu/rjXGfJujeoyZGMRBIIacIpb tkYCRyN3baV8dQSlCyzqM/4/cCFlk3I8iF1tqO3UClE9l+SmQimFJRcirsHcLEiw QgkNT6MrKBlG8UxZPUybFktxdeXA3d+GMWArE2T8gzZQhzlBNCWLEsG0ldqi+pyD zQIDAQAB -----END PUBLIC KEY-----''';

const String envelopeId = r'<<NEED_CHANGE>>';
const String recipientClientUserId = r'1';
const String recipientEmail = r'<<NEED_CHANGE>>';
const String recipientUserName = r'<<NEED_CHANGE>>';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AccountInfoModel? _accountInfoModel;
  String? _docusignObserver;
  String? _envelopeId;
  String? _modifiedEnvelopeIdDeleteDocument;
  String? _modifiedEnvelopeIdAddDocument;
  String? _modifiedEnvelopeIdCreateTabs;
  String? _modifiedEnvelopeIdUpdatedRecipients;
  String? _signingUrl;
  String? _documentPath;
  bool? _syncingStatus;
  bool? _offlineSigningStatus;
  AccessTokenModel? _accessTokenModel;

  @override
  void initState() {
    super.initState();
    DocusignFlutter.listenObserver(_onEvent, _onError);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Docusign_flutter'),
        ),
        body: Container(
          margin: const EdgeInsets.all(10),
          child: Builder(builder: (context) {
            return SingleChildScrollView(
              child: Center(
                child: Column(children: [
                  Text('Token status: ${_accessTokenModel?.accessToken}\n'),
                  ElevatedButton(
                    onPressed: () => _getAccessToken(),
                    child: const Text('AccessToken'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Auth status:${_accountInfoModel?.email}\n')),
                  ElevatedButton(
                    onPressed: () => _auth(),
                    child: const Text('Auth'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Document path :$_documentPath\n')),
                  ElevatedButton(
                    onPressed: () => _getDocument(),
                    child: const Text('Get Document'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Envelope Id :$_envelopeId\n')),
                  ElevatedButton(
                    onPressed: () => _createEnvelope(),
                    child: const Text('Create enveloppe'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('Signing url :$_signingUrl\n')),
                  ElevatedButton(
                    onPressed: () => _captiveSigning(),
                    child: const Text('Captive signing'),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Sign here'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Modified envelope delete : $_modifiedEnvelopeIdDeleteDocument\n')),
                  ElevatedButton(
                    onPressed: () => _deleteDocuments(),
                    child: const Text('Delete documents'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Modified envelope update : $_modifiedEnvelopeIdAddDocument\n')),
                  ElevatedButton(
                    onPressed: () => _addDocuments(),
                    child: const Text('Add documents'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Create recipient tabs : $_modifiedEnvelopeIdCreateTabs\n')),
                  ElevatedButton(
                    onPressed: () => _createRecipientTabs(),
                    child: const Text('Create recipient tabs'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Modified envelope update : $_modifiedEnvelopeIdUpdatedRecipients\n')),
                  ElevatedButton(
                    onPressed: () => _updateRecipients(),
                    child: const Text('Update Recipients'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Offline signing status: ${_convertStatus(_offlineSigningStatus)}\n')),
                  ElevatedButton(
                    onPressed: () => _offlineSigning(),
                    child: const Text('Offline signing'),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text('OBSERVER:$_docusignObserver\n')),
                  Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                          'Syncing status: ${_convertStatus(_syncingStatus)}\n')),
                  ElevatedButton(
                    onPressed: () => _syncingEnvelopes(),
                    child: const Text('Syncing'),
                  ),
                ]),
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _getAccessToken() async {
    var inputToken = InputTokenModel(
        url: 'account-d.docusign.com',
        urlPath: '/oauth/token',
        integratorKey: integratorKey,
        userId: userId,
        publicRSAKey: publicRSAKey,
        privateRSAKey: privateRSAKey);
    var result = await DocusignFlutter.getAccessToken(inputToken);
    setState(() {
      _accessTokenModel = result;
      if (result?.accessToken != null) {
        accessToken = result!.accessToken;
      }
    });
  }

  Future<void> _auth() async {
    var authModel = AuthModel(
      accessToken: accessToken,
      expiresIn: expiresIn,
      accountId: accountId,
      email: email,
      host: host,
      integratorKey: integratorKey,
      userId: userId,
      userName: userName,
    );
    var result = await DocusignFlutter.auth(authModel);
    setState(() {
      _accountInfoModel = result;
    });
  }

  Future<void> _createEnvelope() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (filePickerResult != null &&
        filePickerResult.files.single.path != null) {
      File file = File(filePickerResult.files.single.path!);
      Directory directory = await getApplicationDocumentsDirectory();
      File persistedFile = File("${directory.path}/sample.pdf");
      persistedFile.writeAsBytes(await file.readAsBytes());
      List<int> bytes = await file.readAsBytes();

      // documents
      DocumentModel document = DocumentModel(
          documentBase64: base64Encode(bytes),
          documentId: '<<NEED_CHANGE>>',
          fileExtension: '<<NEED_CHANGE>>',
          includeInDownload: false,
          name: '<<NEED_CHANGE>>');
      List<DocumentModel> documents = [document];

      // carbon copies
      CarbonCopyModel carbonCopy = CarbonCopyModel(
          email: '<<NEED_CHANGE>>',
          firstName: '<<NEED_CHANGE>>',
          lastName: '<<NEED_CHANGE>>',
          name: '<<NEED_CHANGE>>',
          recipientId: '<<NEED_CHANGE>>',
          routingOrder: '2',
          status: 'created');
      // sms authentication
      RecipientSmsAuthenticationModel smsAuthentication1 =
          RecipientSmsAuthenticationModel(
              senderProvidedNumbers: ['+33623374798']);
      RecipientSmsAuthenticationModel smsAuthentication2 =
          RecipientSmsAuthenticationModel(
              senderProvidedNumbers: ['<<NEED_CHANGE>>']);
      SignHereTabModel signHereTabModel1 = SignHereTabModel(
          anchorString: '<<NEED_CHANGE>>',
          anchorUnits: '<<NEED_CHANGE>>',
          anchorXOffset: '<<NEED_CHANGE>>',
          anchorYOffset: '<<NEED_CHANGE>>',
          status: 'active');
      SignHereTabModel signHereTabModel2 = SignHereTabModel(
          anchorString: '<<NEED_CHANGE>>',
          anchorUnits: '<<NEED_CHANGE>>',
          anchorXOffset: '<<NEED_CHANGE>>',
          anchorYOffset: '<<NEED_CHANGE>>',
          status: 'active');
      // tabs
      TabsModel tabs1 = TabsModel(signHereTabs: [signHereTabModel1]);
      TabsModel tabs2 = TabsModel(signHereTabs: [signHereTabModel2]);
      // signers
      SignerModel signer1 = SignerModel(
        clientUserId: '1',
        email: '<<NEED_CHANGE>>',
        firstName: '<<NEED_CHANGE>>',
        lastName: '<<NEED_CHANGE>>',
        name: '<<NEED_CHANGE>>',
        recipientId: '<<NEED_CHANGE>>',
        routingOrder: '<<NEED_CHANGE>>',
        smsAuthentication: smsAuthentication1,
        status: '<<NEED_CHANGE>>',
        tabs: tabs1,
        idCheckConfigurationName: 'SMS Auth \$',
        requireIdLookup: true,
      );
      SignerModel signer2 = SignerModel(
        clientUserId: '2',
        email: '<<NEED_CHANGE>>',
        firstName: '<<NEED_CHANGE>>',
        lastName: '<<NEED_CHANGE>>',
        name: '<<NEED_CHANGE>>',
        recipientId: '<<NEED_CHANGE>>',
        routingOrder: '<<NEED_CHANGE>>',
        smsAuthentication: smsAuthentication2,
        status: '<<NEED_CHANGE>>',
        tabs: tabs2,
        idCheckConfigurationName: 'SMS Auth \$',
        requireIdLookup: true,
      );

      // recipients
      RecipientsModel recipients = RecipientsModel(
          carbonCopies: [carbonCopy], signers: [signer1, signer2]);

      EnvelopeDefinitionModel body = EnvelopeDefinitionModel(
          documents: documents,
          emailSubject: '<<NEED_CHANGE>>',
          recipients: recipients,
          status: 'sent');

      var result = await DocusignFlutter.createEnvelope(accountId, body);
      setState(() {
        _envelopeId = result;
      });
    } else {
      // User canceled the picker
    }
  }

  Future<void> _captiveSigning() async {
    RecipientViewRequestModel requestViewRequestModel =
        RecipientViewRequestModel(
            authenticationMethod: "None",
            clientUserId: "<<NEED_CHANGE>>",
            email: "<<NEED_CHANGE>>",
            recipientId: "<<NEED_CHANGE>>",
            returnUrl: "http://www.google.com",
            userName: "<<NEED_CHANGE>>");

    var result = await DocusignFlutter.captiveSigning(
        accountId, _envelopeId ?? '', requestViewRequestModel);
    setState(() {
      _signingUrl = result;
    });
  }

  Future<void> _deleteDocuments() async {
    DeleteDocumentsModel deleteDocumentsModel =
        DeleteDocumentsModel(documentIds: ['1']);

    var result = await DocusignFlutter.deleteDocuments(
        accountId, _envelopeId ?? '', deleteDocumentsModel);
    setState(() {
      _modifiedEnvelopeIdDeleteDocument = result;
    });
  }

  Future<void> _getDocument() async {
    var result = await DocusignFlutter.getDocument(
        accountId, 'e27593fe-909c-43a7-a530-5a981fcc8658', '1');
    setState(() {
      _documentPath = result;
    });
  }

  Future<void> _addDocuments() async {
    Directory directory = await getApplicationDocumentsDirectory();
    File persistedFile = File("${directory.path}/sample.pdf");

    List<int> bytes = await persistedFile.readAsBytes();

    // documents
    DocumentModel document = DocumentModel(
        documentBase64: base64Encode(bytes),
        documentId: '<<NEED_CHANGE>>',
        fileExtension: '<<NEED_CHANGE>>',
        includeInDownload: false,
        name: '<<NEED_CHANGE>>');
    List<DocumentModel> documents = [document];

    AddDocumentsModel addDocumentsModel =
        AddDocumentsModel(documents: documents);

    var result = await DocusignFlutter.addDocuments(
        accountId, _envelopeId ?? '', addDocumentsModel);
    setState(() {
      _modifiedEnvelopeIdAddDocument = result;
    });
  }

  Future<void> _createRecipientTabs() async {
    SignHereTabModel signHereTabModel = SignHereTabModel(
        anchorString: '<<NEED_CHANGE>>',
        anchorUnits: '<<NEED_CHANGE>>',
        anchorXOffset: '<<NEED_CHANGE>>',
        anchorYOffset: '<<NEED_CHANGE>>',
        status: '<<NEED_CHANGE>>');
    // tabs
    TabsModel tabs = TabsModel(signHereTabs: [signHereTabModel]);

    var result = await DocusignFlutter.createRecipientTabs(
        accountId, _envelopeId ?? '', '<<NEED_CHANGE>>', tabs);
    setState(() {
      _modifiedEnvelopeIdCreateTabs = result;
    });
  }

  Future<void> _updateRecipients() async {
    // sms authentication
    RecipientSmsAuthenticationModel smsAuthentication =
        RecipientSmsAuthenticationModel(
            senderProvidedNumbers: ['<<NEED_CHANGE>>']);
    SignHereTabModel signHereTabModel = SignHereTabModel(
        anchorString: '<<NEED_CHANGE>>',
        anchorUnits: '<<NEED_CHANGE>>',
        anchorXOffset: '<<NEED_CHANGE>>',
        anchorYOffset: '<<NEED_CHANGE>>',
        status: '<<NEED_CHANGE>>');
    // tabs
    TabsModel tabs = TabsModel(signHereTabs: [signHereTabModel]);
    // signers
    SignerModel signer = SignerModel(
      clientUserId: '<<NEED_CHANGE>>',
      email: '<<NEED_CHANGE>>',
      firstName: '<<NEED_CHANGE>>',
      lastName: '<<NEED_CHANGE>>',
      name: '<<NEED_CHANGE>>',
      recipientId: '<<NEED_CHANGE>>',
      routingOrder: '<<NEED_CHANGE>>',
      smsAuthentication: smsAuthentication,
      status: '<<NEED_CHANGE>>',
      tabs: tabs,
      idCheckConfigurationName: 'SMS Auth \$',
      requireIdLookup: true,
    );

    // recipients
    RecipientsModel recipients =
        RecipientsModel(carbonCopies: [], signers: [signer]);

    var result = await DocusignFlutter.updateRecipients(
        accountId, _envelopeId ?? '', recipients);
    setState(() {
      _modifiedEnvelopeIdUpdatedRecipients = result;
    });
  }

  void _onEvent(Object? event) {
    setState(() {
      _docusignObserver = event.toString();
    });
  }

  void _onError(Object error) {
    setState(() {
      _docusignObserver = error.toString();
    });
  }

  Future<void> _offlineSigning() async {
    var result = false;
    try {
      await DocusignFlutter.offlineSigning(_envelopeId ?? '');
      result = true;
    } on Exception {
      result = false;
    }

    setState(() {
      _offlineSigningStatus = result;
    });
  }

  Future<void> _syncingEnvelopes() async {
    var result = false;
    try {
      await DocusignFlutter.syncEnvelopes();
      result = true;
    } on Exception {
      result = false;
    }
    setState(() {
      _syncingStatus = result;
    });
  }

  String _convertStatus(bool? status) {
    if (status != null) {
      return status ? 'success' : 'failed';
    }
    return 'none';
  }
}
