// ignore_for_file: avoid_print

import 'package:gnome_shell_extension_service/gnome_shell_extension_service.dart';

Future<void> main() async {
  final service = GnomeShellExtensionService();
  await service.init();

  for (var i = 0; i < 10; i++) {
    await getPage(service, i);
  }

  await service.dispose();
}

Future<void> getPage(GnomeShellExtensionService service, int page) async {
  final extensionsPage = await service.getRemoteExtensions(
    gnomeShellVersion: '42.5',
    query: 'dock',
    page: page,
  );

  if (extensionsPage.isNotEmpty) {
    print('~~~~~~~~ PAGE: $page ~~~~~~~~\n');

    for (var e in extensionsPage) {
      print('Name: ${e.name} | uuid: ${e.uuid}');
      print(e.screenShotUrl);
    }

    print('\n');
  }
}
