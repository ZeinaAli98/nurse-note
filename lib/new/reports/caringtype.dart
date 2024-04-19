import 'package:flutter/material.dart';

import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:flutter_application_1/new/home.dart';
import 'package:flutter_application_1/sql.dart';

class CaringType extends StatefulWidget {
  CaringType({Key? key}) : super(key: key);

  @override
  State<CaringType> createState() => _CaringTypeState();
}

class _CaringTypeState extends State<CaringType> {
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
        filteredNotes = caringDataList;
      } else {
        filteredNotes = caringDataList
            .where((note) => note.nameCaringtype!
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
      print(filteredNotes);
    });
  }

  @override
  void initState() {
    fetchData();

    filteredNotes = caringDataList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Caring Type",
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
                labelText: 'Search by Caring Type',
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
                final caringData = filteredNotes[index];

                print("caring is : ${caringData.namePatient!}");
                return Container(
                  padding: const EdgeInsets.all(10),
                  child: Card(
                    child: ListTile(
                      title: Container(
                        margin: const EdgeInsets.all(5),
                        child: Text("${caringData.namePatient}"),
                      ),
                      titleTextStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                      trailing: Text("${caringData.nameCaringtype!}"),
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
