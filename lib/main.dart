import 'dart:developer';

import 'package:first_app/modules/lessons_list.dart';
import 'package:flutter/material.dart';
import 'modules/.export.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<Groups> groupsList = [];
  static bool isLoadingGroups = true;
  static Schedule? scheduleList;
  static bool isLoadingSchedule = true;
  static String groupName = '';
  static DateTime timeInWeek = DateTime.now();
  static bool isFirstWeek = true;
  static bool offsetByWeek = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      home: HomePage(),
    );
  }
}

//This page is embeded in main.dart file, for rerouting change main function
//Don't make this page in separate file. This page is base for app and donesn't need to
class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);
  static int currentPageIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();

    getGroupNameData();
    MyApp.timeInWeek = timeWeek();
    getGroups();
  }

  timeWeek() {
    const int timeEpochOffset =
        946857600000; //2000/01/03 first monday in 2000. miliseconds from epoch
    const int oneWeek = 604800000;
    bool offsetByWeek = true;
    int now = DateTime.now().millisecondsSinceEpoch;
    if (MyApp.offsetByWeek) {
      now = now - timeEpochOffset;
    } else {
      now = now - (timeEpochOffset + oneWeek);
    }
    now = now % (oneWeek * 2);
    if (now < oneWeek) {
      LessonsList.isSchedulFirst = true;
      MyApp.isFirstWeek = true;
    } else {
      LessonsList.isSchedulFirst = false;
      MyApp.isFirstWeek = false;
    }
    now = now % oneWeek;
    print(now);
    var timeInWeek = DateTime.fromMillisecondsSinceEpoch(now);
    print(timeInWeek);
    return timeInWeek;
  }

  Future<void> getGroupNameData() async {
    final prefs = await SharedPreferences.getInstance();
    String groupName = await prefs.getString('groupNameData') ?? '';
    setState(() => MyApp.groupName = groupName);
    if (MyApp.groupName != '') {
      getSchedule();
    }
  }

  Future<void> getGroups() async {
    MyApp.groupsList = await ApiHandler.getGroups();
    setState(() {
      MyApp.isLoadingGroups = false;
    });
  }

  Future<void> getSchedule() async {
    setState(() {
      MyApp.isLoadingSchedule = true;
    });
    MyApp.scheduleList = await ApiHandler.getLessons();
    setState(() {
      MyApp.isLoadingSchedule = false;
    });
    inspect(MyApp.scheduleList);
  }

  changeDayOfTheWeek() {
    setState(() {
      LessonsList.isSchedulFirst = !LessonsList.isSchedulFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController _homePageViewController = PageController(initialPage: 0);
    return Scaffold(
      appBar: HomeAppBar(getSchedule, changeDayOfTheWeek),
      body: Container(
        color: Color(0xFFEEEEEE),
        child: Builder(
          builder: ((context) {
            if (MyApp.groupName != '') {
              inspect(MyApp.groupName);
              if (!MyApp.isLoadingSchedule) {
                return PageView(
                  controller: _homePageViewController,
                  onPageChanged: (newIndex) {
                    setState(() {
                      HomePage.currentPageIndex = newIndex;
                    });
                  },
                  children: [
                    LessonsList(),
                    const Center(child: Text('Cumming Soon')),
                  ],
                  scrollDirection: Axis.horizontal,
                );
              } else {
                return Transform.scale(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                  scale: 2,
                );
              }
            } else {
              return Center(
                child: Transform.scale(
                  child: Text('Виберіть групу'),
                  scale: 2,
                ),
              );
            }
          }),
        ),
      ),
      bottomNavigationBar: !MyApp.isLoadingSchedule
          ? HomeNavigationBar(_homePageViewController)
          : SizedBox(),
    );
  }
}
