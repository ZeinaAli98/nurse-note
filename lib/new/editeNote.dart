import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/new/CRUD.dart';

import 'package:flutter_application_1/new/home.dart';
import 'package:flutter_application_1/linkapi.dart';

class Edite extends StatefulWidget {
  String? idCaring;
  String? iDCaringtype;
  String? iDPatient;
  String? time;
  String? descriptionCaring;
  String? nameCaringtype;
  String? namePatient;
  String? isStopped;
  String? roomPatient;
  final Function(Data)? onUpdate;
  Edite(
      {super.key,
      this.idCaring,
      this.iDCaringtype,
      this.iDPatient,
      this.time,
      this.descriptionCaring,
      this.nameCaringtype,
      this.namePatient,
      this.isStopped,
      this.roomPatient,
      this.onUpdate});

  @override
  State<Edite> createState() => _EditeState();
}

class _EditeState extends State<Edite> {
  String? selectedOption;
  Crud crud = Crud();
  bool isLoading = false;

  int selectedIndex = 0;
  List<String> buttonLabels = ['Caring', 'Not Caring'];
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController caringname = TextEditingController();
  TextEditingController descriptionofcaringtype = TextEditingController();
  TextEditingController patientname = TextEditingController();
  TextEditingController roomnumber = TextEditingController();
  TextEditingController time = TextEditingController();
  TextEditingController isStopped = TextEditingController();
  TextEditingController descriptionCaring = TextEditingController();

  String? valueroom;
  String? valuepatent;
  String? valuecaring;
  String? valuedescr;
  List<dynamic> data = [];
  List<String> roomNumbers = [];
  List<String> patientName = [];
  List<String> caring = [];
  List<String> patientId = [];
  List<String> caringId = [];

  //dataTime Function
  Future<void> _selectDateTime() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        final DateTime dateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          time.text = dateTime.toString();
        });
      }
    }
  }

// editeCaring function
  Future<void> editeCaring() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetching caring and patient IDs
      List<String> caringIds = await getCaringId();
      List<String> patientIds = await getPatientId();

      // Selecting caring and patient IDs based on the name values
      String selectedCaringId = caringIds.isNotEmpty
          ? caringIds[caring.indexOf(caringname.text)]
          : '';
      String selectedPatientId = patientIds.isNotEmpty
          ? patientIds[patientName.indexOf(patientname.text)]
          : '';

      // Creating a request body with updated data
      Map<String, dynamic> requestBody = {
        "time": time.text,
        "description_caring": descriptionCaring.text,
        "ID_caringtype": selectedCaringId,
        "ID_patient": selectedPatientId,
        "isStopped": isStopped.text,
        "room_patient": roomnumber.text,
        "id_caring": widget.idCaring
      };

      // Making the API request to edit caring data
      var response = await crud.postRequest(linkeditecaring, requestBody);

      setState(() {
        isLoading = false;
      });

      // Handling the API response
      if (response != null && response.containsKey('status')) {
        if (response['status'] == "success") {
          print("Edit caring successful...");
          // Navigating back to the home page
          Navigator.of(context)
              .pushNamedAndRemoveUntil("homepage", (route) => false);
        } else {
          print("Edit caring failed...");
          // Handle failure scenario
        }
      } else {
        print("Invalid response format...");
        // Handle invalid response format
      }
    } catch (error) {
      print('Error editing caring: $error');
      // Handle the error gracefully, e.g., display an error message to the user
    }
  }

  //GetRoomNumber Function
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

  //FetchRoom Function
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

  //Get PatientName Function
  Future<List<String>> getPatientName() async {
    try {
      final res = await crud.getRequest(linkviewpateints);
      print(res);

      if (res != null && res.containsKey("data")) {
        var nameData = res["data"];

        if (nameData is List) {
          List<String> patientName =
              nameData.map((name) => name["name_patient"].toString()).toList();
          print(patientName);
          return patientName;
        } else {
          print("Invalid response format: Unexpected room data structure");
          throw Exception("Invalid response format");
        }
      } else {
        print("Failed to fetch room data.");
        throw Exception("Failed to fetch room data");
      }
    } catch (error) {
      print('Error fetching patient names: $error');
      // Handle the error gracefully, e.g., display an error message to the user
      throw Exception("Failed to fetch patient names");
    }
  }

