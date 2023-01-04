import 'package:gnome_shell_extension_service/gnome_shell_extension_service.dart';

Future<void> main() async {
  final service = GnomeShellExtensionService();
  await service.init();

  final ext = await service.getRemoteExtensions('42.5', 'dock');

  for (var e in ext) {
    print(e.name);
    for (var v in e.shellVersionMap.entries) {
      print('${v.key}: ${v.value}');
    }
  }

  service.dispose();
}
