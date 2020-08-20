import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tireuse_a_binche/models/binche_user_data.dart';


import '../models/binche_user_data.dart';
import '../utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Classement_bourre_Form extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return Classement_bourre_Screen();
  }
}

///TODO : pour la date, regarder le 4.8 à 14min30 de smartherd
///
///
class Classement_bourre_Screen extends State<Classement_bourre_Form> {
  final appTitle = 'Regroupement des alcoolos du coins';
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Binche_user> userList;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (userList == null) {
      userList = List<Binche_user>();
      updateListView();
    }
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
      body: getListView(),
    );
  }

  ListView getListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subtitle1;

    return ListView.builder(
      itemCount: count, //Récupère le nb d'users

      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            title: Text(
              this.userList[position].name,
              style: titleStyle,
            ),
            subtitle: Text(this.userList[position].degalc.toStringAsFixed(2) +
                " g.L dans le sang"), //Affichage deg alcool
            leading: Icon(Icons.accessibility_new),
          ),
        );
      },
    );
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper
        .initializeDatabase(); //On ouvre la db -----//Première fonction équivalente au getdatabase.
    dbFuture.then((database) {
      Future<List<Binche_user>> userListFuture = databaseHelper
          .getdegalcUserList(); //On rechoppe la liste des users - QUANTITE ICI!!!!
      userListFuture.then((userList) {
        setState(() {
          this.userList = userList; //On envoie la nouvelle userList a la db !
          this.count = userList.length; //et sa nouvelle longueur
        });
      });
    });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
