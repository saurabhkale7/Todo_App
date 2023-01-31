import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:todo_app/state_management/techmodel_provider.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({Key? key}) : super(key: key);

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<TechModelProvider>(context, listen: false).getAllNews();
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Explore Tech"), backgroundColor: Colors.pink,),
      body: Consumer<TechModelProvider>(
        builder: (context1, value, child){
        if(value.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final techModels=value.techModels;
        
        return ListView.builder(
          itemCount: techModels.length,
          padding: EdgeInsets.all(10),
          itemBuilder: (context1, index){
            final ob=techModels[index];

            return ListTile(
              leading: CircleAvatar(
                child: Text((index+1).toString()),
              ),
              title: Text('${ob.title}', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
              subtitle: Text('${ob.content}', style: TextStyle(color: Colors.white),),
              tileColor: Colors.pinkAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(color: Colors.white),
              ),
            );
          },
        );
      }
      ),
    );
  }
}
