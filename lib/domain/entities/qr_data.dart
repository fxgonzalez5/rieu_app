import 'dart:convert';

class QrData {
    final String userId;
    final String courseId;
    final DateTime date;

    QrData({
      required this.userId,
      required this.courseId,
      required this.date,
    });

    factory QrData.fromJson(String str) => QrData.fromMap(json.decode(str));

    factory QrData.fromMap(Map<String, dynamic> json) => QrData(
      userId: json["userId"],
      courseId: json["courseId"],
      date: DateTime.parse(json["date"]),
    );
}