//get patient id
  Future<List<String>> getPatientId() async {
    try {
      final res = await crud.getRequest(linkviewpateints);
      print(res);

      if (res != null && res.containsKey("data")) {
        var nameData = res["data"];

        if (nameData is List) {
          List<String> patientId =
              nameData.map((name) => name["id_patient"].toString()).toList();
          print(patientId);
          return patientId;
        } else {
          print("Invalid response format: Unexpected room data structure");
          throw Exception("Invalid response format");
        }
      } else {
        print("Failed to fetch patientid data.");
        throw Exception("Failed to patientid room data");
      }
    } catch (error) {
      print('Error fetching patient id: $error');
      // Handle the error gracefully, e.g., display an error message to the user
      throw Exception("Failed to fetch patient id");
    }
  }

  //PatientName Function
  Future<void> fetchPatientName() async {
    try {
      List<String> names = await getPatientName();
      setState(() {
        patientName = names;
      });
      print(patientName);
    } catch (error) {
      print('Error fetching room numbers: $error');
    }
  }

  ///get caring name
  Future<List<String>> getCaringName() async {
    final res = await crud.getRequest(linkviewCaringType);
    print(res);

    if (res != null && res.containsKey("data")) {
      var caringData = res["data"];

      if (caringData is Map<String, dynamic>) {
        // Check if the data is an object
        List<String> caring = [
          caringData["name_caringtype"].toString()
        ]; // Create a list with a single item
        print(caring);
        return caring;
      } else if (caringData is List<dynamic>) {
        // Check if the data is an array
        List<String> caring = caringData
            .map((room) => room["name_caringtype"].toString())
            .toList();
        print(caring);
        return caring;
      } else {
        print("Invalid response format: Unexpected caring data structure");
        throw Exception("Invalid response format");
      }
    } else {
      print("Failed to fetch caring data.");
      throw Exception("Failed to fetch caring data");
    }
  }

