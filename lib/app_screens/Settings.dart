import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tireuse_a_binche/models/binche_user_data.dart';


import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';


import 'package:flutter/foundation.dart';
import 'dart:io';





class Settings_Form extends StatefulWidget {
  final Socket channel;

  Settings_Form({Key key, this.channel}) : super(key:key);

  @override
  Settings_Screen createState() => Settings_Screen();

  /*State<StatefulWidget> createState() {
    return Settings_Screen();
  }*/
}

class Settings_Screen extends State<Settings_Form>{
  DatabaseHelper helper = DatabaseHelper();
  
  TextEditingController tauxalc = TextEditingController();
  TextEditingController taillefut = TextEditingController();


  /*============================La fonction dispose s'éxécute quand on quitte l'écran, on en veut pas du coup !!!
  @override
  void dispose(){
    widget.channel.write("Nous allons fermer le channel ... \n");
    widget.channel.close();
    super.dispose();
  }*/
  
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    final appTitle = 'Paramétrage tireuse';
    
    
    
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
        body:Padding( 
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
          child: ListView(
            children: <Widget>[
              TextField(
                controller: tauxalc,
                style: textStyle,
                /*onChanged: (value){
                  _sendvalue(double.parse(tauxalc.text); // On convertit en double comme ça c'est le bon format normalement.
                },*/
                decoration: InputDecoration(
                    labelText: "Degré d'alcool du fut",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              
              SizedBox(height: 50),
              
              TextField(
                controller: taillefut,
                style: textStyle,
                /*onChanged: (value){
                  _sendvalue(double.parse(taillefut.text)); //
                },*/
                decoration: InputDecoration(
                    labelText: "Contenance du fut",
                    labelStyle: textStyle,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0))),
              ),
              
              RaisedButton(
                color: Theme.of(context).primaryColorDark,
                textColor: Theme.of(context).primaryColorLight,
                child: Text(
                  'Envoi',
                  textScaleFactor: 1.5,
                ),
                onPressed: _showDialog ,
                  /*setState(() {
                    _sendvalue(double.parse(tauxalc.text), double.parse(taillefut.text));
                  });*/

              ),
              /*StreamBuilder(
                stream: widget.channel,
                builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24.0),
                    child: Text(snapshot.hasData
                        ? '${String.fromCharCodes(snapshot.data)}'
                        : 'rien'),
                  );
                },
              )*/
            ],
          ),
        )

    );
  }


  void _sendvalue(){
    
    //TODO : Ajouter une vérif pour pas que les valeurs soient folles

     widget.channel.write("Apero\n");
    
  }

  Future <void>  _showDialog(){

    return showDialog<void>(
        context : context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Envoyer ?"),
            content: new Text("C'est les bonnes valeurs hein ? Sinon ça fout la merde"),
            actions: <Widget>[
              FlatButton(
                child : Text("Oui"),
                onPressed: (){
                  _sendvalue();
                  Navigator.of(context).pop();
                },

              ),
              FlatButton(
                child: Text("Non"),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        }
    );

  }



  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}