class DeleteRecipientsModel {
  late final List<String> recipientIds;

  DeleteRecipientsModel({
    required this.recipientIds,
  });

  DeleteRecipientsModel.fromJson(Map<String, dynamic> json)
      : recipientIds = json['recipientIds'];

  Map<String, dynamic> toJson() => {
        'recipientIds': recipientIds,
      };
}
