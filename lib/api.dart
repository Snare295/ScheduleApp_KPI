import 'dart:convert';
import 'dart:developer';

import 'package:ScheduleKPI/main.dart';
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
    List temp = [];

    for (var i in data["data"]) {
      temp.add(i);
    }

    return Groups.groupsFromSnapshot(temp);
  }

  static Future<Schedule> getLessons() async {
    var uri = Uri.https(ApiConstants.baseUrl, ApiConstants.endpointSchedule,
        {'groupId': MyApp.groupId});

    final response = await http.get(uri);

    inspect(response);
    Map data = jsonDecode(response.body);
    Map temp = data['data'];

    Schedule sortedSchedule = sortSchedule(Schedule.fromJson(temp));

    return sortedSchedule;
  }
}

sortSchedule(Schedule schedule) {
  for (ScheduleWeek scheduleWeek in schedule.scheduleFirstWeek) {
    scheduleWeek.pairs.sort(
      ((a, b) => double.parse(a.time).compareTo(double.parse(b.time))),
    );
  }
  for (ScheduleWeek scheduleWeek in schedule.scheduleSecondWeek) {
    scheduleWeek.pairs.sort(
      ((a, b) => double.parse(a.time).compareTo(double.parse(b.time))),
    );
  }
  return schedule;
}

class Groups {
  final String groupName;
  final String groupId;

  Groups({
    required this.groupName,
    required this.groupId,
  });

  factory Groups.fromJson(dynamic json) => Groups(
        groupName: json['name'] as String,
        groupId: json['id'] as String,
      );

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
