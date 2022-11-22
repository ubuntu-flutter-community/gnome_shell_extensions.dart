import 'package:dbus/dbus.dart';

/// Signal data for org.gnome.Shell.Extensions.ExtensionStateChanged.
class OrgGnomeShellExtensionsExtensionStateChanged extends DBusSignal {
  String get uuid => values[0].asString();
  Map<String, DBusValue> get state => values[1].asStringVariantDict();

  OrgGnomeShellExtensionsExtensionStateChanged(DBusSignal signal)
      : super(
            sender: signal.sender,
            path: signal.path,
            interface: signal.interface,
            name: signal.name,
            values: signal.values);
}

/// Signal data for org.gnome.Shell.Extensions.ExtensionStatusChanged.
class OrgGnomeShellExtensionsExtensionStatusChanged extends DBusSignal {
  String get uuid => values[0].asString();
  int get state => values[1].asInt32();
  String get error => values[2].asString();

  OrgGnomeShellExtensionsExtensionStatusChanged(DBusSignal signal)
      : super(
            sender: signal.sender,
            path: signal.path,
            interface: signal.interface,
            name: signal.name,
            values: signal.values);
}

class OrgGnomeShellExtensions extends DBusRemoteObject {
  /// Stream of org.gnome.Shell.Extensions.ExtensionStateChanged signals.
  late final Stream<OrgGnomeShellExtensionsExtensionStateChanged>
      extensionStateChanged;

  /// Stream of org.gnome.Shell.Extensions.ExtensionStatusChanged signals.
  late final Stream<OrgGnomeShellExtensionsExtensionStatusChanged>
      extensionStatusChanged;

  OrgGnomeShellExtensions(
      DBusClient client, String destination, DBusObjectPath path)
      : super(client, name: destination, path: path) {
    extensionStateChanged = DBusRemoteObjectSignalStream(
            object: this,
            interface: 'org.gnome.Shell.Extensions',
            name: 'ExtensionStateChanged',
            signature: DBusSignature('sa{sv}'))
        .asBroadcastStream()
        .map((signal) => OrgGnomeShellExtensionsExtensionStateChanged(signal));

    extensionStatusChanged = DBusRemoteObjectSignalStream(
            object: this,
            interface: 'org.gnome.Shell.Extensions',
            name: 'ExtensionStatusChanged',
            signature: DBusSignature('sis'))
        .asBroadcastStream()
        .map((signal) => OrgGnomeShellExtensionsExtensionStatusChanged(signal));
  }

  /// Gets org.gnome.Shell.Extensions.ShellVersion
  Future<String> getShellVersion() async {
    var value = await getProperty('org.gnome.Shell.Extensions', 'ShellVersion',
        signature: DBusSignature('s'));
    return value.asString();
  }

  /// Gets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<bool> getUserExtensionsEnabled() async {
    var value = await getProperty(
        'org.gnome.Shell.Extensions', 'UserExtensionsEnabled',
        signature: DBusSignature('b'));
    return value.asBoolean();
  }

  /// Sets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<void> setUserExtensionsEnabled(bool value) async {
    await setProperty('org.gnome.Shell.Extensions', 'UserExtensionsEnabled',
        DBusBoolean(value));
  }

  /// Invokes org.gnome.Shell.Extensions.ListExtensions()
  Future<Map<String, Map<String, DBusValue>>> callListExtensions(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'ListExtensions', [],
        replySignature: DBusSignature('a{sa{sv}}'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asDict().map(
        (key, value) => MapEntry(key.asString(), value.asStringVariantDict()));
  }

  /// Invokes org.gnome.Shell.Extensions.GetExtensionInfo()
  Future<Map<String, DBusValue>> callGetExtensionInfo(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'GetExtensionInfo', [DBusString(uuid)],
        replySignature: DBusSignature('a{sv}'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asStringVariantDict();
  }

  /// Invokes org.gnome.Shell.Extensions.GetExtensionErrors()
  Future<List<String>> callGetExtensionErrors(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'GetExtensionErrors', [DBusString(uuid)],
        replySignature: DBusSignature('as'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes org.gnome.Shell.Extensions.InstallRemoteExtension()
  Future<String> callInstallRemoteExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod('org.gnome.Shell.Extensions',
        'InstallRemoteExtension', [DBusString(uuid)],
        replySignature: DBusSignature('s'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asString();
  }

  /// Invokes org.gnome.Shell.Extensions.UninstallExtension()
  Future<bool> callUninstallExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'UninstallExtension', [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.ReloadExtension()
  Future<void> callReloadExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod(
        'org.gnome.Shell.Extensions', 'ReloadExtension', [DBusString(uuid)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.gnome.Shell.Extensions.EnableExtension()
  Future<bool> callEnableExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'EnableExtension', [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.DisableExtension()
  Future<bool> callDisableExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        'org.gnome.Shell.Extensions', 'DisableExtension', [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.LaunchExtensionPrefs()
  Future<void> callLaunchExtensionPrefs(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.gnome.Shell.Extensions', 'LaunchExtensionPrefs',
        [DBusString(uuid)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.gnome.Shell.Extensions.OpenExtensionPrefs()
  Future<void> callOpenExtensionPrefs(
      String uuid, String parentWindow, Map<String, DBusValue> options,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod(
        'org.gnome.Shell.Extensions',
        'OpenExtensionPrefs',
        [
          DBusString(uuid),
          DBusString(parentWindow),
          DBusDict.stringVariant(options)
        ],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.gnome.Shell.Extensions.CheckForUpdates()
  Future<void> callCheckForUpdates(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod('org.gnome.Shell.Extensions', 'CheckForUpdates', [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }
}
