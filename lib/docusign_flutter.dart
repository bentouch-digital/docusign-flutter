
import 'docusign_flutter_platform_interface.dart';

class DocusignFlutter {
  Future<String?> getPlatformVersion() {
    return DocusignFlutterPlatform.instance.getPlatformVersion();
  }
}
