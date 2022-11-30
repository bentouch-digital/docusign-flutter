import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'docusign_flutter_platform_interface.dart';

/// An implementation of [DocusignFlutterPlatform] that uses method channels.
class MethodChannelDocusignFlutter extends DocusignFlutterPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('docusign_flutter');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
