library gnome_shell_extensions;

import 'dart:async';
import 'dart:convert';

import 'package:dbus/dbus.dart';
import 'package:gnome_shell_extension_service/src/gnome_shell_extension.dart';
import 'package:http/http.dart' as http;

import 'constants.dart';

class GnomeShellExtensionService {
  GnomeShellExtensionService() : _object = _createObject();

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  static DBusRemoteObject _createObject() => DBusRemoteObject(
        DBusClient.session(),
        name: kGnomeShellExtensionsInterface,
        path: DBusObjectPath(kGnomeShellExtensionsPath),
      );

  Future<void> init() async {
    await _initGnomeShellVersion();
    await _initUserExtensionsEnabled();
    _propertyListener ??= _object.propertiesChanged.listen(_updateProperties);
  }

  Future<void> dispose() async {
    await _propertyListener?.cancel();
    await _object.client.close();
    _propertyListener = null;
  }

  void _updateProperties(DBusPropertiesChangedSignal signal) {
    if (signal.extensionsEnabledChanged) {
      _object.getUserExtensionsEnabled().then(_updateUserExtensionEnabled);
    }
  }

  bool? _userExtensionsEnabled;
  bool? get userExtensionsEnabled => _userExtensionsEnabled;
  set userExtensionsEnabled(bool? value) {
    if (value == null) return;
    _object.setUserExtensionsEnabled(value);
  }

  final _userExtensionsEnabledController = StreamController<bool?>.broadcast();
  Stream<bool?> get userExtensionsEnabledChanged =>
      _userExtensionsEnabledController.stream;

  void _updateUserExtensionEnabled(bool? value) {
    if (value == null) return;
    _userExtensionsEnabled = value;
    if (!_userExtensionsEnabledController.isClosed) {
      _userExtensionsEnabledController.add(_userExtensionsEnabled);
    }
  }

  String? _gnomeShellVersion;
  String? get gnomeShellVersion => _gnomeShellVersion;

  final _gnomeShellVersionController = StreamController<String?>.broadcast();
  Stream<String?> get gnomeShellVersionChanged =>
      _gnomeShellVersionController.stream;

  void _updateGnomeShellVersion(String? value) {
    if (value == _gnomeShellVersion) return;
    _gnomeShellVersion = value;
    if (!_gnomeShellVersionController.isClosed) {
      _gnomeShellVersionController.add(_gnomeShellVersion);
    }
  }

  Future<void> _initGnomeShellVersion() async {
    _updateGnomeShellVersion(await _object.getShellVersion());
  }

  Future<void> _initUserExtensionsEnabled() async {
    _updateUserExtensionEnabled(await _object.getUserExtensionsEnabled());
  }

