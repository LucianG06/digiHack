import 'package:smart_list/screens/tinder/widgets/background_curve_widget.dart';
import 'package:smart_list/screens/tinder/widgets/cards_stack_widget.dart';
import 'package:flutter/material.dart';

void main() => runApp(const TinderScreen());

class TinderScreen extends StatelessWidget {
  const TinderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: const [
            BackgroudCurveWidget(),
            CardsStackWidget(),
          ],
        ),
      ),
    );
  }
}

enum Swipe { left, right, none }