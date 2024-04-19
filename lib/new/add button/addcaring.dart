import 'package:flutter/material.dart';

import 'package:flutter_application_1/linkapi.dart';
import 'package:flutter_application_1/new/CRUD.dart';

class AddCaring extends StatefulWidget {
  const AddCaring({super.key});

  @override
  State<AddCaring> createState() => _AddCaringState();
}

class _AddCaringState extends State<AddCaring> {
  Crud crud = Crud();

  bool isLoading = false;
  GlobalKey<FormState> formState = GlobalKey();

  TextEditingController caringname = TextEditingController();
  TextEditingController descriptionofcaringtype = TextEditingController();

  //addcaringtype

  addCaringType() async {
    isLoading = true;
    setState(() {});
    var response = await crud.postRequest(linkaddCaringType, {
      "name_caringtype": caringname.text,
      "description_caringtype": descriptionofcaringtype.text
    });
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
          "Add Caring ",
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
                                  color:
                                      const Color.fromARGB(255, 235, 176, 246),
                                ),
                                child: TextFormField(
                                    controller: caringname,
                                    decoration: const InputDecoration(
                                      hintText: "Caring Name",
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 20),
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color:
                                      const Color.fromARGB(255, 235, 176, 246),
                                ),
                                child: TextFormField(
                                  controller: descriptionofcaringtype,
                                  maxLines: 10,
                                  decoration: const InputDecoration(
                                    hintText: "Description",
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 250,
                              ),
                            ],
                          ))
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
                        await addCaringType();
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