  /// Invokes org.gnome.Shell.Extensions.ListExtensions()
  Future<Map<String, Map<String, DBusValue>>> listExtensions({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      await _object.callListExtensions(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.GetExtensionInfo()
  Future<Map<String, DBusValue>> getExtensionInfo(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) =>
      _object.callGetExtensionInfo(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.GetExtensionErrors()
  Future<List<String>> getExtensionErrors(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callGetExtensionErrors(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.InstallRemoteExtension()
  Future<String> installRemoteExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callInstallRemoteExtension(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.UninstallExtension()
  Future<bool> uninstallExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callUninstallExtension(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.ReloadExtension()
  Future<void> reloadExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callReloadExtension(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.EnableExtension()
  Future<bool> enableExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callEnableExtension(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.DisableExtension()
  Future<bool> disableExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callDisableExtension(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.LaunchExtensionPrefs()
  Future<void> launchExtensionPrefs(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callLaunchExtensionPrefs(
        uuid,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.OpenExtensionPrefs()
  Future<void> openExtensionPrefs(
    String uuid,
    String parentWindow,
    Map<String, DBusValue> options, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callOpenExtensionPrefs(
        uuid,
        parentWindow,
        options,
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  /// Invokes org.gnome.Shell.Extensions.CheckForUpdates()
  Future<void> checkForUpdates({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async =>
      _object.callCheckForUpdates(
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization,
      );

  Future<List<GnomeShellExtension>> getRemoteExtensions({
    required String gnomeShellVersion,
    required String query,
    required int page,
  }) async {
    final url =
        '$kApiUrl?search=$query&shell_version=$gnomeShellVersion&page=$page';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final exts = jsonResponse['extensions'] as List;

      return exts.map((e) => GnomeShellExtension.fromMap(e)).toList();
    } else {
      return <GnomeShellExtension>[];
    }
  }
}

extension _GnomeShellExtensionsRemoteObject on DBusRemoteObject {
  /// Gets org.gnome.Shell.Extensions.ShellVersion
  Future<String> getShellVersion() async {
    var value = await getProperty(
      kGnomeShellExtensionsInterface,
      kShellVersionProperty,
      signature: DBusSignature('s'),
    );
    return value.asString();
  }

  /// Gets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<bool> getUserExtensionsEnabled() async {
    var value = await getProperty(
      kGnomeShellExtensionsInterface,
      kUserExtensionsEnabledProperty,
      signature: DBusSignature('b'),
    );
    return value.asBoolean();
  }

  /// Sets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<void> setUserExtensionsEnabled(bool value) async {
    await setProperty(
      kGnomeShellExtensionsInterface,
      kUserExtensionsEnabledProperty,
      DBusBoolean(value),
    );
  }

  /// Invokes org.gnome.Shell.Extensions.ListExtensions()
  Future<Map<String, Map<String, DBusValue>>> callListExtensions({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kListExtensionsMethod,
      [],
      replySignature: DBusSignature('a{sa{sv}}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asDict().map(
          (key, value) => MapEntry(key.asString(), value.asStringVariantDict()),
        );
  }

  /// Invokes org.gnome.Shell.Extensions.GetExtensionInfo()
  Future<Map<String, DBusValue>> callGetExtensionInfo(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kGetExtensionInfoMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('a{sv}'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asStringVariantDict();
  }

  /// Invokes org.gnome.Shell.Extensions.GetExtensionErrors()
  Future<List<String>> callGetExtensionErrors(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kGetExtensionErrorsMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('as'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes org.gnome.Shell.Extensions.InstallRemoteExtension()
  Future<String> callInstallRemoteExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kInstallRemoteExtensionMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('s'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asString();
  }

  /// Invokes org.gnome.Shell.Extensions.UninstallExtension()
  Future<bool> callUninstallExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kUninstallExtensionMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('b'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.ReloadExtension()
  Future<void> callReloadExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      kGnomeShellExtensionsInterface,
      kReloadExtensionMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.gnome.Shell.Extensions.EnableExtension()
  Future<bool> callEnableExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kEnableExtensionMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('b'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.DisableExtension()
  Future<bool> callDisableExtension(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    var result = await callMethod(
      kGnomeShellExtensionsInterface,
      kDisableExtensionMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature('b'),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.LaunchExtensionPrefs()
  Future<void> callLaunchExtensionPrefs(
    String uuid, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      kGnomeShellExtensionsInterface,
      kLaunchExtensionPrefsMethod,
      [DBusString(uuid)],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.gnome.Shell.Extensions.OpenExtensionPrefs()
  Future<void> callOpenExtensionPrefs(
    String uuid,
    String parentWindow,
    Map<String, DBusValue> options, {
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      kGnomeShellExtensionsInterface,
      kOpenExtensionPrefsMethod,
      [
        DBusString(uuid),
        DBusString(parentWindow),
        DBusDict.stringVariant(options)
      ],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }

  /// Invokes org.gnome.Shell.Extensions.CheckForUpdates()
  Future<void> callCheckForUpdates({
    bool noAutoStart = false,
    bool allowInteractiveAuthorization = false,
  }) async {
    await callMethod(
      kGnomeShellExtensionsInterface,
      kCheckForUpdatesMethod,
      [],
      replySignature: DBusSignature(''),
      noAutoStart: noAutoStart,
      allowInteractiveAuthorization: allowInteractiveAuthorization,
    );
  }
}

extension _ChangedGnomeShellExtensions on DBusPropertiesChangedSignal {
  bool get extensionsEnabledChanged =>
      changedProperties.containsKey(kUserExtensionsEnabledProperty);
}
