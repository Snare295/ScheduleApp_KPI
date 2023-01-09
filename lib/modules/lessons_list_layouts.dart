import 'package:flutter/cupertino.dart';

class TwoColumnLayout extends StatelessWidget {
  const TwoColumnLayout(this.widgets, {Key? key}) : super(key: key);
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    if (widgets.length > 6) {
      throw 'TwoColumnLayout received exceeded amount of widgets';
    }

    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widgets[0]),
          Expanded(child: widgets[1]),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widgets[2]),
          Expanded(child: widgets[3]),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widgets[4]),
          Expanded(child: widgets[5]),
        ],
      )
    ]);
  }
}

class ThreeColumnLayout extends StatelessWidget {
  const ThreeColumnLayout(this.widgets, {Key? key}) : super(key: key);
  final List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    if (widgets.length > 6) {
      throw 'ThreeColumnLayout received exceeded amount of widgets';
    }

    return Column(children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widgets[0]),
          Expanded(child: widgets[1]),
          Expanded(child: widgets[2]),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: widgets[3]),
          Expanded(child: widgets[4]),
          Expanded(child: widgets[5]),
        ],
      ),
    ]);
    ;
  }
}
