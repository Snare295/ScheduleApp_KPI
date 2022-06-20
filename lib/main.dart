import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'modules/.export.dart';
import 'globals.dart' as global;
import 'package:dynamic_color/dynamic_color.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await global.getDataGlobals();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<Groups> groupsList = [];
  static bool isLoadingGroups = true;
  static Schedule? scheduleList;
  static bool isLoadingSchedule = true;
  static String groupName = '';
  static String groupId = '';
  static DateTime timeInWeek = DateTime.now();
  static bool isFirstWeek = true;

  static get timeWeek {
    const int timeEpochOffset =
        946857600000; //2000/01/03 first monday in 2000. miliseconds from epoch
    const int oneWeek = 604800000;
    int now = DateTime.now().millisecondsSinceEpoch;
    if (global.offsetByWeek) {
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
    var timeInWeek = DateTime.fromMillisecondsSinceEpoch(now);
    return timeInWeek;
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ThemeData lightTheme;
      ThemeData darkTheme;

      if (lightDynamic != null && darkDynamic != null) {
        lightTheme = getDynamicLightTheme(lightDynamic);
        darkTheme = getDynamicDarkTheme(darkDynamic);
      } else {
        lightTheme = getLightTheme();
        darkTheme = getDarkTheme();
      }

      return MaterialApp(
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const HomePage(),
      );
    });
  }
}

//This page is embeded in main.dart file, for rerouting change main function
//Don't make this page in separate file. This page is base for app and donesn't need to
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static int currentPageIndex = 0;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  initState() {
    super.initState();
    getGroupNameData();
    getGroupIdData();
    MyApp.timeInWeek = MyApp.timeWeek;
    getGroups();
  }

  Future<void> getGroupNameData() async {
    final prefs = await SharedPreferences.getInstance();
    String groupName = prefs.getString('groupNameData') ?? '';
    setState(() => MyApp.groupName = groupName);
  }

  Future<void> getGroupIdData() async {
    final prefs = await SharedPreferences.getInstance();
    MyApp.groupId = prefs.getString('groupIdData') ?? '';
    if (MyApp.groupId != '') {
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
    MyApp.scheduleList = await ApiHandler.getLessons();
    setState(() {
      MyApp.isLoadingSchedule = false;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('scheduleData', jsonEncode(MyApp.scheduleList));
  }

  void changeDayOfTheWeek() {
    setState(() {
      LessonsList.isSchedulFirst = !LessonsList.isSchedulFirst;
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController _homePageViewController = PageController(initialPage: 0);
    return Scaffold(
      appBar: HomeAppBar(getSchedule, changeDayOfTheWeek),
      body: Builder(
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
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
                scale: 2,
              );
            }
          } else {
            return Center(
              child: Transform.scale(
                child: const Text('Виберіть групу'),
                scale: 2,
              ),
            );
          }
        }),
      ),
      bottomNavigationBar: !MyApp.isLoadingSchedule
          ? HomeNavigationBar(_homePageViewController)
          : const SizedBox(),
    );
  }
}
