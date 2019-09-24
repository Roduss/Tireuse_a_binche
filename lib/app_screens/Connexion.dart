import 'package:flutter/material.dart';
import '../main.dart';



class Connexion_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Connexion_screen();
  }

}

// ignore: camel_case_types
class Connexion_screen extends State<Connexion_Form> {
  final _formKey = GlobalKey<FormState>(); //Permet d'envoyer les données si elles sont valides.
  String username, password;
  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child : Container(
        alignment: Alignment.center,
  child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children:<Widget>[

            //=====================Textbox username et password======
            TextFormField(

              autofocus: true,
              decoration: InputDecoration(
                  labelText: 'Enter username'),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value){
                username=value;
              },

            ),


            TextFormField(
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'Enter password'
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onSaved: (value){
                password=value;
              },
            ),

/* ====================Bouton Submit==========*/

            Padding(
            padding : const EdgeInsets.symmetric(vertical:16.0),
            child :
            RaisedButton(onPressed: () {
              if (_formKey.currentState.validate()){
                Scaffold.of((context))
                    .showSnackBar(SnackBar(content: Text('ça process'))); //Comprendre le scaffold
                _formKey.currentState.save(); //Permet de sauvegarder les val des variables.
                //TODO : faire un if pseudo correct : tu me push sur la page de MenuBinche.
    }
            },
              child : Text('Submit'),

            ),
    )
          ]
            ),


      )
    );


  }


}