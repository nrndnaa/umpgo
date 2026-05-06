class CreditClaim {
  final int claimID;
  final int studentID;
  final String semester;
  final int totalCats;
  final String status;
  final String submittedAt;

  CreditClaim({
    required this.claimID,
    required this.studentID,
    required this.semester,
    required this.totalCats,
    required this.status,
    required this.submittedAt,
  });

  factory CreditClaim.fromJson(Map<String, dynamic> json) {
    return CreditClaim(
      claimID: json['claimID'],
      studentID: json['studentID'],
      semester: json['semester'],
      totalCats: json['totalCats'],
      status: json['status'],
      submittedAt: json['submitted_At'],
    );
  }
}
