import 'dart:developer';

import 'package:first_app/api.dart';
import 'package:first_app/main.dart';
import 'package:flutter/material.dart';

const List<String> daysOfWeek = [
  'Понеділок',
  'Вівторок',
  'Середа',
  'Четверг',
  'П`ятниця',
  'Субота'
];

class LessonsList extends StatelessWidget {
  LessonsList({Key? key}) : super(key: key);
  static bool scheduleIsFirst = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: daysOfWeek.length,
        itemBuilder: (BuildContext context, int index) {
          return TileBuilder(
            index: index,
            day: daysOfWeek[index],
          );
        },
      ),
    );
  }
}

class TileBuilder extends StatelessWidget {
  TileBuilder({
    required this.index,
    required this.day,
  });
  int index;
  String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Color.fromARGB(255, 88, 141, 255),
        child: Column(
          children: [
            Center(
              child: Text(
                day,
                style: const TextStyle(
                  fontSize: 25,
                ),
              ),
            ),
            //TODO: cringe layout-clipping, needs reworking
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 12,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: makeChildren(
                      MyApp.scheduleList, LessonsList.scheduleIsFirst, index),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  makeChildren(Schedule? schedule, bool scheduleIsFirst, int day) {
    List<Widget> children = [];
    inspect(schedule);
    scheduleIsFirst
        ? {
            for (Pair pair in schedule!.scheduleFirstWeek[day].pairs)
              makeTile(pair, children)
          }
        : {
            for (Pair pair in schedule!.scheduleSecondWeek[day].pairs)
              makeTile(pair, children)
          };

    return children;
  }
}

const Map pairTag = {
  'prac': {'color': Colors.orange, 'name': 'Практична'},
  'lec': {'color': Colors.lightBlueAccent, 'name': 'Лекція'},
  'lab': {'color': Colors.green, 'name': 'Лабораторна'},
};

//TODO: change icons for time
const Map timeIcon = {
  '8.30': Icons.filter_1,
  '10.25': Icons.filter_2,
  '12.20': Icons.filter_3,
  '14.15': Icons.filter_4,
};

makeTile(Pair pair, List<Widget> list) {
  if (list.isNotEmpty) {
    list.add(
      const Divider(
        height: 2,
        thickness: 2,
      ),
    );
  }

  list.add(Container(
    decoration: BoxDecoration(
        border: Border(
            left: BorderSide(color: pairTag[pair.tag]['color'], width: 12))),
    child: ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(pair.name),
          ),
        ],
      ),
      subtitle: Text(pair.teacherName),
      //TODO:redesigne text and change icon, center column
      leading: Column(
        children: [Icon(timeIcon[pair.time]), Text(pair.time)],
      ),
    ),
  ));
}
