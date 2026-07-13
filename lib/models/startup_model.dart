class StartupModel {
  final String id;
  final String founderId;
  final String startupName;
  final String founderName;
  final String description;
  final String category;
  final String email;
  final bool verified;
  final String createdAt;

  StartupModel({
    required this.id,
    required this.founderId,
    required this.startupName,
    required this.founderName,
    required this.description,
    required this.category,
    required this.email,
    required this.verified,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'founderId': founderId,
      'startupName': startupName,
      'founderName': founderName,
      'description': description,
      'category': category,
      'email': email,
      'verified': verified,
      'createdAt': createdAt,
    };
  }

  factory StartupModel.fromMap(Map<dynamic, dynamic> map) {
    return StartupModel(
      id: map['id'] ?? '',
      founderId: map['founderId'] ?? '',
      startupName: map['startupName'] ?? '',
      founderName: map['founderName'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      email: map['email'] ?? '',
      verified: map['verified'] ?? false,
      createdAt: map['createdAt'] ?? '',
    );
  }
}