import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application_1/new/CRUD.dart';

import 'package:http/http.dart' as http;
import 'package:flutter_application_1/linkapi.dart';

class AddPatient extends StatefulWidget {
  const AddPatient({Key? key}) : super(key: key);

  @override
  State<AddPatient> createState() => _AddPatientState();
}

class _AddPatientState extends State<AddPatient> {
  Crud crud = Crud();
  String? _value;

  List<String> roomNumbers = [];
  ////////get data menue room number from database

// ...

  Future<List<String>> getRoomNumber() async {
    final res = await crud.getRequest(linkviewrooms);
    print(res);

    if (res != null && res.containsKey("data")) {
      var roomData = res["data"];

      if (roomData is List) {
        List<String> roomNumbers =
            roomData.map((room) => room["number_rooms"].toString()).toList();
        print(roomNumbers);
        return roomNumbers;
      } else {
        print("Invalid response format: Unexpected room data structure");
        throw Exception("Invalid response format");
      }
    } else {
      print("Failed to fetch room data.");
      throw Exception("Failed to fetch room data");
    }
  }

  Future<void> fetchRoomNumbers() async {
    try {
      List<String> numbers = await getRoomNumber();
      setState(() {
        roomNumbers = numbers;
      });
    } catch (error) {
      print('Error fetching room numbers: $error');
    }
  }

  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController isStopped = TextEditingController();
  TextEditingController patientname = TextEditingController();
  TextEditingController roomnumber = TextEditingController();

  int selectedIndex = 0;
  List<String> buttonLabels = ['Caring', 'Not Caring'];

  //addpatients

  addPatients() async {
    isLoading = true;
    setState(() {});

    var response = await crud.postRequest(linkaddpateints, {
      "name_patient": patientname.text,
      "isStopped": isStopped.text,
    });

    isLoading = false;
    setState(() {});

    if (response != null && response.containsKey("status")) {
      if (response['status'] == "success") {
        print("Add patients successfully...");
        Navigator.of(context)
            .pushNamedAndRemoveUntil("homepage", (route) => false);
        print("$response");
        Navigator.of(context).pushNamed("homepage");
      } else {
        print("Add patients Fail...");
      }
    } else {
      print("Invalid response from the server");
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRoomNumbers(); // Call fetchRoomNumbers in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          'Add Patient',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.purpleAccent,
            ))
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Form(
                        key: formState,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 20),
                              width: double.infinity,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: const Color.fromARGB(255, 235, 176, 246),
                              ),
                              child: TextFormField(
                                controller: patientname,
                                decoration: const InputDecoration(
                                  hintText: 'Patient Name',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.purpleAccent,
                    ),
                    child: MaterialButton(
                      onPressed: () async {
                        await addPatients();
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
