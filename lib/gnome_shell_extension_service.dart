library gnome_shell_extensions;

import 'dart:async';

import 'package:dbus/dbus.dart';

export 'src/gnome_shell_extension_service_base.dart';

const _kGnomeShellExtensionsInterface = 'org.gnome.Shell.Extensions';
const _kGnomeShellExtensionsPath = '/org/gnome/Shell/Extensions';

// Method Names
// CheckForUpdates () ↦ ()
const _kCheckForUpdatesMethod = 'CheckForUpdates';

// DisableExtension (String uuid) ↦ (Boolean success)
const _kDisableExtensionMethod = 'DisableExtension';

// EnableExtension (String uuid) ↦ (Boolean success)
const _kEnableExtensionMethod = 'EnableExtension';

// GetExtensionErrors (String uuid) ↦ (Array of [String] errors)
const _kGetExtensionErrorsMethod = 'GetExtensionErrors';

// GetExtensionInfo (String uuid) ↦ (Dict of {String, Variant} info)
const _kGetExtensionInfoMethod = 'GetExtensionInfo';

// InstallRemoteExtension (String uuid) ↦ (String result)
const _kInstallRemoteExtensionMethod = 'InstallRemoteExtension';

// LaunchExtensionPrefs (String uuid) ↦ ()
const _kLaunchExtensionPrefsMethod = 'LaunchExtensionPrefs';

// ListExtensions () ↦ (Dict of {String, Dict of {String, Variant}} extensions)
const _kListExtensionsMethod = 'ListExtensions';

// OpenExtensionPrefs (String uuid, String parent_window, Dict of {String, Variant} options) ↦ ()
const _kOpenExtensionPrefsMethod = 'OpenExtensionPrefs';

// ReloadExtension (String uuid) ↦ ()
const _kReloadExtensionMethod = 'ReloadExtension';

// UninstallExtension (String uuid) ↦ (Boolean success)
const _kUninstallExtensionMethod = 'UninstallExtension';

// Properties
// boolean UserExtensionsEnabled
const _kUserExtensionsEnabledProperty = 'UserExtensionsEnabled';

// String ShellVersion
const _kShellVersionProperty = 'ShellVersion';

// Signals
// ExtensionStateChanged(String, Dict of {String, Variant})
// const _kExtensionStateChantedSignal = 'ExtensionStateChanged';
// ExtensionStatusChanged (String, Int32, String)
// const _kExtensionStatusChangedSignal = 'ExtensionStatusChanged';

class GnomeShellExtensionService {
  GnomeShellExtensionService() : _object = _createObject();

  final DBusRemoteObject _object;
  StreamSubscription<DBusPropertiesChangedSignal>? _propertyListener;

