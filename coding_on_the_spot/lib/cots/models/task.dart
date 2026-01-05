class Task {
  final int? id;
  final String title;
  final String course;
  final DateTime deadline;
  final String status;
  final String note;
  final bool isDone;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Task({
    this.id,
    required this.title,
    required this.course,
    required this.deadline,
    required this.status,
    required this.note,
    this.isDone = false,
    this.createdAt,
    this.updatedAt,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      course: json['course'] ?? '',
      deadline: DateTime.parse(json['deadline']),
      status: json['status'] ?? 'BERJALAN',
      note: json['note'] ?? '',
      isDone: json['is_done'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'course': course,
      'deadline': deadline.toIso8601String().split('T')[0],
      'status': status,
      'note': note,
      'is_done': isDone,
    };
  }

  Task copyWith({
    int? id,
    String? title,
    String? course,
    DateTime? deadline,
    String? status,
    String? note,
    bool? isDone,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      course: course ?? this.course,
      deadline: deadline ?? this.deadline,
      status: status ?? this.status,
      note: note ?? this.note,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
