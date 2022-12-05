class RecipientSmsAuthenticationModel {
  late final List<String> senderProvidedNumbers;

  RecipientSmsAuthenticationModel({
    required this.senderProvidedNumbers,
  });

  RecipientSmsAuthenticationModel.fromJson(Map<String, dynamic> json)
      : senderProvidedNumbers = json['senderProvidedNumbers'];

  Map<String, dynamic> toJson() => {
        'senderProvidedNumbers': senderProvidedNumbers,
      };
}
