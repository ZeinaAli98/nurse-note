import 'package:flutter/material.dart';

import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/reports/carying.dart';
import 'package:flutter_application_1/sql.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Timming extends StatefulWidget {
  const Timming({super.key});

  @override
  State<Timming> createState() => _TimmingState();
}

class _TimmingState extends State<Timming> {
  SqlDb sqlDb = SqlDb();

  bool isLoading = true;

  List<Data> notes = [];

  bool isDescending = true; // Flag to determine the sort order

  void sortNotes(bool descending) {
    setState(() {
      isDescending = descending;
      notes.sort((a, b) => a.time!.compareTo(b.time.toString()));
      if (descending) {
        notes = notes.reversed.toList();
      }
    });
  }

  Future<void> readMyData() async {
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

          newNotes = newNotes
              .where((newNote) => !notes.any((existingNote) =>
                  existingNote.namePatient == newNote.namePatient))
              .toList();

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
      throw error; // Rethrow the error to propagate it to the caller
    }
  }

  //another option to sort
  DateTime? selectedDate; // Store the selected date for filtering

  void filterByDate(DateTime selectedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }

  List<Data> getFilteredNotes() {
    if (selectedDate == null) {
      return notes;
    } else {
      final filteredNotes = notes.where((note) {
        final noteDateTime = DateTime.parse(note.time.toString());
        final noteDate = DateTime(
          noteDateTime.year,
          noteDateTime.month,
          noteDateTime.day,
        );
        return noteDate.isAtSameMomentAs(selectedDate!);
      }).toList();

      if (filteredNotes.isEmpty) {
        return [
          Data(
            namePatient: 'No patients available at this time',
            time: '',
          ),
        ];
      }

      return filteredNotes;
    }
  }

  @override
  void initState() {
    readMyData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final filteredNotes = getFilteredNotes();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Timing",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () {
              showDatePicker(
                context: context,
                initialDate: selectedDate ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              ).then((date) {
                if (date != null) {
                  filterByDate(date);
                }
              });
            },
          ),
          DropdownButton(
            borderRadius: BorderRadius.circular(10),
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerRight,
            value: isDescending,
            onChanged: (value) => sortNotes(value!),
            items: const [
              DropdownMenuItem<bool>(
                value: true,
                child: Text('Newest'),
              ),
              DropdownMenuItem<bool>(
                value: false,
                child: Text('Oldest'),
              ),
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
                if (note.namePatient == 'No patients available at this time') {
                  return ListTile(
                    title: Text(note.namePatient!),
                  );
                } else {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      child: ListTile(
                        title: Container(
                          margin: const EdgeInsets.all(5),
                          child: Text(note.namePatient!),
                        ),
                        titleTextStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                        trailing: Text(note.time.toString()),
                      ),
                    ),
                  );
                }
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
