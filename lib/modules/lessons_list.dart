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
            )),
            Card(
              elevation: 12,
              margin: EdgeInsets.all(5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: makeChildren(
                    MyApp.scheduleList, LessonsList.scheduleIsFirst, index),
              ),
            )
          ],
        ),
      ),
    );
  }

  makeChildren(Schedule? schedule, bool scheduleIsFirst, int day) {
    List<Widget> children = [];
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
  'prac': {'color': Color.fromARGB(216, 255, 28, 28), 'name': 'Практична'},
  'lec': {'color': Color.fromARGB(188, 0, 183, 255), 'name': 'Лекція'},
  'lab': {'color': Color.fromARGB(220, 255, 145, 0), 'name': 'Лабораторна'},
};

//TODO: implement icons for time
const Map timeIcon = {};

makeTile(Pair pair, List<Widget> list) {
  if (list.isNotEmpty) {
    list.add(
      const Divider(
        height: 2,
        thickness: 2,
      ),
    );
  }

  list.add(
    ListTile(
      title: Row(
        children: [
          Expanded(
            child: Text(pair.name),
          ),
        ],
      ),
      subtitle: Text(pair.teacherName),
      trailing: Card(
        child: Text(
          pairTag[pair.tag]['name'],
        ),
        color: pairTag[pair.tag]['color'],
      ),
      //leading: Icon(Icons.abc_rounded),
    ),
  );
}
