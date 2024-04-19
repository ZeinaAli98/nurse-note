import 'package:flutter/material.dart';
import 'package:flutter_application_1/new/add%20button/AddNote.dart';
import 'package:flutter_application_1/new/add%20button/addcaring.dart';

import 'package:flutter_application_1/new/add%20button/addpatient.dart';
import 'package:flutter_application_1/new/add%20button/addrooms.dart';
import 'package:flutter_application_1/new/reports/caringtype.dart';
import 'package:flutter_application_1/new/reports/carying.dart';
import 'package:flutter_application_1/new/deteals.dart';
import 'package:flutter_application_1/new/editeNote.dart';

import 'package:flutter_application_1/new/home.dart';

import 'package:flutter_application_1/new/reports/rooms.dart';
import 'package:flutter_application_1/new/reports/timing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purpleAccent,
          background: Color.fromARGB(255, 246, 211, 252),
        ),
      ),
      home: Home(),
      routes: {
        "homepage": (context) => Home(),
        "editnote": (context) => Edite(),
        "caryingtpe": (context) => CaringType(),
        "carying": (context) => Caring(),
        "timming": (context) => Timming(),
        "rooms": (context) => Rooms(),
        "AddCaring": (context) => AddCaring(),
        "AddPatient": (context) => AddPatient(),
        "AddRooms": (context) => AddRooms(),
        "AddMyNote": (context) => AddMyNote(),
      },
    );
  }
}
