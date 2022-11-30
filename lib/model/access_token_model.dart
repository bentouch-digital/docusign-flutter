class AccessTokenModel {
  late final String accessToken;
  late final String tokenType;
  late final int expiresIn;

  AccessTokenModel({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
  });

  AccessTokenModel.fromJson(Map<String, dynamic> json)
      : accessToken = json['access_token'],
        tokenType = json['token_type'],
        expiresIn = json['expires_in'];

  Map<String, dynamic> toJson() => {
        'alg': accessToken,
        'token_type': tokenType,
        'expires_in': expiresIn,
      };
}
