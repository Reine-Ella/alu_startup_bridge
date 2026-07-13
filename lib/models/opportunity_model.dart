class OpportunityModel {
  final String id;
  final String startupId;
  final String startupName;
  final String title;
  final String description;
  final String category;
  final String location;
  final String type;
  final String requiredSkills;
  final String duration;
  final String weeklyHours;
  final String status;
  final String createdAt;

  OpportunityModel({
    required this.id,
    required this.startupId,
    required this.startupName,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.type,
    required this.requiredSkills,
    required this.duration,
    required this.weeklyHours,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startupId': startupId,
      'startupName': startupName,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'type': type,
      'requiredSkills': requiredSkills,
      'duration': duration,
      'weeklyHours': weeklyHours,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory OpportunityModel.fromMap(Map<dynamic, dynamic> map) {
    return OpportunityModel(
      id: map['id'] ?? '',
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      category: map['category'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      requiredSkills: map['requiredSkills'] ?? '',
      duration: map['duration'] ?? '',
      weeklyHours: map['weeklyHours'] ?? '',
      status: map['status'] ?? 'open',
      createdAt: map['createdAt'] ?? '',
    );
  }
}