import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:todo_app/model/tech_model.dart';

class TechModelAPI{
  Future<List<TechModel>> getAll() async {
    const url="https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=fcfcbc293c904f43bb7a9fb43d31bdf4";
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final dict = jsonDecode(response.body) as Map<String, dynamic>;
      final li=dict["articles"] as List;
      for(int i=0;i<5;i++)
      {
        print(li[i]["title"]);
        print(li[i]["description"]);
      }
      List<TechModel> data = li!=null
                             ? li.map(
                                (dynamic i) => TechModel.jsonToObject(i as Map<String, dynamic>)
                              ).toList()
                             : <TechModel>[];

      return data;

      //  List<Todo> data = json != null
      //     ? json
      //     .map((dynamic i) => Todo.fromJson(i as Map<String, dynamic>))
      //     .toList()
      //     : <Todo>[];
      // ;
      // for(int i=0;i<5;i++)
      //   print("${data[i].id} - ${data[i].title}");
    }else
      print("ok hi");
    return [];
  }
}