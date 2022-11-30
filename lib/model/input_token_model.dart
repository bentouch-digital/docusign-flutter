class InputTokenModel {
  late final String url;
  late final String urlPath;
  late final String integratorKey;
  late final String userId;
  late final String publicRSAKey;
  late final String privateRSAKey;

  InputTokenModel({
    required this.url,
    required this.urlPath,
    required this.integratorKey,
    required this.userId,
    required this.publicRSAKey,
    required this.privateRSAKey,
  });

  InputTokenModel.fromJson(Map<String, dynamic> json)
      : url = json['url'],
        urlPath = json['urlPath'],
        integratorKey = json['integratorKey'],
        userId = json['userId'],
        publicRSAKey = json['publicRSAKey'],
        privateRSAKey = json['privateRSAKey'];

  Map<String, dynamic> toJson() => {
        'url': url,
        'urlPath': urlPath,
        'integratorKey': integratorKey,
        'userId': userId,
        'publicRSAKey': publicRSAKey,
        'privateRSAKey': privateRSAKey,
      };
}
