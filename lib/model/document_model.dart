class DocumentModel {
  late final String documentBase64;
  late final String documentId;
  late final String fileExtension;
  late final bool includeInDownload;
  late final String name;

  DocumentModel({
    required this.documentBase64,
    required this.documentId,
    required this.fileExtension,
    required this.includeInDownload,
    required this.name,
  });

  DocumentModel.fromJson(Map<String, dynamic> json)
      : documentBase64 = json['documentBase64'],
        documentId = json['documentId'],
        fileExtension = json['fileExtension'],
        includeInDownload = json['includeInDownload'],
        name = json['name'];

  Map<String, dynamic> toJson() => {
        'documentBase64': documentBase64,
        'documentId': documentId,
        'fileExtension': fileExtension,
        'includeInDownload': includeInDownload,
        'name': name,
      };
}
