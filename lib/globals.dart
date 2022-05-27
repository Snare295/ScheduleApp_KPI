library globals;

import 'package:shared_preferences/shared_preferences.dart';

bool offsetByWeek = false;

Future<void> getDataGlobals() async {
  final prefs = await SharedPreferences.getInstance();

  offsetByWeek = prefs.getBool('offsetByWeekData') ?? false;
}
