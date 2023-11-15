// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreen/HomeScreen.dart';
import 'Registro.dart';

class LoginScreen extends StatelessWidget {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        final prefs = await SharedPreferences.getInstance();
        final User? user = userCredential.user;
        prefs.setString("userId", user!.uid);
        _ToastMessage("Bienvenido", Colors.green);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => HomeScreen()),
        // );

    } catch (e) {
      // Handle login error
      print('Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    var horizontal = MediaQuery.of(context).size.width;
    var vertical = MediaQuery.of(context).size.height;
    return Scaffold(
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
          ),
          child: Center(
              child: Column(children: [
                Container(
                  padding: EdgeInsets.all(vertical/12),
                  child: Text(
                    'Barter',
                    textAlign: TextAlign.right,
                    style: TextStyle (
                      fontSize: vertical/24,
                      fontWeight: FontWeight.w500,
                      color: Color(0xfff9f3f3),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    child: TextField(
                      controller: _emailController,
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
                          labelText: 'User Name',
                          hintStyle: TextStyle(color: Colors.black),
                          hintText: 'Enter valid mail id as abc@gmail.com'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  //padding: EdgeInsets.symmetric(horizontal: 15),
                  child: TextField(
                    controller: _passwordController,
                    style: const TextStyle(color: Colors.black),
                    obscureText: true,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        floatingLabelStyle: const TextStyle(color: Colors.transparent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        labelText: 'Password',
                        hintStyle: const TextStyle(color: Colors.black),
                        hintText: 'Enter your secure password'),
                  ),
                ),
                Container(
                  height: 50,
                  width: 250,
                  decoration: BoxDecoration(
                      color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                  child: TextButton(
                    onPressed: () async {
                      if(_emailController.text != "" && _passwordController.text != ""){
                        // _signInWithEmailAndPassword();
                        _login(context);
                      } else{
                        if(_emailController.text == ""){
                          _ToastMessage("e-mail vacio", Colors.red);
                        }else{
                          _ToastMessage("Contraseña vacia", Colors.red);
                        }
                      }
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(color: Colors.white, fontSize: 25),
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationScreen()),
                    );
                  },
                  child: Text('Registrarse'),
                ),
              ],)),
        ),
      ),
    );
  }

  _ToastMessage(String msg, Color toastColor){
    return Fluttertoast.showToast(
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
