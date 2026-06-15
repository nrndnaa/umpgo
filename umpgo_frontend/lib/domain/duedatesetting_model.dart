class DueDateSettingModel {
  final int dueDateID;
  final String semester;
  final String dueDate;
  final String blockType;
  final int createdBy;

  DueDateSettingModel({
    required this.dueDateID,
    required this.semester,
    required this.dueDate,
    required this.blockType,
    required this.createdBy,
  });

  factory DueDateSettingModel.fromJson(Map<String, dynamic> json) {
    return DueDateSettingModel(
      dueDateID: json['dueDateID'],
      semester: json['semester'],
      dueDate: json['dueDate'],
      blockType: json['blockType'],
      createdBy: json['created_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'dueDateID': dueDateID,
      'semester': semester,
      'dueDate': dueDate,
      'blockType': blockType,
      'created_by': createdBy,
    };
  }
}