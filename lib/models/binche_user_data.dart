
import 'package:flutter/cupertino.dart';

class Binche_user{

  int _id;
  String _name;
  int _qtebinche;
  double _poids;
  double _degalc;


  //Constructor
  Binche_user(this._name,this._qtebinche, this._poids);

  Binche_user.withId(this._id,this._name,this._qtebinche); //Au cas ou on veuille rentrer l'id.

  //Getters

  int get id => _id;

  String get name => _name;

  int get qtebinche => _qtebinche;

  double get poids => _poids;

  double get degalc => _degalc;

  //Setters - Pour pouvoir changer la valeur des val de la database

  set  name(String newName){
    if(newName.length<=255){ //A voir si on met d'autres conditions
      this._name=newName;
      debugPrint("On a setté un nouvo nom");
    }
  }

  set qtebinche(int newqte){
    this._qtebinche=newqte;
  }

  set poids(double newpoids){
    this._poids=newpoids;
  }

  set degalc(double newdegalc){
    this._degalc=newdegalc;
  }

  ///On convert notre objet en map pour sqflite :
///

  Map<String, dynamic> toMap(){

    var map= Map<String, dynamic>();

    if(id!=null) { //On envoie l'id que quand il est pas null.
      map['id'] = _id;
    }
    map['name'] = _name;
    map['qtebinche']=_qtebinche;
    map['poids'] = _poids;
    map['degalc'] = _degalc;

    return map;
  }


  ///On récupère des datas de la database
///


Binche_user.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._qtebinche = map['qtebinche'];
    this._poids = map['poids'];
    this._degalc = map['degalc'];
}

}