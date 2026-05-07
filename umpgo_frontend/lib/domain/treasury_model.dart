class TreasuryModel {
  final int treasuryID;
  final String staffID;
  final String name;
  final String email;

  TreasuryModel({
    required this.treasuryID,
    required this.staffID,
    required this.name,
    required this.email,
  });

  factory TreasuryModel.fromJson(Map<String, dynamic> json) {
    return TreasuryModel(
      treasuryID: json['treasuryID'],
      staffID: json['staffID'],
      name: json['name'],
      email: json['email'],
    );
  }
}
