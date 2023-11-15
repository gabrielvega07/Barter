import 'package:barter/Screens/Login/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegistrationScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dpiController = TextEditingController();

  Future<void> _register(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        final User? user = userCredential.user;

        // Guardar datos adicionales en la base de datos
        _saveUserData(user!.uid);

        _ToastMessage("Usuario registrado exitosamente", Colors.green);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } catch (e) {
      // Manejar cualquier error que ocurra durante el registro
      print('Registro fallido: $e');
      _ToastMessage("Identificacion ya peretenece a una cuenta", Colors.red);
    }
  }

  // Función para guardar los datos del usuario en la base de datos
  void _saveUserData(String userId) {
    try {
      // Crear una referencia a la ubicación del usuario en la base de datos
      final databaseReference = FirebaseDatabase.instance.ref("Users/$userId");

      // Crear un mapa con los datos del usuario
      Map<String, dynamic> userData = {
        "name": _nameController.text,
        "lastname": _lastNameController.text,
        "dpi": int.parse(_dpiController.text),
        "email": _emailController.text,
      };

      // Guardar los datos en la base de datos
      databaseReference.set(userData);
    } catch (e) {
      // Manejar cualquier error que ocurra al guardar los datos del usuario
      print("Error al guardar datos del usuario: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registro'),
        backgroundColor: Color(0xff140f26),
      ),
      body: Container(
        // loginbarterv82 (1:195)
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: const BoxDecoration (
            color: Color(0xff140f26),
            gradient: LinearGradient (
              begin: Alignment(-2.006, -0.038),
              end: Alignment(-0.082, 1.975),
              colors: <Color>[Color(0xff191b53), Color(0xff471f53)],
              stops: <double>[0, 1],
            ),
          ),child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  filled: true, // Establecer como true para llenar el fondo
                  fillColor: Colors.white, // Color de fondo blanco
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Apellido',
                  filled: true, // Establecer como true para llenar el fondo
                  fillColor: Colors.white, // Color de fondo blanco
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _dpiController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'DPI',
                  filled: true, // Establecer como true para llenar el fondo
                  fillColor: Colors.white, // Color de fondo blanco
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Correo electrónico',
                  filled: true, // Establecer como true para llenar el fondo
                  fillColor: Colors.white, // Color de fondo blanco
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true, // Establecer como true para llenar el fondo
                  fillColor: Colors.white, // Color de fondo blanco
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 24.0),
              Center(
                child:
                Wrap(
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        if (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            _dpiController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty) {
                          _register(context);
                        } else {
                          _ToastMessage("Por favor, completa todos los campos", Colors.red);
                        }
                      },
                      child: Text('Registrar'),
                    ),
                  ],
                )
              )
            ],
          ),
        ),
        ),
      ),
    );
  }


  // Función para mostrar mensajes de tostadas
  void _ToastMessage(String msg, Color toastColor) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: toastColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
