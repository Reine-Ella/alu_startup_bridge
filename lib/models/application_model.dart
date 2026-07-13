class ApplicationModel {
  final String id;
  final String studentId;
  final String studentName;
  final String studentEmail;
  final String opportunityId;
  final String opportunityTitle;
  final String startupId;
  final String startupName;
  final String motivation;
  final String status;
  final String createdAt;

  ApplicationModel({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.studentEmail,
    required this.opportunityId,
    required this.opportunityTitle,
    required this.startupId,
    required this.startupName,
    required this.motivation,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'studentId': studentId,
      'studentName': studentName,
      'studentEmail': studentEmail,
      'opportunityId': opportunityId,
      'opportunityTitle': opportunityTitle,
      'startupId': startupId,
      'startupName': startupName,
      'motivation': motivation,
      'status': status,
      'createdAt': createdAt,
    };
  }

  factory ApplicationModel.fromMap(Map<dynamic, dynamic> map) {
    return ApplicationModel(
      id: map['id'] ?? '',
      studentId: map['studentId'] ?? '',
      studentName: map['studentName'] ?? '',
      studentEmail: map['studentEmail'] ?? '',
      opportunityId: map['opportunityId'] ?? '',
      opportunityTitle: map['opportunityTitle'] ?? '',
      startupId: map['startupId'] ?? '',
      startupName: map['startupName'] ?? '',
      motivation: map['motivation'] ?? '',
      status: map['status'] ?? 'Applied',
      createdAt: map['createdAt'] ?? '',
    );
  }
}