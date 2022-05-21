import 'package:flutter/material.dart';

import 'settings_widgets/app_bar.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: SettingsUpperBar(),
      body: Text('there will be settings some time'),
    );
  }
}
