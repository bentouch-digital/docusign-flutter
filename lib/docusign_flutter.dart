import 'dart:async';
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:docusign_flutter/model/access_token_model.dart';
import 'package:docusign_flutter/model/captive_signing_model.dart';
import 'package:docusign_flutter/model/envelope_model.dart';
import 'package:docusign_flutter/model/input_token_model.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'model/account_info.dart';
import 'model/auth_model.dart';

class DocusignFlutter {
  static const MethodChannel _methodsChannel =
      MethodChannel('docusign_flutter/methods');
  static const EventChannel _eventChannel =
      EventChannel('docusign_flutter/observer');

  static Future<AccessTokenModel?> getAccessToken(
      InputTokenModel inputTokenModel) async {
    var jwtToken = _generateJWT(inputTokenModel);
    var urlParams = {
      'assertion': jwtToken,
      'grant_type': 'urn:ietf:params:oauth:grant-type:jwt-bearer',
    };
    var url =
        Uri.https(inputTokenModel.url, inputTokenModel.urlPath, urlParams);
    var response = await http.post(url);
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;
      return AccessTokenModel.fromJson(jsonResponse);
    } else {
      return null;
    }
  }

  static Future<AccountInfoModel?> auth(AuthModel authModel) async {
    String json = jsonEncode(authModel);
    var accountInfoJson =
        await _methodsChannel.invokeMethod<dynamic>('login', [json]);
    if (accountInfoJson != null) {
      return AccountInfoModel.fromJson(jsonDecode(accountInfoJson));
    }
    return null;
  }

  static Future<String?> createEnvelope(EnvelopeModel envelopeModel) async {
    String json = jsonEncode(envelopeModel);
    return await _methodsChannel
        .invokeMethod<dynamic>('createEnvelope', [json]);
  }

  static Future<void> offlineSigning(String envelopeId) async {
    await _methodsChannel.invokeMethod('offlineSigning', [envelopeId]);
  }

  static Future<void> syncEnvelopes() async {
    await _methodsChannel.invokeMethod('syncEnvelopes');
  }

  static Future<void> captiveSigning(
      CaptiveSigningModel captiveSigningModel) async {
    String json = jsonEncode(captiveSigningModel);
    await _methodsChannel.invokeMethod('captiveSinging', [json]);
  }

  static String _generateJWT(InputTokenModel inputTokenModel) {
    final jwt = JWT({
      'iat': (DateTime.now().millisecondsSinceEpoch / 1000).floor().toString(),
      'exp': (DateTime.now()
                  .add(const Duration(minutes: 2))
                  .millisecondsSinceEpoch /
              1000)
          .floor()
          .toString(),
      'scope': 'signature impersonation'
    },
        audience: Audience([inputTokenModel.url]),
        subject: inputTokenModel.userId,
        issuer: inputTokenModel.integratorKey);
    final key = RSAPrivateKey(inputTokenModel.privateRSAKey);
    String token = jwt.sign(key, algorithm: JWTAlgorithm.RS256);
    return token;
  }

  static void listenObserver(
      void Function(dynamic)? onEvent, Function onError) {
    _eventChannel.receiveBroadcastStream().listen(onEvent, onError: onError);
  }
}
