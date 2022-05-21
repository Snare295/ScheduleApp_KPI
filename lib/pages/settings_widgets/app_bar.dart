import "package:flutter/material.dart";

class SettingsUpperBar extends StatefulWidget implements PreferredSizeWidget {
  const SettingsUpperBar({Key? key}) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<SettingsUpperBar> createState() => _SettingsUpperBarState();
}

class _SettingsUpperBarState extends State<SettingsUpperBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text('Налаштування'),
    );
  }
}