//get caring id
  Future<List<String>> getCaringId() async {
    final res = await crud.getRequest(linkviewCaringType);
    print(res);

    if (res != null && res.containsKey("data")) {
      var caringData = res["data"];

      if (caringData is Map<String, dynamic>) {
        // Check if the data is an object
        List<String> caringId = [
          caringData["id_caringtype"].toString()
        ]; // Create a list with a single item
        print(caringId);
        return caringId;
      } else if (caringData is List<dynamic>) {
        // Check if the data is an array
        List<String> caringId =
            caringData.map((room) => room["id_caringtype"].toString()).toList();
        print(caringId);
        return caringId;
      } else {
        print("Invalid response format: Unexpected caring data structure");
        throw Exception("Invalid response format");
      }
    } else {
      print("Failed to fetch caring id data.");
      throw Exception("Failed to fetch caring id data");
    }
  }

  //Fetchcaring Function
  Future<void> fetchCaringName() async {
    try {
      List<String> numbers = await getCaringName();
      setState(() {
        caring = numbers;
      });
    } catch (error) {
      print('Error fetching caring numbers: $error');
    }
  }

  ///
  Future<String?> getDescriptionForCaringName(String caringName) async {
    final res = await crud.getRequest(linkviewCaringType);
    print(res);

    if (res != null && res.containsKey("data")) {
      var caringData = res["data"];

      if (caringData is List<dynamic>) {
        for (var item in caringData) {
          if (item["name_caringtype"] == caringName) {
            return item["description_caringtype"];
          }
        }
      } else if (caringData is Map<String, dynamic>) {
        if (caringData["name_caringtype"] == caringName) {
          return caringData["description_caringtype"];
        }
      }
    }

    print("Failed to fetch description for caring name: $caringName");
    return null;
  }

  @override
  void initState() {
    super.initState();

    caringname.text = widget.nameCaringtype ?? '';
    descriptionofcaringtype.text = widget.descriptionCaring ?? '';
    patientname.text = widget.namePatient ?? '';
    roomnumber.text = widget.roomPatient?.toString() ?? '';
    time.text = widget.time ?? '';
    isStopped.text = widget.isStopped ?? '';

    fetchRoomNumbers();
    fetchPatientName();
    fetchCaringName();
    getPatientId();
    getCaringId();
  }

  @override
  void dispose() {
    // Dispose the TextEditingController
    caringname.dispose();
    patientname.dispose();
    roomnumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "EditeMyNote ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(children: [
              Form(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<String>>(
                      future: Future.delayed(Duration.zero).then((_) => caring),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: Colors.purpleAccent),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          List<String> data = snapshot.data!;

                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 235, 176, 246),
                                ),
                                child: TextFormField(
                                  controller: caringname,
                                  decoration: InputDecoration(
                                    hintText: "Caring Name",
                                    suffixIcon: DropdownButton(
                                      value: valuecaring,
                                      items: data.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        );
                                      }).toList(),
                                      onChanged: (v) {
                                        setState(() {
                                          valuecaring = v;
                                          caringname.text = valuecaring ?? '';
                                        });

                                        // Fetch the description value based on the selected caring name
                                        String selectedCaringName = v as String;
                                        getDescriptionForCaringName(
                                                selectedCaringName)
                                            .then((description) {
                                          setState(() {
                                            descriptionofcaringtype.text =
                                                description ?? '';
                                          });
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                width: double.infinity,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromARGB(255, 235, 176, 246),
                                ),
                                child: TextFormField(
                                  controller: descriptionofcaringtype,
                                  decoration:
                                      InputDecoration(hintText: "Description"),
                                ),
                              ),
                            ],
                          );
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<String>>(
                      future: Future.delayed(Duration.zero)
                          .then((_) => patientName),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> data = snapshot.data!;

                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 235, 176, 246),
                            ),
                            child: TextFormField(
                              controller: patientname,
                              decoration: InputDecoration(
                                hintText: "Patient Name",
                                suffixIcon: DropdownButton(
                                  value: valuepatent,
                                  items: data.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        );
                                      }).toList() ??
                                      [],
                                  onChanged: (v) {
                                    setState(() {
                                      valuepatent = v as String?;
                                      patientname.text = valuepatent ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.purpleAccent));
                        }
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    FutureBuilder<List<String>>(
                      future: Future.delayed(Duration.zero)
                          .then((_) => roomNumbers),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<String> data = snapshot.data!;

                          return Container(
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color.fromARGB(255, 235, 176, 246),
                            ),
                            child: TextFormField(
                              controller: roomnumber,
                              decoration: InputDecoration(
                                hintText: "Room Name",
                                suffixIcon: DropdownButton(
                                  value: valueroom,
                                  items: data.map((e) {
                                        return DropdownMenuItem(
                                          child: Text(e),
                                          value: e,
                                        );
                                      }).toList() ??
                                      [],
                                  onChanged: (v) {
                                    setState(() {
                                      valueroom = v as String?;
                                      roomnumber.text = valueroom ?? '';
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: Colors.purpleAccent));
                        }
                      },
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 235, 176, 246),
                      ),
                      child: TextFormField(
                          controller: time,
                          onTap: () {
                            _selectDateTime();
                          },
                          decoration: const InputDecoration(
                            suffixIcon: Icon(Icons.calendar_month_outlined),
                            suffixIconColor: Colors.purple,
                            hintText: "Time",
                          )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        buttonLabels.length,
                        (index) => Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  selectedIndex = index;
                                  if (index == 0) {
                                    isStopped.text = '1';
                                  } else {
                                    isStopped.text = '0';
                                  }
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: selectedIndex == index
                                    ? Colors.white
                                    : Colors.purple,
                                backgroundColor: selectedIndex == index
                                    ? Colors.purple
                                    : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: BorderSide(
                                    color: Colors.purple,
                                  ),
                                ),
                              ),
                              child: Text(buttonLabels[index]),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color.fromARGB(255, 235, 176, 246),
                      ),
                      child: TextFormField(
                        controller: descriptionCaring,
                        maxLines: 10,
                        decoration: const InputDecoration(
                          hintText: "Description",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
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
                onPressed: () async {
                  await editeCaring();
                },
                child: Text(
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
