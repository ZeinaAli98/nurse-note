import 'package:flutter/material.dart';

import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class AddRooms extends StatefulWidget {
  const AddRooms({Key? key}) : super(key: key);

  @override
  State<AddRooms> createState() => _AddRoomsState();
}

class _AddRoomsState extends State<AddRooms> {
  Crud crud = Crud();

  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController roomnumber = TextEditingController();
  XFile? selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      selectedImage = image;
    });
  }

  // addRooms
  addRooms() async {
    if (selectedImage == null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            icon: Icon(
              Icons.warning_rounded,
              size: 50,
              color: Colors.purple,
            ),
            title: const Text("Note"),
            titleTextStyle: TextStyle(
                fontSize: 25,
                color: Colors.purple,
                fontWeight: FontWeight.bold),
            content: const Text("Please select a room photo."),
            contentTextStyle: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.w300),
            actions: <Widget>[
              TextButton(
                child: const Text(
                  "OK",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.purple,
                      fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
              ),
            ],
          );
        },
      );
      return null; // Exit the function without further execution
    }

    isLoading = true;
    setState(() {});
    var response = await crud.postRequestWithFile(
      linkaddrooms,
      {
        "number_rooms": roomnumber.text,
      },
      selectedImage!,
    );
    isLoading = false;
    setState(() {});
    if (response['status'] == "success") {
      print("Add caring successfully...");
      Navigator.of(context)
          .pushNamedAndRemoveUntil("homepage", (route) => false);
    } else {
      print("Add caring Fail...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text(
          "Add Rooms",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: isLoading == true
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.purpleAccent,
              ),
            )
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
                                controller: roomnumber,
                                decoration: const InputDecoration(
                                  hintText: "Room Number",
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                width: double.infinity,
                                height: 300,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 235, 176, 246),
                                ),
                                child: selectedImage != null
                                    ? Image.file(
                                        File(selectedImage!
                                            .path), // Convert String to File
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(
                                        Icons.camera_alt,
                                        size: 50,
                                        color: Colors.purple,
                                      ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
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
                        await addRooms();
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
