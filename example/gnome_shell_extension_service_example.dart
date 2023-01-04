// ignore_for_file: avoid_print

import 'package:dbus/dbus.dart';
import 'package:gnome_shell_extension_service/gnome_shell_extension_service.dart';

Future<void> main() async {
  final service = GnomeShellExtensionService();
  await service.init();

  final installedExtensions = await service.listExtensions();

  print('~~~~~~~~ Installed extensions ~~~~~~~~\n');
  for (var e in installedExtensions.entries) {
    print(e.key);
  }
  print('\n');

  for (var i = 0; i < 10; i++) {
    await _getPage(service, i, installedExtensions);
  }

  await service.dispose();
}

Future<void> _getPage(
  GnomeShellExtensionService service,
  int page,
  Map<String, Map<String, DBusValue>> installedExtensions,
) async {
  final extensionsPage = await service.getRemoteExtensions(
    query: 'theme',
    page: page,
  );

  if (extensionsPage.isNotEmpty) {
    print('~~~~~~~~ PAGE: $page ~~~~~~~~\n');

    for (var e in extensionsPage) {
      bool installed = installedExtensions.containsKey(e.uuid);
      print(
        'Name: ${e.name} | uuid: ${e.uuid} ${installed ? '(INSTALLED ✅)' : ''} ',
      );
      print(e.screenShotUrl);
      print(e.iconUrl);
    }

    print('\n');
  }
}
