import 'dart:convert';

import 'package:barter/Screens/HomeScreen/ItemDetailsScreen.dart';
import 'package:barter/Screens/NuevoObjeto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MisObjetosTab extends StatefulWidget {
  @override
  _MisObjetosTab createState() => _MisObjetosTab();
}

class _MisObjetosTab extends State<MisObjetosTab> {

  List<Map<String, dynamic>> items = []; // Assuming your data is a list of strings

  @override
  void initState() {
    super.initState();
    _loadDataFromFirebase();
  }

  void _loadDataFromFirebase() async{
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    final databaseReference = FirebaseDatabase.instance.ref("Users/$userId/objectlist");
    DatabaseEvent event = await databaseReference.once();
    DataSnapshot dataSnapshot = event.snapshot;
    if (dataSnapshot.value != null && dataSnapshot.value is Map) {
      Map<dynamic, dynamic> dataMap = dataSnapshot.value as Map<dynamic, dynamic>;

      List<Map<String, dynamic>> loadedItems = [];

      // Iterate through the map values and convert them to a list of maps
      dataMap.forEach((key, value) {
        loadedItems.add(Map<String, dynamic>.from({
          'name': key,
          'usage': value['usage'],
          'comment': value['comment'],
          'value': value['value'],
          'image': value['image'],
          'phone': value['phone'],
        }));
      });

      setState(() {
        items = loadedItems;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: TextButton(onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemDetailsScreen(image: items[index]["image"], comment: items[index]["comment"],
                      name: items[index]["name"], usage: items[index]["usage"], value: items[index]["value"], phone: items[index]["phone"]),
                ),
              );
              },
                child: Column(
                  children: [
                    Image.network(
                      items[index]["image"], // Replace with your image path
                      height: 110, // Adjust the height as needed
                      width: 200, // Adjust the width as needed
                      fit: BoxFit.cover,
                    ),
                    Padding(padding: EdgeInsets.all(4),
                      child: Text(
                        items[index]["name"].toUpperCase(), // Replace with your item text
                        style: TextStyle(fontSize: 14.0, color: Colors.black),
                      ),
                    ),
                    Text(
                      'Uso: ${items[index]["usage"]}',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                    Text(
                      'Valor: ${items[index]["value"]}',
                      style: TextStyle(fontSize: 12.0, color: Colors.black),
                    ),
                  ],
                ),)
          );;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NuevoObjeto()),
          );
        },
        child: Icon(Icons.add,),
        mini: false,
      ),
    );
  }
}