import 'dart:async';
import 'package:flutter/material.dart';

import 'package:tireuse_a_binche/app_screens/Inscription.dart';
import 'package:tireuse_a_binche/app_screens/Menu_binche.dart';
import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import '../main.dart';
import 'package:sqflite/sqflite.dart';
import './Settings.dart';

import 'package:flutter/foundation.dart';
import 'dart:io';


///Ici on liste les joueurs déja inscrits.
///On met aussi un bouton pour ajouter un joueur
///
///

class Connexion_Form extends StatefulWidget {

  final Socket channel;
  Connexion_Form({Key key,this.channel}) : super(key: key);
//Constructeur pour le channel

  @override
  State<StatefulWidget> createState() {
    return Connexion_screen();
  }
}

class Connexion_screen extends State<Connexion_Form> {
  String appTitle = 'Connexion de chameau';

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Binche_user> userList;
  int count = 0;


  final _scaffoldKey = GlobalKey<ScaffoldState>();


  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<Binche_user>();
      updateListView();//Permet de récupérer la db dans l'ordre choisi !
    }
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(appTitle),
        actions : <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => Settings_Form(channel: widget.channel)), //Fonctionne, permet de passer la socket sur d'autres écrans !!!
              );
            },
          )
        ]

      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          naviguateToDetail(Binche_user('', 0, 0), 'Allez, rejoins nous mon chameau'); //On crée un user sans nom avec 0 binches bues.
        }, //Poids par défaut : 0 kg.
        tooltip: 'Nouveau ? Rejoins nous !',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(

      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(

          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              this.userList[position].name,
              style: titleStyle,
            ),

            leading: Icon(Icons.accessibility),
            trailing: GestureDetector(
              child: Icon(Icons.delete_forever),
              onTap: (){
                _showDialog(position);

              },
            ),
            onTap: () {
              widget.channel.write("Apero\n");
              //widget.channel.write("${userList[position].name}\n");

              naviguateToMenu(this.userList[position], 'Welcome back ${userList[position].name}');


            },
            onLongPress: () {

              naviguateToDetail(this.userList[position], 'change de nom petit chameau'); //On chope la position cliquée.
              //Permettre d'éditer, changer le nom en haut de l'app quoi.
            },
          ),
        );
      },
    );
  }




  void _delete(BuildContext context, Binche_user user) async {
    int result = await databaseHelper.deleteUser(user.id);

    debugPrint('Voici ton id : $user.id');
    if (result != 0) {
      //_scaffoldKey.currentState.showSnackBar(snackBar);
      showSnackBar(context,"Adieu chameau");
      updateListView(); ///A t'on besoin de cette ligne ?
    }
    else {
      //_scaffoldKey.currentState.showSnackBar(snackBar1);
      showSnackBar(context,"Problème de suppression");
    }
  }

  void naviguateToDetail(Binche_user user, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) { //Il reçoit le true to movetolastscreen().
      return Inscription_Form(user, title);
    }));

    if(result == true){
      updateListView();
      debugPrint("On update la listview en revenant de l'inscription");
    }

  }


  //Function to naviguate to menu binche, quand t'es connecté.

  void naviguateToMenu(Binche_user user, String title) async {
    bool result = await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return Menu_binche_Form(user, title, channel: widget.channel);
    }));
    if(result == true){
      updateListView();
      debugPrint("On update la listview en revenant du menu");
    }

  }

  void showSnackBar(BuildContext context, String message) {
    var snackBar = SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: "UNDO",
        onPressed: () {
          //Remettre l'user dans le game, a voir si on garde. Ou si on supprimer vraiment comme ça.
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase(); //On ouvre la db
    dbFuture.then((database){

      Future<List<Binche_user>> userListFuture = databaseHelper.getUserList(); //On rechoppe la liste des users
      userListFuture.then((userList){
        setState(() {
          this.userList = userList; //On envoie la nouvelle userList a la db !
          this.count = userList.length; //et sa nouvelle longueur
        });
      });
    });
  }

 Future <void> _showDialog(int position){ //Probleme de context, à voir, garder le <Future> je pense
    //Mais du coup avec le Scaffold il y a un truc qui foire, essaie de chercher l'erreur sur google, ça devrait faire ;)

    return showDialog<void>(
        context : context,
        builder: (BuildContext context){
          return AlertDialog(
            title: new Text("Aperoooooo"),
            content: new Text("Tu vas supprimer un chamo, t'es sur(e) ?"),
            actions: <Widget>[
              FlatButton(
                child : Text("Oui"),
                onPressed: (){
                  _delete(context, userList[position]); ///Check qu'il faille pas update la list après.
                  debugPrint("Tu dois etre deleté, nom user : ${userList[position]}, position : $position");
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

  //Méthode utilisée pour les sockets et le serveur
  /*@override
  void dispose(){
    widget.channel.close();
    super.dispose();
  }*/

}

// ignore: camel_case_types

/*====================Bouton Nouveau User==========

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


}*/
