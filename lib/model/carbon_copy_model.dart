class CarbonCopyModel {
  late final String email;
  late final String firstName;
  late final String lastName;
  late final String name;
  late final String recipientId;
  late final String routingOrder;
  late final String status;

  CarbonCopyModel({
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.recipientId,
    required this.routingOrder,
    required this.status,
  });

  CarbonCopyModel.fromJson(Map<String, dynamic> json)
      : email = json['email'],
        firstName = json['firstName'],
        lastName = json['lastName'],
        name = json['name'],
        recipientId = json['recipientId'],
        routingOrder = json['routingOrder'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'email': email,
        'firstName': firstName,
        'lastName': lastName,
        'name': name,
        'recipientId': recipientId,
        'routingOrder': routingOrder,
        'status': status,
      };
}
