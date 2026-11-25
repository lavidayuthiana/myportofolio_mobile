import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Portfolio project/achievement synchronized with the Django REST Framework
/// API. Backend MyPortfolio menyimpan proyek sebagai model `Experience`,
/// jadi field di sini mengikuti `ExperienceSerializer` (/api/v1/experiences/).
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    required this.description,
    this.category = 'full-time',
    this.thumbnail = '',
    this.startedAt,
    this.endedAt,
    this.id,
    this.categoryDisplay,
    this.isOngoing = false,
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// Pilihan kategori sesuai `Experience.EXPERIENCE_CHOICES` di Django.
  static const Map<String, String> categories = {
    'internship': 'Internship',
    'research': 'Research',
    'volunteer': 'Volunteer',
    'part-time': 'Part-Time',
    'full-time': 'Full-Time',
    'freelance': 'Freelance',
    'comittee': 'Comittee',
  };

  // ----- Diisi server, tidak dikirim saat POST -----
  @JsonKey(includeToJson: false)
  final String? id;
  @JsonKey(includeToJson: false)
  final String? categoryDisplay;
  @JsonKey(includeToJson: false, defaultValue: false)
  final bool isOngoing;

  // ----- Field yang bisa ditulis -----
  final String title;
  final String description;
  final String category;
  @JsonKey(defaultValue: '')
  final String thumbnail;
  final DateTime? startedAt;
  final DateTime? endedAt;

  /// Label kategori yang ramah dibaca.
  String get categoryLabel =>
      categoryDisplay ?? categories[category] ?? category;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
