import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:gnome_shell_extension_service/src/constants.dart';

import 'package:gnome_shell_extension_service/src/gnome_shell_version_details.dart';

class GnomeShellExtension {
  GnomeShellExtension({
    required this.uuid,
    required this.name,
    required this.creator,
    required this.creatorUrl,
    required this.pk,
    required this.description,
    required this.link,
    required this.icon,
    required this.screenshot,
    required this.shellVersionMap,
  });

  final String uuid;
  final String name;
  final String creator;
  final String creatorUrl;
  final int pk;
  final String description;
  final String link;
  final String icon;
  final String screenshot;
  final Map<String, dynamic> shellVersionMap;

  String get screenShotUrl => '$kBaseUrl$screenshot';
  String get iconUrl => '$kBaseUrl$icon';

  GnomeShellExtension copyWith({
    String? uuid,
    String? name,
    String? creator,
    String? creatorUrl,
    int? pk,
    String? description,
    String? link,
    String? icon,
    String? screenshot,
    Map<String, GnomeShellVersionDetails>? shellVersionMap,
  }) {
    return GnomeShellExtension(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      creator: creator ?? this.creator,
      creatorUrl: creatorUrl ?? this.creatorUrl,
      pk: pk ?? this.pk,
      description: description ?? this.description,
      link: link ?? this.link,
      icon: icon ?? this.icon,
      screenshot: screenshot ?? this.screenshot,
      shellVersionMap: shellVersionMap ?? this.shellVersionMap,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'uuid': uuid});
    result.addAll({'name': name});
    result.addAll({'creator': creator});
    result.addAll({'creatorUrl': creatorUrl});
    result.addAll({'pk': pk});
    result.addAll({'description': description});
    result.addAll({'link': link});
    result.addAll({'icon': icon});
    result.addAll({'screenshot': screenshot});
    result.addAll({'shellVersionMap': shellVersionMap});

    return result;
  }

  factory GnomeShellExtension.fromMap(Map<String, dynamic> map) {
    return GnomeShellExtension(
      uuid: map['uuid'] ?? '',
      name: map['name'] ?? '',
      creator: map['creator'] ?? '',
      creatorUrl: map['creatorUrl'] ?? '',
      pk: map['pk']?.toInt() ?? 0,
      description: map['description'] ?? '',
      link: map['link'] ?? '',
      icon: map['icon'] ?? '',
      screenshot: map['screenshot'] ?? '',
      shellVersionMap:
          Map<String, dynamic>.from(map['shell_version_map'] ?? {}),
    );
  }

  String toJson() => json.encode(toMap());

  factory GnomeShellExtension.fromJson(String source) =>
      GnomeShellExtension.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GnomeShellExtension(uuid: $uuid, name: $name, creator: $creator, creatorUrl: $creatorUrl, pk: $pk, description: $description, link: $link, icon: $icon, screenshot: $screenshot, shellVersionMap: $shellVersionMap)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    final mapEquals = const DeepCollectionEquality().equals;

    return other is GnomeShellExtension &&
        other.uuid == uuid &&
        other.name == name &&
        other.creator == creator &&
        other.creatorUrl == creatorUrl &&
        other.pk == pk &&
        other.description == description &&
        other.link == link &&
        other.icon == icon &&
        other.screenshot == screenshot &&
        mapEquals(other.shellVersionMap, shellVersionMap);
  }

  @override
  int get hashCode {
    return uuid.hashCode ^
        name.hashCode ^
        creator.hashCode ^
        creatorUrl.hashCode ^
        pk.hashCode ^
        description.hashCode ^
        link.hashCode ^
        icon.hashCode ^
        screenshot.hashCode ^
        shellVersionMap.hashCode;
  }
}
