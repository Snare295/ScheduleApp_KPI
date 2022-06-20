import 'package:first_app/api.dart';
import 'package:first_app/main.dart';
import 'package:first_app/modules/lessons_list.dart';
import 'package:flutter/material.dart';

import 'package:first_app/pages/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar(this.parentState, this.changeWeek, {Key? key})
      : super(key: key);
  final Function parentState;
  final Function changeWeek;
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
          tooltip: 'Змінити неділю',
          icon: LessonsList.isSchedulFirst
              ? const Icon(Icons.filter_1)
              : const Icon(Icons.filter_2),
        )
      ],
      title: Text(MyApp.groupName),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate(this.changeIndex, this.update);
  final Function changeIndex;
  final Function update;

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
    List<Groups> suggestionsList = MyApp.groupsList.where((group) {
      final result = group.groupName.toLowerCase();
      final input = query.toLowerCase();

      return result.contains(input);
    }).toList();

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        final suggestion = suggestionsList[index];

        return ListTile(
          title: Text(suggestion.groupName),
          onTap: () {
            query = suggestion.groupName;
            MyApp.groupName = suggestion.groupName;
            changeGroupNameData(suggestion.groupName);
            MyApp.groupId = suggestion.groupId;
            changeGroupIdData(suggestion.groupId);
            update();
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

  Future<void> changeGroupNameData(String groupName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupNameData', groupName);
  }

  Future<void> changeGroupIdData(String groupId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('groupIdData', groupId);
  }
}
