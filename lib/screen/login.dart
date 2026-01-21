import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:favorite_places/screen/favorite_places.dart";

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends State<Login> {
  var _formKey = GlobalKey<FormState>();
  late String _email;
  late String _password;

  void login() async {
    bool ok = false;
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        //login con firebase
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);

        ok = true;
      } on FirebaseAuthException catch (e) {
        print(e);
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }

      if (ok) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) {
              return FavoritePlaces();
            },
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(label: Text("email")),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Inserisci l'email";
                  }
                },
                onSaved: (newValue) {
                  _email = newValue!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(label: Text("password")),
                keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Inserisci la password";
                  }
                },
                onSaved: (newValue) {
                  _password = newValue!;
                },
              ),
              FilledButton.tonal(onPressed: login, child: Text("Login")),
            ],
          ),
        ),
      ),
    );
  }
}
