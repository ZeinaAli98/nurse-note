import 'package:flutter/material.dart';
import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:flutter_application_1/new/reports/carying.dart';

class Details extends StatefulWidget {
  final String idCaring;
  const Details({super.key, required this.idCaring});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<Data> caringDataList = [];
  bool isLoading = true;
  Crud crud = Crud();

  Future<void> fetchData() async {
    final response = await crud.getRequest(linkviewcaring);
    if (response is Map<String, dynamic> &&
        response.containsKey('status') &&
        response['status'] == 'success') {
      final List<dynamic> responseData = response['data'];
      final List<Data> parsedData = responseData
          .map((item) => Data.fromJson(item))
          .where((data) =>
              data.idCaring == widget.idCaring) // Filter data by idCaring
          .toList();
      setState(() {
        caringDataList = parsedData;
        isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch data');
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
        title: const Text(
          "Details",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: ListView(children: [
        Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                itemCount: caringDataList.length,
                itemBuilder: (context, index) {
                  final Data caringData = caringDataList[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                            "Caring Name : ${caringData.nameCaringtype}",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          )),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                              "Patient Name : ${caringData.namePatient}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Room Number : ${caringData.roomPatient}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text("Time of Caring : ${caringData.time}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: Text(
                              "Description of: ${caringData.descriptionCaring}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w400))),
                      Container(
                          margin: EdgeInsets.all(10),
                          child: int.parse(caringData.isStopped.toString()) == 1
                              ? Text("Status : Caring ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400))
                              : Text("Status : Done  ",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400))),
                      SizedBox(
                        height: 380,
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
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ]),
    );
  }
}
