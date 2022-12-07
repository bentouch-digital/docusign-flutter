import 'package:docusign_flutter/model/document_model.dart';

class AddDocumentsModel {
  late final List<DocumentModel> documents;

  AddDocumentsModel({
    required this.documents,
  });

  AddDocumentsModel.fromJson(Map<String, dynamic> json)
      : documents = json['documents'];

  Map<String, dynamic> toJson() => {
        'documents': documents,
      };
}
