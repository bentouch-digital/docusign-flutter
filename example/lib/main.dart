import 'dart:developer';
import 'package:docusign_flutter/model/access_token_model.dart';
import 'package:docusign_flutter/model/account_info.dart';
import 'package:docusign_flutter/model/auth_model.dart';
import 'package:docusign_flutter/model/envelope_model.dart';
import 'package:docusign_flutter/model/input_token_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:docusign_flutter/docusign_flutter.dart';

String accessToken = r'<<NEED_CHANGE>>';
const String accountId = r'<<NEED_CHANGE>>';
const String email = r'<<NEED_CHANGE>>';
const int expiresIn = 28800;
const String host = r'https://demo.docusign.net/restapi';
const String integratorKey = r'<<NEED_CHANGE>>';
const String userId = r'<<NEED_CHANGE>>';
const String userName = r'<<NEED_CHANGE>>';
const String publicRSAKey = r'''<<NEED_CHANGE>>''';
const privateRSAKey = r'''<<NEED_CHANGE>>''';

const String envelopeId = r'<<NEED_CHANGE>>';
const String recipientClientUserId = r'<<NEED_CHANGE>>';
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
  String? _offlineEnvelopeId;
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
                      child:
                          Text('Envelope Id (OFFLINE):$_offlineEnvelopeId\n')),
                  ElevatedButton(
                    onPressed: () => _createOfflineEnvelope(),
                    child: const Text('Create offline enveloppe'),
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

  Future<void> _createOfflineEnvelope() async {
    FilePickerResult? filePickerResult = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);

    if (filePickerResult != null &&
        filePickerResult.files.single.path != null) {
      // File file = File(filePickerResult.files.single.path!);
      var envelopeModel = EnvelopeModel(
        filePath: filePickerResult.files.single.path!,
        envelopeName: 'test',
        envelopeSubject: 'test',
        envelopeMessage: 'message',
        hostName: 'Mbola Raharison',
        hostEmail: 'raharison.m@bentouch-digital.com',
        inPersonSignerName: 'Mbolatina Arimanana Raharison',
        inPersonSignerEmail: 'mb.raharison@gmail.com',
        signerName: 'Mbolatina Arimanana Raharison',
        signerEmail: 'mb.raharison@gmail.com',
        signers: ['Mbola', 'Aina'],
      );
      var result = await DocusignFlutter.createEnvelope(envelopeModel);
      setState(() {
        _offlineEnvelopeId = result;
      });
    } else {
      // User canceled the picker
    }
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
      await DocusignFlutter.offlineSigning(_offlineEnvelopeId ?? '');
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
      log('sync true ');
      result = true;
    } on Exception {
      log('sync false ');
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
