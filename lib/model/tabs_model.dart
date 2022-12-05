import 'package:docusign_flutter/model/sign_here_tab_model.dart';

class TabsModel {
  late final List<SignHereTabModel> signHereTabs;

  TabsModel({
    required this.signHereTabs,
  });

  TabsModel.fromJson(Map<String, dynamic> json)
      : signHereTabs = json['signHereTabs'];

  Map<String, dynamic> toJson() => {
        'signHereTabs': signHereTabs,
      };
}
