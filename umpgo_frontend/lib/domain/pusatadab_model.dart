class PusatAdabModel {
  final int adabID;
  final String staffID;
  final String name;
  final String email;

  PusatAdabModel({
    required this.adabID,
    required this.staffID,
    required this.name,
    required this.email,
  });

  factory PusatAdabModel.fromJson(Map<String, dynamic> json) {
    return PusatAdabModel(
      adabID: json['adabID'],
      staffID: json['staffID'],
      name: json['name'],
      email: json['email'],
    );
  }
}
