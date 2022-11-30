import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
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
  String _platformVersion = 'Unknown';
  final _docusignFlutterPlugin = DocusignFlutter();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion = await _docusignFlutterPlugin.getPlatformVersion() ??
          'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
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
                  Text('Token status: ${_accessTokenModel?.access_token}\n'),
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
}
