class PasswordEntry {
  final String id;
  final String platform;
  final String email;
  final String password;
  final String? username;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  PasswordEntry({
    required this.id,
    required this.platform,
    required this.email,
    required this.password,
    this.username,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  PasswordEntry copyWith({
    String? id,
    String? platform,
    String? email,
    String? password,
    String? username,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PasswordEntry(
      id: id ?? this.id,
      platform: platform ?? this.platform,
      email: email ?? this.email,
      password: password ?? this.password,
      username: username ?? this.username,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'platform': platform,
    'email': email,
    'password': password,
    'username': username,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory PasswordEntry.fromJson(Map<String, dynamic> json) => PasswordEntry(
    id: json['id'] as String,
    platform: json['platform'] as String,
    email: json['email'] as String,
    password: json['password'] as String,
    username: json['username'] as String?,
    notes: json['notes'] as String?,
    createdAt: DateTime.parse(json['createdAt'] as String),
    updatedAt: DateTime.parse(json['updatedAt'] as String),
  );
}
