class FeeRecord {
  final int feeID;
  final int studentID;
  final int treasuryID;
  final String semester;

  final double totalFee;
  final double paidAmount;
  final String feeStatus;

  final int totalFee;
  final int paidAmount;
  final int outstanding;
  final String dueDate;
  final String accessStatus;


  FeeRecord({
    required this.feeID,
    required this.studentID,
    required this.treasuryID,
    required this.semester,
    required this.totalFee,
    required this.paidAmount,

    required this.feeStatus,

    required this.outstanding,
    required this.dueDate,
    required this.accessStatus,

  });

  factory FeeRecord.fromJson(Map<String, dynamic> json) {
    return FeeRecord(

      feeID: int.tryParse(json['feeID'].toString()) ?? 0,

      studentID: int.tryParse(json['studentID'].toString()) ?? 0,

      treasuryID: int.tryParse(json['treasuryID'].toString()) ?? 0,

      semester: json['semester']?.toString() ?? '',

      totalFee:
          double.tryParse(json['totalFee'].toString()) ?? 0.0,

      paidAmount:
          double.tryParse(json['paidAmount'].toString()) ?? 0.0,

      feeStatus: json['feeStatus']?.toString() ?? '',

      feeID: json['feeID'],
      studentID: json['studentID'],
      treasuryID: json['treasuryID'],
      semester: json['semester'],
      totalFee: json['total fee'], // Matches your SQL 'total fee' with space
      paidAmount: json['paidAmount'],
      outstanding: json['outstanding'],
      dueDate: json['duedate'],
      accessStatus: json['accessStatus'],

    );
  }
}