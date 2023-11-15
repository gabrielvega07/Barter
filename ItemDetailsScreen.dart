
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemDetailsScreen extends StatelessWidget {
  var image; // This stores the index of the selected item.
  var comment;
  var usage;
  var value;
  var name;
  var phone;
  TextEditingController _commentController = TextEditingController();

  ItemDetailsScreen({required this.image, this.comment, this.usage, this.value, this.name, this.phone});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles'),
        backgroundColor: Color(0xff471f53),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            elevation: 30,
            child: Center(child: Padding(padding: const EdgeInsets.all(16.0),
              child: Image.network(
                image, // Use the selected item's image
                height: MediaQuery.of(context).size.height/3.5, // Adjust the height as needed
                width: MediaQuery.of(context).size.width/1.25, // Adjust the width as needed
                fit: BoxFit.cover,
              ),
            ),),
          ),
          Card(
            elevation: 30,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    '$name', // Replace with the actual item details
                    style: TextStyle(fontSize: 20.0,),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Uso: $usage',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(padding: EdgeInsets.all(16),
                  child:  Text(
                    'Valor: $value',
                    style: TextStyle(fontSize: 20.0),
                  ),
                ),
                Padding(padding: EdgeInsets.all(16),
                    child:  Text(
                      comment,
                      style: TextStyle(fontSize: 20.0),
                    )
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              _showCommentDialog(context);
            },
            child: Icon(Icons.comment),
            tooltip: 'Agregar Comentario',
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              canLaunchUrl(Uri.parse("whatsapp://")).then((value) =>
                  launchUrl(Uri.parse("whatsapp://send?phone=$phone"))
                      .catchError((error, stackTrace) {
                    Fluttertoast.showToast(
                      msg: "Aplicacion no disponible",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                    print("No hay aplicaciones disponibles");
                  }));
            },
            child: Image(image: AssetImage("assets/images/whatsapp.png"), height: 40,),
          ),
        ],
      ),

    );
  }

  // Función para mostrar el cuadro de diálogo de comentarios
  void _showCommentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Agregar Comentario"),
          content: TextFormField(
            controller: _commentController,
            decoration: InputDecoration(
              hintText: "Escribe tu comentario aquí",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el cuadro de diálogo
              },
              child: Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                // Guardar el comentario y cerrar el cuadro de diálogo
                _saveComment(_commentController.text);
                Navigator.of(context).pop();
              },
              child: Text("Guardar"),
            ),
          ],
        );
      },
    );
  }

  // Función para guardar el comentario
  void _saveComment(String newComment) {
    // Generar un nuevo ID único para el comentario
    String commentId = DateTime.now().millisecondsSinceEpoch.toString();

    // Crear un nuevo comentario en el formato deseado
    Map<String, dynamic> commentData = {
      "text": newComment,
    };

    // Guardar el comentario en la base de datos
    _updateCommentsInDatabase(commentId, commentData);
  }

  // Función para actualizar la base de datos con el nuevo comentario
  void _updateCommentsInDatabase(String commentId, Map<String, dynamic> commentData) {
    // Aquí debes implementar la lógica para actualizar la base de datos
    // Asumo que hay un método para obtener el ID del usuario, reemplázalo según tu estructura
    var userId = getUserId(); // Implementa tu lógica para obtener el ID del usuario

    final databaseReference = FirebaseDatabase.instance.ref("Users/$userId/comments/$commentId");
    databaseReference.set(commentData);
  }

  // Implementa tu lógica para obtener el ID del usuario según tu estructura
  String getUserId() {
    // Puedes obtener el ID del usuario desde SharedPreferences u otro método
    // Asegúrate de ajustar esto según tu implementación
    // Por ahora, devuelvo un valor fijo como ejemplo
    return "userId1";
  }
}