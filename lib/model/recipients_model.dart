import 'package:docusign_flutter/model/carbon_copy_model.dart';
import 'package:docusign_flutter/model/signer_model.dart';

class RecipientsModel {
  late final List<CarbonCopyModel> carbonCopies;
  late final List<SignerModel> signers;

  RecipientsModel({
    required this.carbonCopies,
    required this.signers,
  });

  RecipientsModel.fromJson(Map<String, dynamic> json)
      : carbonCopies = json['carbonCopies'],
        signers = json['signers'];

  Map<String, dynamic> toJson() => {
        'carbonCopies': carbonCopies,
        'signers': signers,
      };
}
