class SignHereTabModel {
  late final String anchorString;
  late final String anchorUnits;
  late final String anchorXOffset;
  late final String anchorYOffset;
  late final String status;

  SignHereTabModel({
    required this.anchorString,
    required this.anchorUnits,
    required this.anchorXOffset,
    required this.anchorYOffset,
    required this.status,
  });

  SignHereTabModel.fromJson(Map<String, dynamic> json)
      : anchorString = json['anchorString'],
        anchorUnits = json['anchorUnits'],
        anchorXOffset = json['anchorXOffset'],
        anchorYOffset = json['anchorYOffset'],
        status = json['status'];

  Map<String, dynamic> toJson() => {
        'anchorString': anchorString,
        'anchorUnits': anchorUnits,
        'anchorXOffset': anchorXOffset,
        'anchorYOffset': anchorYOffset,
        'status': status,
      };
}
