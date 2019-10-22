import 'dart:async' as prefix0;

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/binche_user_data.dart';

class DatabaseHelper{

  static DatabaseHelper _databaseHelper; //Singleton, il sera défini qu'une seule fois!
  static Database _database; //Singleton défini qu'une fois aussi

  String userDataTable = 'user_data_table'; //to link with binche_user_data.dart
  String colId = 'id';
  String colname = 'name';
  String colqtebinche = 'qtebinche';
  String colpoids = 'poids';
  String coldegalc = 'degalc';

  DatabaseHelper._createInstance();


  factory DatabaseHelper(){
    if(_databaseHelper == null){
      _databaseHelper=DatabaseHelper._createInstance(); //Exécuté qu'une seule fois du coup !
    }
    return _databaseHelper;
  }


  ///Getter de la db !!: permet de la créer, sinon ça la récupère juste !!

  Future<Database> get database async { ///Fonction finale, qui appelle initialize puis create db.

    if(_database == null){ //Car on ne la définira qu'une fois notre database, après on la return simplement.
      _database = await initializeDatabase();
    }
    return _database;
  }


  Future<Database> initializeDatabase() async {
    //On choppe le directory pour ios et Android

    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'binche_user_data.db';

    //Ouvre/crée la db

    var userDatabase = await openDatabase(path, version: 1, onCreate: _createDb); //Ouvre la db et la store dans la var.
    return userDatabase; //Return la database.
  }



  void _createDb(Database db, int newVersion) async{

    await db.execute('CREATE TABLE $userDataTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colname TEXT,'
      '$colqtebinche INTEGER,$colpoids DOUBLE, $coldegalc DOUBLE )');
  }


  //Fetch : Get all users from database
//Avec ça on récupère les datas en ordre ASC par nom, il faut ensuite convertir.
Future<List<Map<String, dynamic>>> getUserMapList() async { //Il faudra ensuite convertir en list of user a la place du type 'map'
    Database db = await this.database;
    
    var result = await db.query(userDataTable, orderBy: '$colname ASC' ); //On trie par ordre alphabétique les users.
    return result;
}

  Future<List<Map<String, dynamic>>> orderUserbyqtebinche() async { //Il faudra ensuite convertir en list of user a la place du type 'map'
    Database db = await this.database;

    var result = await db.query(userDataTable, orderBy: '$colqtebinche DESC' );
    return result;
  }

  Future<List<Map<String, dynamic>>> orderUserbydegalc() async { //Il faudra ensuite convertir en list of user a la place du type 'map'
    Database db = await this.database;

    var result = await db.query(userDataTable, orderBy: '$coldegalc DESC' );
    return result;
  }

  //Insert : Insere un user dans database

  Future<int> insertUser (Binche_user binche_user) async {
    Database db = await this.database;
    var result = await db.insert(userDataTable, binche_user.toMap()); //ON CONVERTIT EN Map pour envoyer a la DB !
    return result;
  }

  //Update and save

  Future<int> updateUser (Binche_user binche_user) async { //Sauvegarde le user dans la DB.
    Database db = await this.database;
    var result = await db.update(userDataTable, binche_user.toMap(), where :'$colId = ?', whereArgs: [binche_user.id]);
    //Le ? permet de prendre un arg, celui de binche_user.id du coup.
    //CAD qu'on trouve le $user et qu'on l'update.
    return result;
  }

  //Delete le user dans la DB

  Future<int> deleteUser(int id) async { //Lui a un int dans sa fct, nous un string, mais je pense ça tourne aussi.
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $userDataTable WHERE $colId = $id');
    return result;
}

  //Get number of users in database.

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x= await db.rawQuery('SELECT COUNT (*) from $userDataTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }


  //Get the map list and convert it to user list! --> A partir de l'operation de fetch

  Future<List<Binche_user>> getUserList() async {

    var userMapList = await getUserMapList(); //On récupère de la bdd la map list
    int count = userMapList.length; //On compte le nb d'user

    List<Binche_user> userList = List<Binche_user>(); //empty list of user

    for(int i=0;i< count; i++){

      userList.add(Binche_user.fromMapObject(userMapList[i]));//On rempli la userlist qui est empty, en convertissant.
    }

    return userList; //On la return propre, sous forme visuelle du coup, pas besoin de convertir
  }

  Future<List<Binche_user>> getqteUserList() async {

    var userqteMapList = await orderUserbyqtebinche(); //On récupère de la bdd la map list
    int count = userqteMapList.length; //On prend le nb d'user

    List<Binche_user> userList = List<Binche_user>();

    for(int i=0;i< count; i++){

      userList.add(Binche_user.fromMapObject(userqteMapList[i])); //On peut gader usermapList, on change un peu.
    }

    return userList;
  }

  Future<List<Binche_user>> getdegalcUserList() async {

    var useralcMapList = await orderUserbydegalc(); //On récupère de la bdd la map list
    int count = useralcMapList.length; //On prend le nb d'user

    List<Binche_user> userList = List<Binche_user>();

    for(int i=0;i< count; i++){

      userList.add(Binche_user.fromMapObject(useralcMapList[i]));
    }

    return userList;
  }


}

