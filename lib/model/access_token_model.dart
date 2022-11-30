class AccessTokenModel {
  late final String access_token;
  late final String token_type;
  late final int expires_in;

  AccessTokenModel({
    required this.access_token,
    required this.token_type,
    required this.expires_in,
  });

  AccessTokenModel.fromJson(Map<String, dynamic> json)
      : access_token = json['access_token'],
        token_type = json['token_type'],
        expires_in = json['expires_in'];

  Map<String, dynamic> toJson() => {
        'alg': access_token,
        'token_type': token_type,
        'expires_in': expires_in,
      };
}
