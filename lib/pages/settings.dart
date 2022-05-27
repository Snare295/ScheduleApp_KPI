import 'package:first_app/pages/settings_widgets/settings_list.dart';
import 'package:flutter/material.dart';

import 'settings_widgets/app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingsUpperBar(),
      body: SettingsList(),
    );
  }
}
