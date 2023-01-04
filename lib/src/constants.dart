const kGnomeShellExtensionsInterface = 'org.gnome.Shell.Extensions';
const kGnomeShellExtensionsPath = '/org/gnome/Shell/Extensions';

// Method Names
// CheckForUpdates () ↦ ()
const kCheckForUpdatesMethod = 'CheckForUpdates';

// DisableExtension (String uuid) ↦ (Boolean success)
const kDisableExtensionMethod = 'DisableExtension';

// EnableExtension (String uuid) ↦ (Boolean success)
const kEnableExtensionMethod = 'EnableExtension';

// GetExtensionErrors (String uuid) ↦ (Array of [String] errors)
const kGetExtensionErrorsMethod = 'GetExtensionErrors';

// GetExtensionInfo (String uuid) ↦ (Dict of {String, Variant} info)
const kGetExtensionInfoMethod = 'GetExtensionInfo';

// InstallRemoteExtension (String uuid) ↦ (String result)
const kInstallRemoteExtensionMethod = 'InstallRemoteExtension';

// LaunchExtensionPrefs (String uuid) ↦ ()
const kLaunchExtensionPrefsMethod = 'LaunchExtensionPrefs';

// ListExtensions () ↦ (Dict of {String, Dict of {String, Variant}} extensions)
const kListExtensionsMethod = 'ListExtensions';

// OpenExtensionPrefs (String uuid, String parent_window, Dict of {String, Variant} options) ↦ ()
const kOpenExtensionPrefsMethod = 'OpenExtensionPrefs';

// ReloadExtension (String uuid) ↦ ()
const kReloadExtensionMethod = 'ReloadExtension';

// UninstallExtension (String uuid) ↦ (Boolean success)
const kUninstallExtensionMethod = 'UninstallExtension';

// Properties
// boolean UserExtensionsEnabled
const kUserExtensionsEnabledProperty = 'UserExtensionsEnabled';

// String ShellVersion
const kShellVersionProperty = 'ShellVersion';

// Signals
// ExtensionStateChanged(String, Dict of {String, Variant})
// const kExtensionStateChantedSignal = 'ExtensionStateChanged';
// ExtensionStatusChanged (String, Int32, String)
// const kExtensionStatusChangedSignal = 'ExtensionStatusChanged';

const kBaseUrl = 'https://extensions.gnome.org';
const kApiUrl = '$kBaseUrl/extension-query/';
