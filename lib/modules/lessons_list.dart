import 'dart:developer';

import 'package:first_app/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/modules/iconsClass/icon_numbers_icons.dart';
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
  const LessonsList({Key? key}) : super(key: key);
  static bool isSchedulFirst = true;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: daysOfWeek.length,
      itemBuilder: (BuildContext context, int index) {
        return TileBuilder(index);
      },
    );
  }
}

class TileBuilder extends StatelessWidget {
  const TileBuilder(
    this.index, {
    Key? key,
  }) : super(key: key);
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(5, 10, 5, 0),
      child: Card(
        elevation: 6,
        color: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Center(
              child: Text(
                daysOfWeek[index],
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
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
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: makeChildren(
                      MyApp.scheduleList, LessonsList.isSchedulFirst, index),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

makeChildren(Schedule? schedule, bool isScheduleFirst, int day) {
  List<Widget> children = [];
  inspect(schedule);
  isScheduleFirst
      ? {
          for (Pair pair in schedule!.scheduleFirstWeek[day].pairs)
            makeTile(pair, children, day, MyApp.isFirstWeek)
        }
      : {
          for (Pair pair in schedule!.scheduleSecondWeek[day].pairs)
            makeTile(pair, children, day, !MyApp.isFirstWeek)
        };

  return children;
}

//TODO: change to list or something, better name list with consts
const Map pairTag = {
  'prac': {'color': Colors.orange, 'name': 'Практична'},
  'lec': {'color': Colors.lightBlueAccent, 'name': 'Лекція'},
  'lab': {'color': Colors.green, 'name': 'Лабораторна'},
};

const Map timeIcon = {
  '8.30': IconNumbers.one,
  '10.25': IconNumbers.two,
  '12.20': IconNumbers.three,
  '14.15': IconNumbers.four,
  '16.10': IconNumbers.five,
  '18.30': IconNumbers.six,
};

makeTile(Pair pair, List<Widget> list, int day, bool isThisWeek) {
  if (list.isNotEmpty) {
    list.add(
      const Divider(
        height: 2,
        thickness: 2,
      ),
    );
  }

  list.add(PairListTile(pair, day, isThisWeek));
}

class PairListTile extends StatelessWidget {
  const PairListTile(this.pair, this.day, this.isThisWeek, {Key? key})
      : super(key: key);
  final Pair pair;
  final int day;
  final bool isThisWeek;

  @override
  Widget build(BuildContext context) {
    final bool active = isThisWeek ? isPairNow(day, pair.time) : false;

    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: pairTag[pair.tag]['color'], width: 12),
          right: BorderSide(
              color: Theme.of(context).listTileTheme.tileColor!, width: 17),
        ),
      ),
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
          children: [
            Icon(
              timeIcon[pair.time],
              color: active ? Theme.of(context).colorScheme.primary : null,
            ),
            Text(pair.time)
          ],
        ),
        textColor: active ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}

bool isPairNow(int day, String pairTimeString) {
  day = day + 1; // day is from list and starts from 0
  DateTime timeInWeek = MyApp.timeInWeek;
  int hour = int.parse(pairTimeString.split('.')[0]);
  int minute = int.parse(pairTimeString.split('.')[1]);
  DateTime pairTime =
      DateTime(timeInWeek.year, timeInWeek.month, timeInWeek.day, hour, minute);
  if ((day) != timeInWeek.day) {
    return false;
  }
  inspect(timeInWeek);
  inspect(pairTime);
  if (timeInWeek.isAfter(pairTime) &&
      timeInWeek.isBefore(
        pairTime.add(
          const Duration(hours: 1, minutes: 35),
        ),
      )) {
    return true;
  } else {
    return false;
  }
}
