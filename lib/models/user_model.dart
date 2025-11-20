class UserModel {
  final String id;
  final String name;
  final String email;
  final String? employeeId;
  final String? avatarUrl;
  final String role; // 'admin' or 'employee'
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.employeeId,
    this.avatarUrl,
    this.role = 'employee',
    required this.createdAt,
  });

  // Convert from Firestore document
  factory UserModel.fromMap(Map<String, dynamic> map, String id) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      employeeId: map['employeeId'],
      avatarUrl: map['avatarUrl'],
      role: map['role'] ?? 'employee',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  // Convert to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'employeeId': employeeId,
      'avatarUrl': avatarUrl,
      'role': role,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  // Copy with method for updates
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? employeeId,
    String? avatarUrl,
    String? role,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      employeeId: employeeId ?? this.employeeId,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
