import 'dart:io';

import 'package:barter/Screens/HomeScreen/HomeScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';


class NuevoObjeto extends StatefulWidget {
  @override
  _ImageUploadScreenState createState() => _ImageUploadScreenState();
}

class _ImageUploadScreenState extends State<NuevoObjeto> {
  File? _imageFile;
  final picker = ImagePicker();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _value = TextEditingController();
  final TextEditingController _comment = TextEditingController();
  final TextEditingController _cost = TextEditingController();
  final TextEditingController _contact = TextEditingController();
  final TextEditingController _usage = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void _loadDataToFirebase(name, value, contact, comment, usage) async{
    final storageRef = FirebaseStorage.instance.ref();
    final newImageUpload= storageRef.child("CentroDeCanje/$name.jpg");
    await newImageUpload.putFile(_imageFile!);
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    var image = await newImageUpload.getDownloadURL();
    final databaseReference = FirebaseDatabase.instance.ref("Users/$userId").child("objectlist");
    Map<String, dynamic> newObject = {
      "comment" : comment,
      "image" : image.toString(),
      "phone": contact,
      "usage" : usage,
      "value" : value
    };
    databaseReference.child(name).set(newObject);
  }
  Future<void> _uploadImage() async {
    if (_imageFile == null || _name.text== "" || _value.text== ""||
        _comment.text== "" || _usage.text== "" || _contact.text== "") {
      print('No image selected.');
      return;
    }

    try {
      _loadDataToFirebase(_name.text, _value.text, _contact.text, _comment.text, _usage.text);
      print('Image uploaded successfully!');
      Future.delayed(Duration(seconds: 2), () {
        // Move to the next screen and remove the previous one
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      });
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nuevo Objeto'),
        backgroundColor: Color(0xff471f53),
      ),
      body: ListView(
        children: [
          SizedBox(height: 20),
          _imageFile != null
              ? Image.file(
            _imageFile! as File,
            height: 150,
            width: 150,
          )
              : Text('No se ha seleccionado objeto'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _pickImage,
            child: Text('Foto'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _uploadImage,
            child: Text('Subir Foto'),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: _name,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.transparent),
                  labelText: 'Nombre del objeto',
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Por favor ingresa el nombre del objeto'),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: _usage,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.transparent),
                  labelText: 'Uso',
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Por favor insgresa el tiempo de uso del objeto'),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: _value,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.transparent),
                  labelText: 'valor',
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Por favor ingresa el valor estimado del objeto'),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: _comment,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.transparent),
                  labelText: 'Comentario',
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Por favor ingresa un comentario sobre el objeto'),
            ),
          ),
          Padding(padding: EdgeInsets.all(10),
            child: TextField(
              controller: _contact,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  focusedBorder:OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  floatingLabelStyle: TextStyle(color: Colors.transparent),
                  labelText: 'Contacto',
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Por favor ingresa un numero de contacto'),
            ),
          ),
        ],
      )
    );
  }
}
