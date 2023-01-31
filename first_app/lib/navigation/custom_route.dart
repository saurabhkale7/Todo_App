import 'package:flutter/material.dart';
import 'package:todo_app/main.dart';
import 'package:todo_app/navigation/constants.dart';
import 'package:todo_app/newspage.dart';

class CustomRoute {
  static Route<dynamic> generateRoute(RouteSettings settings){
    switch(settings.name){
      case Constants.home:
        return MaterialPageRoute(builder: (_)=> MyHomePage());
      case Constants.nextPage:
        return MaterialPageRoute(builder: (_)=> const NewsPage());
      default:
        return MaterialPageRoute(
            builder: (_)=> Scaffold(
              appBar: AppBar(title: const Text("ERROR"),),
              body: Text("Error"),
            ),
        );
    }
  }
}