  static DBusRemoteObject _createObject() => DBusRemoteObject(
        DBusClient.system(),
        name: _kGnomeShellExtensionsInterface,
        path: DBusObjectPath(_kGnomeShellExtensionsPath),
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
    if (signal.hasChangedExtensionsEnabled()) {
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
  Future<Map<String, Map<String, DBusValue>>> listExtensions(
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      await _object.callListExtensions(
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.GetExtensionInfo()
  Future<Map<String, DBusValue>> getExtensionInfo(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) =>
      _object.callGetExtensionInfo(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.GetExtensionErrors()
  Future<List<String>> getExtensionErrors(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callGetExtensionErrors(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.InstallRemoteExtension()
  Future<String> installRemoteExtension(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callInstallRemoteExtension(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.UninstallExtension()
  Future<bool> uninstallExtension(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callUninstallExtension(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.ReloadExtension()
  Future<void> reloadExtension(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callReloadExtension(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.EnableExtension()
  Future<bool> enableExtension(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callEnableExtension(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.DisableExtension()
  Future<bool> disableExtension(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callDisableExtension(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.LaunchExtensionPrefs()
  Future<void> launchExtensionPrefs(String uuid,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callLaunchExtensionPrefs(uuid,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.OpenExtensionPrefs()
  Future<void> openExtensionPrefs(
          String uuid, String parentWindow, Map<String, DBusValue> options,
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callOpenExtensionPrefs(uuid, parentWindow, options,
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);

  /// Invokes org.gnome.Shell.Extensions.CheckForUpdates()
  Future<void> checkForUpdates(
          {bool noAutoStart = false,
          bool allowInteractiveAuthorization = false}) async =>
      _object.callCheckForUpdates(
          noAutoStart: noAutoStart,
          allowInteractiveAuthorization: allowInteractiveAuthorization);
}

extension _GnomeShellExtensionsRemoteObject on DBusRemoteObject {
  /// Gets org.gnome.Shell.Extensions.ShellVersion
  Future<String> getShellVersion() async {
    var value = await getProperty(
        _kGnomeShellExtensionsInterface, _kShellVersionProperty,
        signature: DBusSignature('s'));
    return value.asString();
  }

  /// Gets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<bool> getUserExtensionsEnabled() async {
    var value = await getProperty(
        _kGnomeShellExtensionsInterface, _kUserExtensionsEnabledProperty,
        signature: DBusSignature('b'));
    return value.asBoolean();
  }

  /// Sets org.gnome.Shell.Extensions.UserExtensionsEnabled
  Future<void> setUserExtensionsEnabled(bool value) async {
    await setProperty(_kGnomeShellExtensionsInterface,
        _kUserExtensionsEnabledProperty, DBusBoolean(value));
  }

  /// Invokes org.gnome.Shell.Extensions.ListExtensions()
  Future<Map<String, Map<String, DBusValue>>> callListExtensions(
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(
        _kGnomeShellExtensionsInterface, _kListExtensionsMethod, [],
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
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kGetExtensionInfoMethod, [DBusString(uuid)],
        replySignature: DBusSignature('a{sv}'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asStringVariantDict();
  }

  /// Invokes org.gnome.Shell.Extensions.GetExtensionErrors()
  Future<List<String>> callGetExtensionErrors(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kGetExtensionErrorsMethod, [DBusString(uuid)],
        replySignature: DBusSignature('as'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asStringArray().toList();
  }

  /// Invokes org.gnome.Shell.Extensions.InstallRemoteExtension()
  Future<String> callInstallRemoteExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kInstallRemoteExtensionMethod, [DBusString(uuid)],
        replySignature: DBusSignature('s'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asString();
  }

  /// Invokes org.gnome.Shell.Extensions.UninstallExtension()
  Future<bool> callUninstallExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kUninstallExtensionMethod, [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.ReloadExtension()
  Future<void> callReloadExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod(_kGnomeShellExtensionsInterface, _kReloadExtensionMethod,
        [DBusString(uuid)],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }

  /// Invokes org.gnome.Shell.Extensions.EnableExtension()
  Future<bool> callEnableExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kEnableExtensionMethod, [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.DisableExtension()
  Future<bool> callDisableExtension(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    var result = await callMethod(_kGnomeShellExtensionsInterface,
        _kDisableExtensionMethod, [DBusString(uuid)],
        replySignature: DBusSignature('b'),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
    return result.returnValues[0].asBoolean();
  }

  /// Invokes org.gnome.Shell.Extensions.LaunchExtensionPrefs()
  Future<void> callLaunchExtensionPrefs(String uuid,
      {bool noAutoStart = false,
      bool allowInteractiveAuthorization = false}) async {
    await callMethod(_kGnomeShellExtensionsInterface,
        _kLaunchExtensionPrefsMethod, [DBusString(uuid)],
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
        _kGnomeShellExtensionsInterface,
        _kOpenExtensionPrefsMethod,
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
    await callMethod(
        _kGnomeShellExtensionsInterface, _kCheckForUpdatesMethod, [],
        replySignature: DBusSignature(''),
        noAutoStart: noAutoStart,
        allowInteractiveAuthorization: allowInteractiveAuthorization);
  }
}

extension _ChangedGnomeShellExtensions on DBusPropertiesChangedSignal {
  bool hasChangedExtensionsEnabled() {
    return changedProperties.containsKey(_kUserExtensionsEnabledProperty);
  }
}
