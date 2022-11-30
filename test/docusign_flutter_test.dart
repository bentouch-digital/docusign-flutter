import 'package:flutter_test/flutter_test.dart';
import 'package:docusign_flutter/docusign_flutter.dart';
import 'package:docusign_flutter/docusign_flutter_platform_interface.dart';
import 'package:docusign_flutter/docusign_flutter_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockDocusignFlutterPlatform
    with MockPlatformInterfaceMixin
    implements DocusignFlutterPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final DocusignFlutterPlatform initialPlatform = DocusignFlutterPlatform.instance;

  test('$MethodChannelDocusignFlutter is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelDocusignFlutter>());
  });

  test('getPlatformVersion', () async {
    DocusignFlutter docusignFlutterPlugin = DocusignFlutter();
    MockDocusignFlutterPlatform fakePlatform = MockDocusignFlutterPlatform();
    DocusignFlutterPlatform.instance = fakePlatform;

    expect(await docusignFlutterPlugin.getPlatformVersion(), '42');
  });
}
