import 'package:flutter/material.dart';
import 'package:smart_list/components/rounded_button.dart';
import 'package:smart_list/screens/addedSuccess/addedSucces_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../../constants.dart';

void main() {
  runApp(Background());
}

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));
DateTime now = DateTime.now();
String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    required this.userId,
    required this.type,
    required this.race,
    required this.latitude,
    required this.longitude,
    required this.datatime,
    required this.description,
  });

  int userId;
  String type;
  String race;
  double latitude;
  double longitude;
  String datatime;
  String description;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
    userId: json["userId"],
    type: json["type"],
    race: json["race"],
    latitude: json["latitude"].toDouble(),
    longitude: json["longitude"].toDouble(),
    datatime: json["datatime"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "type": type,
    "race": race,
    "latitude": latitude,
    "longitude": longitude,
    "datatime": datatime,
    "description": description,
  };
}

const String _endpointUrl = 'https://heroku-boot-digihack.herokuapp.com/addAnimal';

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

  void postAnimal() async {
    try {
      await http.post(Uri.parse(_endpointUrl), body:
      jsonEncode({
        "userId": "1",
        "type": "caine",
        "race": "maidanez",
        "latitude": 43.2442,
        "longitude": 15.1321,
        "datatime": DateFormat('kk:mm:ss \n EEE d MMM').format(now),
        "description": "dnvduhfvbdfhu"
      }));
    } catch(e) {
      print('Eroare!!!!!!!!!!');
      print(e);
    }
  }

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
              text: "ADAUGA IMAGINE",
              color: kPrimaryColor,
              textColor: Colors.white,
              press: () {},
            ),
            RoundedButton(
              text: "ADAUGA ANIMALUT",
              color: kPrimaryColor,
              textColor: Colors.white,
              press:() {
                _name.text.isEmpty ? _validateName = true : _validateName = false;
                _description.text.isEmpty ? _validateDescription = true : _validateDescription = false;
                postAnimal();
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
