import 'package:flutter/material.dart';
import 'package:first_app/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(
          width: double.maxFinite,
          height: 10,
        ),
        TileOffsetByWeek(),
        const Divider(),
      ],
    );
  }
}

class TileOffsetByWeek extends StatefulWidget {
  TileOffsetByWeek({Key? key}) : super(key: key);

  @override
  State<TileOffsetByWeek> createState() => _TileOffsetByWeekState();
}

class _TileOffsetByWeekState extends State<TileOffsetByWeek> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text("Змістити на 1 неділю"),
      subtitle: const Text(
          "Включіть якщо пара ,яка зараз відображається, є на неділю вперед"),
      leading: const Icon(Icons.sync_alt_outlined),
      trailing: Switch(
        onChanged: changeOffsetByWeek,
        value: global.offsetByWeek,
      ),
    );
  }

  void changeOffsetByWeek(bool state) async {
    setState(() {
      global.offsetByWeek = state;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("offsetByWeekData", global.offsetByWeek);
  }
}
