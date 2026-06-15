class KoqModule {
  final int moduleID;
  final int adabID;
  final String code;
  final String name;
  final int catsPoint;
  final int maxSlots;
  final int filledSlots;
  final String startDate;
  final String endDate;
  final String venue;
  final String groupLink;

  KoqModule({
    required this.moduleID,
    required this.adabID,
    required this.code,
    required this.name,
    required this.catsPoint,
    required this.maxSlots,
    required this.filledSlots,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.groupLink,
  });

  factory KoqModule.fromJson(Map<String, dynamic> json) {
    return KoqModule(
      moduleID: json['moduleID'],
      adabID: json['adabID'],
      code: json['code'],
      name: json['name'],
      catsPoint: json['catsPoint'],
      maxSlots: json['maxSlots'],
      filledSlots: json['filledSlots'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      venue: json['venue'],
      groupLink: json['groupLink'],
    );
  }
}
