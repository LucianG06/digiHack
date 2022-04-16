import 'package:flutter/material.dart';
import 'package:smart_list/screens/lost/lost_screen.dart';
import 'package:smart_list/screens/found/found_screen.dart';
import 'package:smart_list/screens/lost_found/components/background.dart';
import 'package:smart_list/components/rounded_button.dart';
import 'package:smart_list/constants.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Image.asset(
              "assets/images/cutu_feli.jpeg",
              height: size.height * 0.45,
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "PIERDUT",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LostScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "GASIT",
              color: kPrimaryColor,
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return FoundScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
