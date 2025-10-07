class Group {
  final String id;
  final String name;
  final List<String> members;
  final String createdBy;
  final DateTime createdAt;

  Group({
    required this.id,
    required this.name,
    required this.members,
    required this.createdBy,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'members': members,
      'createdBy': createdBy,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Group.fromMap(Map<String, dynamic> map) {
    return Group(
      id: map['id'],
      name: map['name'],
      members: List<String>.from(map['members']),
      createdBy: map['createdBy'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
} 