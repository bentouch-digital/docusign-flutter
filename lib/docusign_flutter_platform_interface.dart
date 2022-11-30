import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'docusign_flutter_method_channel.dart';

abstract class DocusignFlutterPlatform extends PlatformInterface {
  /// Constructs a DocusignFlutterPlatform.
  DocusignFlutterPlatform() : super(token: _token);

  static final Object _token = Object();

  static DocusignFlutterPlatform _instance = MethodChannelDocusignFlutter();

  /// The default instance of [DocusignFlutterPlatform] to use.
  ///
  /// Defaults to [MethodChannelDocusignFlutter].
  static DocusignFlutterPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [DocusignFlutterPlatform] when
  /// they register themselves.
  static set instance(DocusignFlutterPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
