import 'dart:async';
import 'package:flutter/material.dart';
import '../main.dart';
import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import 'package:intl/intl.dart';




class Inscription_Form extends StatefulWidget {
  final Binche_user binche_user;
  final String appTitle;

  Inscription_Form(this.binche_user, this.appTitle);

  @override
  State<StatefulWidget> createState() {
    return Inscription_screen(this.binche_user, this.appTitle);
  }
}

class Inscription_screen extends State<Inscription_Form> {
  DatabaseHelper helper = DatabaseHelper();

  String appTitle;
  Binche_user binche_user;

  TextEditingController usrnamecontroller = TextEditingController();
  TextEditingController usrpoidscontroller = TextEditingController();

  Inscription_screen(this.binche_user, this.appTitle);

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    usrnamecontroller.text = binche_user.name;
    usrpoidscontroller.text = binche_user.poids.toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(appTitle),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              //To control the back button on top of screen
              moveToLastScreen();
            }),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: ListView(
          children: <Widget>[
            TextField(
              textCapitalization: TextCapitalization.words,
              controller: usrnamecontroller,
              autofocus: true,
              style: textStyle,
              onChanged: (value) {
                updateName(); //Permet d'envoyer à la bdd après
                debugPrint('Something changed in Title Text Field, le name :' + binche_user.name );
              },
              decoration: InputDecoration(
                  labelText: "Entre ton nom, chameau",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),

            SizedBox(height: 50),

            TextField(
              controller: usrpoidscontroller,
              style: textStyle,
              keyboardType: TextInputType.numberWithOptions(),
              onChanged: (value) {
                updatePoids(); //Permet d'envoyer à la bdd après
                debugPrint('Something changed in Title Text Field, le poids :');
              },
              decoration: InputDecoration(
                  labelText: "Entre ton poids, il restera confidentiel",
                  labelStyle: textStyle,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0))),
            ),


//Bouton send :
            Padding(
              padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
              child: RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  'Je suis un chamo lol',
                  textScaleFactor: 1.5,
                ),
                onPressed: () {
                  debugPrint("Saved Pressed");
                  setState(() {
                    _save();
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  //Update le username :
  void updateName() {
    binche_user.name = usrnamecontroller.text;
  }

  void updatePoids() {
    binche_user.poids = double.parse(usrpoidscontroller.text);
  }

  void _save() async {
    moveToLastScreen();

    int result;
    if (binche_user.id != null) {
      //On update si tu existe déja
      result = await helper.updateUser(binche_user);
      debugPrint("Tu es existant, update et ton id est : $binche_user.id");
    } else {
      //Sinon on insère ton nom dans la bdd
      result = await helper.insertUser(binche_user);
      debugPrint("Tu es nouveau, creation et ton id est $binche_user.id");
    }

    if (result != 0) {
      //Sucess
      _showAlertDialog('Status', 'Ton nom est sauvé, chamoo');
    } else {
      //Pas sucess
      _showAlertDialog('Status', 'Problem Saving you, chamo');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}

/* final _formKey = GlobalKey<FormState>();
    String username;
    Form(
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
                            '$username '))); //Juste pour etre serein sur la sauvegarde de variables.
                  }
                },
                child: Text('Créer le compte du nouveau chameau'),
              ),
            )
          ]),
*/
// child: Text('Creation'),
