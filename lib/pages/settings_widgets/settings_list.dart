import 'package:flutter/material.dart';
import 'package:first_app/globals.dart' as global;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class SettingsList extends StatelessWidget {
  const SettingsList({Key? key}) : super(key: key);
  static const double verticalTileMargin = 8;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        TileOffsetByWeek(),
        Divider(height: 2),
        TileAboutAppInfo(),
        Divider(height: 2),
      ],
    );
  }
}

class TileOffsetByWeek extends StatefulWidget {
  const TileOffsetByWeek({Key? key}) : super(key: key);

  @override
  State<TileOffsetByWeek> createState() => _TileOffsetByWeekState();
}

class _TileOffsetByWeekState extends State<TileOffsetByWeek> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: SettingsList.verticalTileMargin,
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

class TileAboutAppInfo extends StatelessWidget {
  const TileAboutAppInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AboutListTile(
      icon: Icon(Icons.info),
      applicationIcon: FlutterLogo(),
      aboutBoxChildren: [
        Text('This app created by Snare295 and other contributors'),
        Center(
          child: ElevatedButton(
              onPressed: () async {
                await launchUrlString(
                    'https://github.com/Snare295/ScheduleApp_KPI',
                    mode: LaunchMode.externalApplication);
              },
              child: Text('Repository of the app')),
        ),
      ],
    );
  }
}
