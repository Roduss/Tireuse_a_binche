import 'dart:async';

import 'package:flutter/widgets.dart';
import './app_screens/Connexion.dart';

///Check pour que ça fonctionne
///
/// https://medium.com/flutter-community/share-streams-with-inheritedwidget-e26c5364578b

class GlobalValues extends InheritedWidget {

  StreamController controller;
  //Stream stream;

  int counter = 0;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  GlobalValues({Key key, Widget child}) : super(key: key, child: child);

  static GlobalValues of(BuildContext context){
    return context.inheritFromWidgetOfExactType(GlobalValues) as GlobalValues;
  }

  initStream(){
    /*
    controller = StreamController.broadcast();
    stream = testbloc.getPeriodicStream();
    controller.addStream(stream);
    print("Stream initiliazied");
    */
  }
}