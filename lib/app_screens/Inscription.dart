import 'package:flutter/material.dart';
import './main.dart';

class Inscription_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Inscription_screen();
  }
}

class Inscription_screen extends State<Inscription_Form> {
  final _formKey = GlobalKey<FormState>();
  String username, password;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //====Textbox username et profil==========
            TextFormField(
              autofocus: true,
              decoration: InputDecoration(labelText: 'Enter username'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }

                return null;
              },
              onSaved: (value) {
                username = value;
              },
            ),

            TextFormField(
              decoration: InputDecoration(labelText: 'Enter password'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value) {
                password = value;
              },
            ),

            //===============Bouton submit=======

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of((context)).showSnackBar(SnackBar(
                        content: Text('ça process'))); //Comprendre le scaffold
                    _formKey.currentState.save();
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            '$username and $password'))); //Juste pour etre serein sur la sauvegarde de variables.
                  }
                },
                child: Text('Créer le compte du nouveau chameau'),
              ),
            )
          ]),

      // child: Text('Creation'),
    );
  }
}
