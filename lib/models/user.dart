class EmergencyContact {
  final String name;
  final String phoneNumber;
  final String relationship;

  EmergencyContact({
    required this.name,
    required this.phoneNumber,
    required this.relationship,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'relationship': relationship,
    };
  }

  factory EmergencyContact.fromMap(Map<String, dynamic> map) {
    return EmergencyContact(
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      relationship: map['relationship'] ?? '',
    );
  }
}

class User {
  final String name;
  final String email;
  final String studentId;
  final String major;
  final String? profileImageUrl;
  final List<EmergencyContact> emergencyContacts;
  final int reportsSubmitted;
  final int moodEntries;
  final DateTime? lastLogin;

  User({
    required this.name,
    required this.email,
    required this.studentId,
    required this.major,
    this.profileImageUrl,
    this.emergencyContacts = const [],
    this.reportsSubmitted = 0,
    this.moodEntries = 0,
    this.lastLogin,
  });

  // Convert User object to Map for storage
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'studentId': studentId,
      'major': major,
      'profileImageUrl': profileImageUrl,
      'emergencyContacts': emergencyContacts.map((contact) => contact.toMap()).toList(),
      'reportsSubmitted': reportsSubmitted,
      'moodEntries': moodEntries,
      'lastLogin': lastLogin?.toIso8601String(),
    };
  }

  // Create User object from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      studentId: map['studentId'] ?? '',
      major: map['major'] ?? '',
      profileImageUrl: map['profileImageUrl'],
      emergencyContacts: (map['emergencyContacts'] as List<dynamic>?)
          ?.map((contact) => EmergencyContact.fromMap(contact))
          .toList() ?? [],
      reportsSubmitted: map['reportsSubmitted'] ?? 0,
      moodEntries: map['moodEntries'] ?? 0,
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
    );
  }

  // Copy with method for updating specific fields
  User copyWith({
    String? name,
    String? email,
    String? studentId,
    String? major,
    String? profileImageUrl,
    List<EmergencyContact>? emergencyContacts,
    int? reportsSubmitted,
    int? moodEntries,
    DateTime? lastLogin,
  }) {
    return User(
      name: name ?? this.name,
      email: email ?? this.email,
      studentId: studentId ?? this.studentId,
      major: major ?? this.major,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      emergencyContacts: emergencyContacts ?? this.emergencyContacts,
      reportsSubmitted: reportsSubmitted ?? this.reportsSubmitted,
      moodEntries: moodEntries ?? this.moodEntries,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }
}
