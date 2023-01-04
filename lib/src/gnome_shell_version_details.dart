import 'dart:convert';

class GnomeShellVersionDetails {
  final int pk;
  final int version;

  GnomeShellVersionDetails({
    required this.pk,
    required this.version,
  });

  GnomeShellVersionDetails copyWith({
    int? pk,
    int? version,
  }) {
    return GnomeShellVersionDetails(
      pk: pk ?? this.pk,
      version: version ?? this.version,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'pk': pk});
    result.addAll({'version': version});

    return result;
  }

  factory GnomeShellVersionDetails.fromMap(Map<String, dynamic> map) {
    return GnomeShellVersionDetails(
      pk: map['pk']?.toInt() ?? 0,
      version: map['version']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory GnomeShellVersionDetails.fromJson(String source) =>
      GnomeShellVersionDetails.fromMap(json.decode(source));

  @override
  String toString() => 'GnomeShellVersionDetails(pk: $pk, version: $version)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GnomeShellVersionDetails &&
        other.pk == pk &&
        other.version == version;
  }

  @override
  int get hashCode => pk.hashCode ^ version.hashCode;
}
