import 'package:flutter/material.dart';

import '../main.dart';

class HomeNavigationBar extends StatefulWidget {
  const HomeNavigationBar(this.pageController, {Key? key}) : super(key: key);
  final PageController pageController;
  @override
  State<HomeNavigationBar> createState() => _HomeNavigationBarState();
}

class _HomeNavigationBarState extends State<HomeNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.article_outlined),
          label: "Розклад пар",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.airline_seat_individual_suite_outlined),
          label: "Екзамени",
        ),
      ],
      currentIndex: HomePage.currentPageIndex,
      onTap: (int index) => widget.pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 250),
        curve: Curves.ease,
      ),
    );
  }
}
