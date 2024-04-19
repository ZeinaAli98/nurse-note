import 'package:flutter/material.dart';

import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:flutter_application_1/new/reports/carying.dart';
import 'package:flutter_application_1/sql.dart';

class Rooms extends StatefulWidget {
  const Rooms({super.key});

  @override
  State<Rooms> createState() => _RoomsState();
}

class _RoomsState extends State<Rooms> {
  Crud crud = Crud();

  List<Data> filteredNotes = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

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
        filterNotes('');
      });
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  void filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNotes = [...caringDataList];
      } else {
        filteredNotes = caringDataList
            .where((note) =>
                note.roomPatient!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      print(filteredNotes);
    });
  }

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
        title: const Text(
          "Rooms",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 70,
            child: TextField(
              controller: searchController,
              onChanged: filterNotes,
              decoration: InputDecoration(
                labelText: 'Search by roomNumber',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredNotes.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final note = filteredNotes[index];
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
                      trailing: Text(note.roomPatient!),
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
