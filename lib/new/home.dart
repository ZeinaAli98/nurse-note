import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:flutter_application_1/new/deteals.dart';

import 'package:flutter_application_1/new/editeNote.dart';
import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

class Data {
  String? idCaring;
  String? iDCaringtype;
  String? iDPatient;
  String? time;
  String? descriptionCaring;
  String? nameCaringtype;
  String? namePatient;
  String? isStopped;
  String? roomPatient;

  Data(
      {this.idCaring,
      this.iDCaringtype,
      this.iDPatient,
      this.time,
      this.descriptionCaring,
      this.nameCaringtype,
      this.namePatient,
      this.isStopped,
      this.roomPatient});

  Data.fromJson(Map<String, dynamic> json) {
    idCaring = json['id_caring'];
    iDCaringtype = json['ID_caringtype'];
    iDPatient = json['ID_patient'];
    time = json['time'];
    descriptionCaring = json['description_caring'];
    nameCaringtype = json['name_caringtype'];
    namePatient = json['name_patient'];
    isStopped = json['isStopped'];
    roomPatient = json['room_patient'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_caring'] = this.idCaring;
    data['ID_caringtype'] = this.iDCaringtype;
    data['ID_patient'] = this.iDPatient;
    data['time'] = this.time;
    data['description_caring'] = this.descriptionCaring;
    data['name_caringtype'] = this.nameCaringtype;
    data['name_patient'] = this.namePatient;
    data['isStopped'] = this.isStopped;
    data['room_patient'] = this.roomPatient;
    return data;
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading = true;
  Crud crud = Crud();

  TextEditingController isStopped = TextEditingController();
  TextEditingController caringname = TextEditingController();
  TextEditingController descriptionofcaringtype = TextEditingController();
  TextEditingController patientname = TextEditingController();
  TextEditingController roomnumber = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController descriptionCaring = TextEditingController();
  Map<String, String> caringById = {};
  Map<String, String> patientNameById = {};

  List<Data> caringDataList = [];

  Future<void> fetchData() async {
    final response = await crud.getRequest(linkviewcaring);
    if (response is Map<String, dynamic> &&
        response.containsKey('status') &&
        response['status'] == 'success') {
      final List<dynamic> responseData = response['data'];
      final List<Data> parsedData =
          responseData.map((item) => Data.fromJson(item)).toList();
      setState(() {
        caringDataList = parsedData;
        isLoading = false;
      });
    }
  }

  ///get caring name
  // Fetch caring name

  @override
  void initState() {
    fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: AssetImage('assets/images/logo_note.png'),
            ),
            SizedBox(width: 10),
            Text(
              "My Note",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        elevation: 2,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent,
                      ),
                      child: ListTile(
                        title: const Text(
                          'Add Note',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("AddMyNote");
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent,
                      ),
                      child: ListTile(
                        title: Container(
                          margin: const EdgeInsets.all(5),
                          child: const Text(
                            'Add Caring Type',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("AddCaring");
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent,
                      ),
                      child: ListTile(
                        title: const Text(
                          'Add Rooms',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("AddRooms");
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.purpleAccent,
                      ),
                      child: ListTile(
                        title: const Text(
                          'Add Patient',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.of(context).pushNamed("AddPatient");
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Add more list tiles for additional options
                  ],
                ),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(
              child: Text(
                "There is no notes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
              ),
            )
          : ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: const Text(
                          "Reports :",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        )),
                    Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("caryingtpe");
                                },
                                child: const Text(
                                  "Caring Type",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("carying");
                                },
                                child: const Text(
                                  "Caring",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("timming");
                                },
                                child: const Text(
                                  "Timing",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 140,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.purple),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.of(context).pushNamed("rooms");
                                },
                                child: const Text(
                                  "Rooms",
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        child: const Text(
                          "All Notes :",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: caringDataList.length,
                    itemBuilder: (context, index) {
                      final Data caringData = caringDataList[index];

                      return Container(
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: caringData.isStopped == '1'
                              ? Colors.purple
                              : null,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.purple,
                          ),
                        ),
                        child: InkWell(
                          onTap: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => Details(
                                  idCaring: caringData.idCaring.toString(),
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: ListTile(
                              title: SizedBox(
                                child: Text("${caringData.namePatient}"),
                              ),
                              titleTextStyle: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                              subtitle: Text(
                                  "\n${caringData.nameCaringtype}\n${caringData.time}"),
                              subtitleTextStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => Edite(
                                            nameCaringtype:
                                                caringData.nameCaringtype,
                                            descriptionCaring:
                                                caringData.descriptionCaring,
                                            namePatient: caringData.namePatient,
                                            roomPatient: caringData.roomPatient,
                                            time: caringData.time,
                                            iDCaringtype:
                                                caringData.iDCaringtype,
                                            iDPatient: caringData.iDPatient,
                                            idCaring: caringData.idCaring,
                                            isStopped: caringData.isStopped,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    // Rest of the IconButton code...
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      var response = await crud.postRequest(
                                          linkdeletecaring, {
                                        "id_caring":
                                            caringData.idCaring.toString()
                                      });
                                      if (response['status'] == "success") {
                                        Navigator.of(context)
                                            .pushReplacementNamed("homepage");
                                      }
                                    },
                                    icon: const Icon(Icons.delete),
                                  ),
                                  caringData.isStopped == '1'
                                      ? Text(
                                          "Caring",
                                          style: TextStyle(
                                              color: Colors.purple,
                                              fontWeight: FontWeight.bold),
                                        )
                                      : Text(
                                          "Done",
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold),
                                        )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
