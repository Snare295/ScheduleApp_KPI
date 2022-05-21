import 'dart:convert';
import 'dart:developer';

import 'package:first_app/main.dart';
import 'package:http/http.dart' as http;

class ApiConstants {
  static String baseUrl = 'schedule.kpi.ua';
  static String endpointGroups = '/api/schedule/groups';
  static String endpointSchedule = '/api/schedule/lessons';
}

class ApiHandler {
  static Future<List<Groups>> getGroups() async {
    var uri = Uri.https(ApiConstants.baseUrl, ApiConstants.endpointGroups);

    final response = await http.get(uri);

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data["data"]) {
      _temp.add(i);
    }

    List _shit = Groups.groupsFromSnapshot(_temp);
    return Groups.groupsFromSnapshot(_temp);
  }

  static Future<Schedule> getLessons() async {
    var uri = Uri.https(ApiConstants.baseUrl, ApiConstants.endpointSchedule,
        {'groupName': MyApp.groupName});
    print(uri.toString());

    final response = await http.get(uri);

    Map data = jsonDecode(response.body);
    Map _temp = data['data'];

    return Schedule.fromJson(_temp);
  }
}

class Groups {
  final String groupName;

  Groups({required this.groupName});

  factory Groups.fromJson(dynamic json) {
    return Groups(groupName: json['name'] as String);
  }

  static List<Groups> groupsFromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Groups.fromJson(data);
    }).toList();
  }
}

//created by app.quicktype.io

class Schedule {
  Schedule({
    required this.groupCode,
    required this.scheduleFirstWeek,
    required this.scheduleSecondWeek,
  });

  final String groupCode;
  final List<ScheduleWeek> scheduleFirstWeek;
  final List<ScheduleWeek> scheduleSecondWeek;

  factory Schedule.fromJson(json) => Schedule(
        groupCode: json["groupCode"],
        scheduleFirstWeek: List<ScheduleWeek>.from(
            json["scheduleFirstWeek"].map((x) => ScheduleWeek.fromJson(x))),
        scheduleSecondWeek: List<ScheduleWeek>.from(
            json["scheduleSecondWeek"].map((x) => ScheduleWeek.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "groupCode": groupCode,
        "scheduleFirstWeek":
            List<dynamic>.from(scheduleFirstWeek.map((x) => x.toJson())),
        "scheduleSecondWeek":
            List<dynamic>.from(scheduleSecondWeek.map((x) => x.toJson())),
      };
}

class ScheduleWeek {
  ScheduleWeek({
    required this.day,
    required this.pairs,
  });

  final String day;
  final List<Pair> pairs;

  factory ScheduleWeek.fromJson(Map<String, dynamic> json) => ScheduleWeek(
        day: json["day"],
        pairs: List<Pair>.from(json["pairs"].map((x) => Pair.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "pairs": List<dynamic>.from(pairs.map((x) => x.toJson())),
      };
}

class Pair {
  Pair({
    required this.teacherName,
    required this.lecturerId,
    required this.type,
    required this.time,
    required this.name,
    required this.place,
    required this.tag,
  });

  final String teacherName;
  final String lecturerId;
  final String type;
  final String time;
  final String name;
  final String place;
  final String tag;

  factory Pair.fromJson(Map<String, dynamic> json) => Pair(
        teacherName: json["teacherName"],
        lecturerId: json["lecturerId"],
        type: json["type"],
        time: json["time"],
        name: json["name"],
        place: json["place"],
        tag: json["tag"],
      );

  Map<String, dynamic> toJson() => {
        "teacherName": teacherName,
        "lecturerId": lecturerId,
        "type": type,
        "time": time,
        "name": name,
        "place": place,
        "tag": tag,
      };
}
