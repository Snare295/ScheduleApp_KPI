import 'package:first_app/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/modules/lessons_list.dart';
import 'package:flutter/material.dart';
import 'package:first_app/main.dart';

import 'package:first_app/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  HomeAppBar(this.parentState, this.changeWeek, {Key? key}) : super(key: key);
  final parentState;
  final changeWeek;
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> {
  void changeText(String name) {
    setState(() {
      MyApp.groupName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.settings),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: ((context) => const SettingsPage())),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => showSearch(
              context: context,
              delegate: MySearchDelegate(changeText, widget.parentState)),
          icon: const Icon(Icons.search),
        ),
        IconButton(
          onPressed: () => {widget.changeWeek()},
          icon: LessonsList.scheduleIsFirst
              ? Icon(Icons.filter_1)
              : Icon(Icons.filter_2),
        )
      ],
      title: Text(MyApp.groupName),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate(Function this.changeIndex, Function this.update);
  final changeIndex;
  final update;

  List<String> searchList = convertGroupsToString(MyApp.groupsList);

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () => query = '',
        icon: const Icon(Icons.close),
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionsList = searchList.where((searchListElement) {
      final result = searchListElement.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        final suggestion = suggestionsList[index];

        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            MyApp.groupName = query;
            update();
            changeGroupNameData(query);
            close(context, changeIndex(query));
          },
        );
      },
    );
  }

  @override
  buildResults(BuildContext context) {
    return buildSuggestions(context);
  }
}

List<String> convertGroupsToString(List<Groups> groupsList) {
  List<String> cum = [];
  for (Groups e in groupsList) {
    cum.add(e.groupName.toString());
  }
  return cum;
}

Future<void> changeGroupNameData(String groupName) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('groupNameData', groupName);
}
