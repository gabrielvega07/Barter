import 'dart:io';

import 'package:barter/Screens/Login/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pdf/widgets.dart' as pw;


class MiPerfilTab extends StatefulWidget {
  @override
  _MiPerfilTab createState() => _MiPerfilTab();
}

class _MiPerfilTab extends State<MiPerfilTab> {
  var name = "";
  var email = "";
  var picture = "https://cdn-icons-png.flaticon.com/512/4645/4645949.png";
  List<String> comments = [];

  @override
  Widget build(BuildContext context) {
    _loadData();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(picture),
          ),
          SizedBox(height: 20),
          Text(
            name,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            email,
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _signOut(context);
            },
            child: Text('Log out'),
          ),
          SizedBox(height: 20),
          FloatingActionButton(
            onPressed: () {
              generateAndSavePDF();
            },
            child: Icon(Icons.print),
            tooltip: 'Imprimir o generar informe',
          ),
          SizedBox(height: 20),
          Text(
            'Comentarios:',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(comments[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  _loadData() async {
    var prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString("userId");
    final databaseReference = FirebaseDatabase.instance.ref("Users/$userId");
    DatabaseEvent event = await databaseReference.once();
    event.snapshot.value;
    name = "${event.snapshot.child("name").value} ${event.snapshot.child("lastname").value}";
    email = "${event.snapshot.child("email").value}";
    picture = "${event.snapshot.child("picture").value}";
    setState(() {});

    // Cargar los comentarios
    comments.clear();
    var commentsSnapshot = event.snapshot.child("comments");
    if (commentsSnapshot != null && commentsSnapshot.value != null) {
      Map<dynamic, dynamic> commentsMap =
      (commentsSnapshot.value as Map<dynamic, dynamic>);
      commentsMap.forEach((key, value) {
        comments.add(value["text"].toString());
      });
    }

    setState(() {});
  }

  Future<void> generateAndSavePDF() async {

    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Expanded(child: pw.Column(children: [
          pw.Table(
            border: pw.TableBorder.all(width: 1.0),
            children: [
              // Table header
              pw.TableRow(children: [
                pw.Center(child: pw.Text('Mis referencias', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 40)),)
              ],
              ),
            ],
          ),
          pw.Table(
            border: pw.TableBorder.all(width: 1.0),
            children: [
              pw.TableRow(children: [
                pw.Text(' Comentarios', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 35)),
              ],
              ),
              // Rows for each key-value pair
              for (int i = 0; i < comments.length; i++)
                pw.TableRow(children: [
                  pw.Text(comments[i].toString(), style: pw.TextStyle(fontSize: 30)),
                ]),
            ],
          )
        ]));
      },
    ));
    final output = await getExternalStorageDirectory(); // Get the external storage directory
    final file = File('${output?.path}/MisReferencias.pdf');  // Define the file path and name
    await file.writeAsBytes(await pdf.save());  // Save the PDF

    // Check if the file exists before attempting to open it
    if (await File(file.path).exists()) {
      await OpenFile.open(file.path);
    } else {
      print('File does not exist.');
    }
    print('PDF saved to: ${file.path}');
  }
  Future<void> _signOut(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }
}