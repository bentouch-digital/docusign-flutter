import 'dart:async';
import 'dart:convert';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:docusign_flutter/model/access_token_model.dart';
import 'package:docusign_flutter/model/add_documents_model.dart';
import 'package:docusign_flutter/model/delete_documents_model.dart';
import 'package:docusign_flutter/model/envelope_definition_model.dart';
import 'package:docusign_flutter/model/input_token_model.dart';
import 'package:docusign_flutter/model/recipient_view_request_model.dart';
import 'package:docusign_flutter/model/recipients_model.dart';
import 'package:docusign_flutter/model/tabs_model.dart';
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

  static Future<String?> createEnvelope(
      String accountId, EnvelopeDefinitionModel body) async {
    String jsonBody = jsonEncode(body);
    return await _methodsChannel
        .invokeMethod<dynamic>('createEnvelope', [accountId, jsonBody]);
  }

  static Future<void> offlineSigning(String envelopeId) async {
    await _methodsChannel.invokeMethod('offlineSigning', [envelopeId]);
  }

  static Future<void> syncEnvelopes() async {
    await _methodsChannel.invokeMethod('syncEnvelopes');
  }

  static Future<String?> captiveSigning(String accountId, String envelopeId,
      RecipientViewRequestModel recipientViewRequest) async {
    String jsonRecipientViewRequest = jsonEncode(recipientViewRequest);
    return await _methodsChannel.invokeMethod(
        'captiveSinging', [accountId, envelopeId, jsonRecipientViewRequest]);
  }

  static Future<String?> deleteDocuments(String accountId, String envelopeId,
      DeleteDocumentsModel deleteDocumentsModel) async {
    String jsonDeleteDocumentsModel = jsonEncode(deleteDocumentsModel);
    return await _methodsChannel.invokeMethod(
        'deleteDocuments', [accountId, envelopeId, jsonDeleteDocumentsModel]);
  }

  static Future<String?> addDocuments(String accountId, String envelopeId,
      AddDocumentsModel addDocumentsModel) async {
    String jsonAddDocumentsModel = jsonEncode(addDocumentsModel);
    return await _methodsChannel.invokeMethod(
        'addDocuments', [accountId, envelopeId, jsonAddDocumentsModel]);
  }

  static Future<String?> updateRecipients(String accountId, String envelopeId,
      RecipientsModel recipientsModel) async {
    String jsonRecipientsModel = jsonEncode(recipientsModel);
    return await _methodsChannel.invokeMethod(
        'updateRecipients', [accountId, envelopeId, jsonRecipientsModel]);
  }

  static Future<String?> deleteRecipients(String accountId, String envelopeId,
      RecipientsModel recipientsModel) async {
    String jsonRecipientsModel = jsonEncode(recipientsModel);
    return await _methodsChannel.invokeMethod(
        'deleteRecipients', [accountId, envelopeId, jsonRecipientsModel]);
  }

  static Future<String?> createRecipientTabs(String accountId,
      String envelopeId, String recipientId, TabsModel tabsModel) async {
    String jsonTabsModel = jsonEncode(tabsModel);
    return await _methodsChannel.invokeMethod('createRecipientTabs',
        [accountId, envelopeId, recipientId, jsonTabsModel]);
  }

  static String _generateJWT(InputTokenModel inputTokenModel) {
    final jwt = JWT({
      'iat': (DateTime.now().millisecondsSinceEpoch / 1000).floor(),
      'exp': (DateTime.now()
                  .add(const Duration(minutes: 2))
                  .millisecondsSinceEpoch /
              1000)
          .floor(),
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
