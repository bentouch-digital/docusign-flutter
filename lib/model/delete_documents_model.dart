class DeleteDocumentsModel {
  late final List<String> documentIds;

  DeleteDocumentsModel({
    required this.documentIds,
  });

  DeleteDocumentsModel.fromJson(Map<String, dynamic> json)
      : documentIds = json['documentIds'];

  Map<String, dynamic> toJson() => {
        'documentIds': documentIds,
      };
}
