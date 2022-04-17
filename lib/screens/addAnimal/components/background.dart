import 'package:flutter/material.dart';
import 'package:smart_list/components/rounded_button.dart';
import 'package:smart_list/screens/addedSuccess/addedSucces_screen.dart';

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
  final _name = TextEditingController();
  final _description = TextEditingController();
  bool _validateName = false;
  bool _validateDescription = false;

  @override
  void initState() {
    typeList.add(Modal(name: 'Caine', isSelected: false));
    typeList.add(Modal(name: 'Pisica', isSelected: false));
    typeList.add(Modal(name: 'Alte animale', isSelected: false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Ce animalut ai pierdut?'),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _name,
              decoration: InputDecoration(
                  hintText: "Introdu numele animalutului",
                  errorText: _validateName ? 'Nu ai introdus numele animalutului!' : null
              ),
            ),
            TextField(
              controller: _description,
              decoration: InputDecoration(
                  hintText: "Introdu o descriere",
                  errorText: _validateDescription ? 'Nu ai introdus o descriere' : null
              ),
            ),
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
              text: "ADAUGA",
              color: kPrimaryColor,
              textColor: Colors.white,
              press: () {
                _name.text.isEmpty ? _validateName = true : _validateName = false;
                _description.text.isEmpty ? _validateDescription = true : _validateDescription = false;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return AddedSuccessScreen();
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
