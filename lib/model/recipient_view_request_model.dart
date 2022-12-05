class RecipientViewRequestModel {
  late final String authenticationMethod;
  late final String clientUserId;
  late final String email;
  late final String recipientId;
  late final String returnUrl;
  late final String userName;

  RecipientViewRequestModel({
    required this.authenticationMethod,
    required this.clientUserId,
    required this.email,
    required this.recipientId,
    required this.returnUrl,
    required this.userName,
  });

  RecipientViewRequestModel.fromJson(Map<String, dynamic> json)
      : authenticationMethod = json['authenticationMethod'],
        clientUserId = json['clientUserId'],
        email = json['email'],
        recipientId = json['recipientId'],
        returnUrl = json['returnUrl'],
        userName = json['userName'];

  Map<String, dynamic> toJson() => {
        'authenticationMethod': authenticationMethod,
        'clientUserId': clientUserId,
        'email': email,
        'recipientId': recipientId,
        'returnUrl': returnUrl,
        'userName': userName,
      };
}
