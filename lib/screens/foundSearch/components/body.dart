import 'package:flutter/material.dart';
import 'package:smart_list/screens/foundSearch/components/background.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    // This size provide us total height and width of our screen
    return Background();
  }
}
