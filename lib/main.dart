import 'dart:developer';

import 'package:first_app/modules/lessons_list.dart';
import 'package:flutter/material.dart';
import 'modules/.export.dart';

void main() {
  ApiHandler.getLessons;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<Groups> groupsList = [];
  static bool isLoadingGroups = true;
  static Schedule? scheduleList;
  static bool isLoadingSchedule = true;
  static String groupName = '';

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
    getGroups();
    if (MyApp.groupName != '') {
      getSchedule();
    }
  }

  Future<void> getGroupNameData() async {
    final prefs = await SharedPreferences.getInstance();
    String groupName = await prefs.getString('groupNameData') ?? '';
    inspect(groupName);
    setState(() => MyApp.groupName = groupName);
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
      LessonsList.scheduleIsFirst = !LessonsList.scheduleIsFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController _homePageViewController = PageController(initialPage: 0);
    return Scaffold(
      appBar: HomeAppBar(getSchedule, changeDayOfTheWeek),
      body: Container(
        color: Color(0xFFEEEEEE),
        child: !MyApp.isLoadingSchedule
            ? PageView(
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
              )
            : Transform.scale(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
                scale: 2,
              ),
      ),
      bottomNavigationBar: !MyApp.isLoadingSchedule
          ? HomeNavigationBar(_homePageViewController)
          : SizedBox(),
    );
  }
}
