import 'package:flutter/material.dart';
import 'package:todo_app/api/techmodel_api.dart';

import '../model/tech_model.dart';

class TechModelProvider extends ChangeNotifier{
  final service=TechModelAPI();
  bool isLoading=false;
  List<TechModel> techModels=[];

  Future<void> getAllNews() async{
    isLoading=true;
    notifyListeners();

    techModels=await service.getAll();

    isLoading=false;
    notifyListeners();
  }
}