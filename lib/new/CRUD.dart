import 'dart:convert' as convert;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:http/http.dart' as http;

class Crud {
  //GetData
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsbody =
            convert.jsonDecode(response.body) as Map<String, dynamic>;
        return responsbody;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print("Error is : $error");
    }
  }

  //PostData

  postRequest(String url, Map data) async {
    try {
      var response = await http.post(Uri.parse(url), body: data);
      if (response.statusCode == 200) {
        var responsbody = convert.jsonDecode(response.body);
        return responsbody;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (error) {
      print("Error is : $error");
    }
  }

  postRequestWithFile(String url, Map data, XFile? file) async {
    var request = http.MultipartRequest("POST", Uri.parse(url));
    var lenght = await file!.length();
    var stream = http.ByteStream(file.openRead());
    var multipartFile = http.MultipartFile("image_rooms", stream, lenght,
        filename: basename(file.path));
    request.files.add(multipartFile);
    data.forEach((key, value) {
      request.fields[key] = value;
    });
    var myrequest = await request.send();
    var response = await (http.Response.fromStream(myrequest));
    if (myrequest.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Erorr is : ${myrequest.statusCode}");
    }
  }
}
