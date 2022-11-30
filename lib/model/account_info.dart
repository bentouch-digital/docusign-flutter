class AccountInfoModel {
  late final String accountId;
  late final String accountName;
  late final String email;
  late final String userName;
  late final String userId;

  AccountInfoModel({
    required this.accountId,
    required this.accountName,
    required this.email,
    required this.userName,
    required this.userId,
  });

  AccountInfoModel.fromJson(Map<String, dynamic> json)
      : accountId = json['accountId'],
        accountName = json['accountName'],
        email = json['email'],
        userName = json['userName'],
        userId = json['userId'];

  Map<String, dynamic> toJson() => {
        'accountId': accountId,
        'accountName': accountName,
        'email': email,
        'userName': userName,
        'userId': userId,
      };
}
