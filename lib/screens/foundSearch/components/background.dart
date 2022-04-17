import 'package:flutter/material.dart';
import 'package:smart_list/components/rounded_button.dart';
import 'package:smart_list/screens/tinder/tinder_screen.dart';

import '../../../constants.dart';

void main() {
  runApp(Background());
}

class Background extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool like = false;
  List<Modal> typeList = List<Modal>.empty(growable: true);

  @override
  void initState() {
    typeList.add(Modal(name: 'Caine', isSelected: false));
    typeList.add(Modal(name: 'Pisica', isSelected: false));
    typeList.add(Modal(name: 'Alte animale', isSelected: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Ce animalut ai pierdut?'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ListView.builder(
                itemCount: typeList.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(10),
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: const Color(0xFFFCE4EC),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          typeList[index].name,
                        ),
                        Positioned(
                          child: IconButton(
                            icon: _iconControl(typeList[index].isSelected),
                            onPressed: () {
                              setState(() {
                                typeList.forEach((element) {
                                  element.isSelected = false;
                                });

                                typeList[index].isSelected = true;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            RoundedButton(
              text: "CAUTA",
              color: kPrimaryColor,
              textColor: Colors.white,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return TinderScreen();
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

  _iconControl(bool like) {
    if (like == false) {
      return Icon(Icons.check_circle_outline);
    } else {
      return Icon(
        Icons.check_circle,
        color: Colors.green,
      );
    }
  }
}

class Modal {
  String name;
  bool isSelected;

  Modal({required this.name, this.isSelected = false});
}
