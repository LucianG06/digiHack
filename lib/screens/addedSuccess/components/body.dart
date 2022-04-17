import 'package:flutter/material.dart';
import 'package:smart_list/screens/addedSuccess/components/background.dart';
import 'package:smart_list/components/rounded_button.dart';
import 'package:smart_list/constants.dart';
import 'package:smart_list/screens/welcome/welcome_screen.dart';

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
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 120,
            ),
            SizedBox(height: size.height * 0.05),
            Text(
              "Animalut adaugat cu succes!",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.05),
            RoundedButton(
              text: "PAGINA PRINCIPALA",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return WelcomeScreen();
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
