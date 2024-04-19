import 'package:flutter/material.dart';
import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

class Caring extends StatefulWidget {
  const Caring({Key? key});

  @override
  State<Caring> createState() => _CaringState();
}

class _CaringState extends State<Caring> {
  bool isLoading = true;
  List<Data> notes = [];
  bool isStoppedValue = true;
  int selectedNoteIndex = 0;
  Crud crud = Crud();
  Future<void> fetchDataFromServer() async {
    try {
      final response = await http.get(Uri.parse(linkviewcaring));

      if (response.statusCode == 200) {
        final dynamic responseData = json.decode(response.body);
        print("Response body: $responseData");
        print("Response body type: ${responseData.runtimeType}");
        if (responseData is Map<String, dynamic>) {
          final List<dynamic> data = responseData['data'];

          List<Data> newNotes = data.map((item) {
            return Data(
              descriptionCaring: item['description_caring'] ?? '',
              iDCaringtype: item['ID_caringtype'] ?? '',
              iDPatient: item['ID_patient'] ?? '',
              roomPatient: item['room_patient'].toString(),
              namePatient: item['name_patient'],
              nameCaringtype: item['name_caringtype'],
              time: item['time'],
              idCaring: item['id_caring'],
              isStopped: item['isStopped'],
            );
          }).toList();

          newNotes =
              newNotes.where((newNote) => newNote.isStopped == '1').toList();

          setState(() {
            notes = newNotes;
            isLoading = false;
          });
        } else {
          print('Invalid response data format');
        }
      } else {
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      throw error;
    }
  }

  @override
  void initState() {
    fetchDataFromServer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final data = notes.where((note) => note.isStopped == '1');
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Caring",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: data.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final note = notes
                    .where((note) => note.isStopped == '1')
                    .toList()[index];
                print("data is : ${note.namePatient!}");
                return Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.purple,
                    ),
                  ),
                  child: Card(
                    child: ListTile(
                      title: Container(
                        padding: const EdgeInsets.all(10),
                        child: Text("${note.namePatient!}"),
                      ),
                      titleTextStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      trailing: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.purple,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Done",
                            style: TextStyle(color: Colors.purple),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.purpleAccent,
              ),
              child: MaterialButton(
                onPressed: () {},
                child: Text(
                  'Print',
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
