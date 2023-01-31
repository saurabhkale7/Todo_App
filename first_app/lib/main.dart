import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/navigation/constants.dart';
import 'dart:async';
import 'dart:core';

import 'package:todo_app/navigation/custom_route.dart';
import 'package:todo_app/state_management/techmodel_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>TechModelProvider(),
      child: MaterialApp(
        //home: MyHomePage(),
        debugShowCheckedModeBanner: false,
        initialRoute: Constants.home,
        onGenerateRoute: CustomRoute.generateRoute,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 5),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => NotesApp())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: Image.asset(
        "assets/images/app_icon.png",
        height: 400,
        width: 400,
        alignment: Alignment.center,
      ),
      //child:FlutterLogo(size:MediaQuery.of(context).size.height)
    );
  }
}

class NotesApp extends StatefulWidget {
  @override
  _NotesAppState createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  late TextEditingController titleCtrl, descCtrl;

  //Map m=new Map<String,String>();
  var l1 = ['hi','ok'];
  var l2 = ['hello','bye'];
  var flags=[false,false];
  int i = -1;

  ValueNotifier<int> hoverNotify = ValueNotifier(-1);

  @override
  void initState() {
    super.initState();

    titleCtrl = TextEditingController();
    descCtrl = TextEditingController();

    titleCtrl.text = "";
    descCtrl.text = "";
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();

    super.dispose();
  }

  Future openDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Create a new todo"),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              autofocus: true,
              controller: titleCtrl =
                  TextEditingController(text: i == -1 ? '' : l1[i]),
              decoration: InputDecoration(
                  hintText: i == -1 ? 'Enter the title' : '',
                  labelText: 'Title'),
            ),
            TextFormField(
              controller: descCtrl =
                  TextEditingController(text: i == -1 ? '' : l2[i]),
              decoration: InputDecoration(
                  hintText: i == -1 ? 'Enter the description' : '',
                  labelText: 'Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('SUBMIT'),
            onPressed: () {
              submit();
            },
          ),
        ],
      ),
    );
  }

  void submit() {
    var li = [];

    // Map m = new Map<String?,String?>();
    // m['title']=titleCtrl.text;
    // m['desc']=descCtrl.text;

    if (i == -1 && titleCtrl.text == "" && descCtrl.text == "") {
    } else {
      li.add(titleCtrl.text);
      li.add(descCtrl.text);
    }

    Navigator.of(context).pop(li);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My First Todo App",
          style: TextStyle(
              fontFamily: 'Poppins', fontSize: 22, color: Colors.yellow
          ),
        ),
        backgroundColor: Colors.pink,
        actions: [
          TextButton(onPressed: ()=>Navigator.of(context).pushNamed(Constants.nextPage), child: const Text("Explore Tech", style: TextStyle(color: Colors.white),), style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.pinkAccent)),),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: l1.length,
        itemBuilder: (context, index) {
          if(flags.length<(index+1)) {
            flags.add(false);
          }
          print(flags);
          return Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
              child: ValueListenableBuilder(
                valueListenable: hoverNotify,
                builder: (context,value,child){
                  return InkWell(
                    child: ListTile(
                      title: Text(
                        l1[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        l2[index],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      leading: GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          i = index;
                          var li = await openDialog();
                          if (li != null) {
                            setState(() {
                              l1[i] = li[0];
                              l2[i] = li[1];
                            });
                          }
                          titleCtrl.text = "";
                          descCtrl.text = "";
                        },
                      ),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            l1.removeAt(index);
                            l2.removeAt(index);
                            flags.removeAt(index);
                          });
                        },
                      ),
                      tileColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black),
                      ),
                      contentPadding: EdgeInsets.only(top: 20, bottom: flags[index]==true?40:20, left: 20, right: 20),
                      //visualDensity: VisualDensity(vertical: value==index?4:0,),
                    ),
                    onTap: (){
                      if(flags[index]==false) {
                        flags[index]=true;
                        hoverNotify.value = index;
                      }
                      else{
                        flags[index]=false;
                        hoverNotify.value = -1;
                      }
                      log(hoverNotify.value.toString());
                    },
                    // onFocusChange: (isFocused){
                    //   hoverNotify.value = isFocused==true?index:-1;
                    //   log(hoverNotify.value.toString());
                    // },
                  );
                },
              ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Increment',
        child: const Icon(Icons.add),
        backgroundColor: Colors.pink,
        onPressed: () async {
          i = -1;
          var li = await openDialog();
          print(li);

          if (li == null || (titleCtrl.text == "" && descCtrl.text == "")) {
          } else {
            //setState(()=>this.m[m1['title']]=m1['desc']);
            setState(() {
              l1.add(li[0]);
              l2.add(li[1]);
            });
          }
          titleCtrl.text = "";
          descCtrl.text = "";
        },
      ),
    );
  }
}

/*

body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: l1.length,
        itemBuilder: (context, index) {
          return Padding(
              padding: const EdgeInsets.only(top: 2.0, bottom: 2.0),
              child: ValueListenableBuilder(
                valueListenable: hoverNotify,
                builder: (context,value,child){
                  return MouseRegion(
                    child: ListTile(
                      title: Text(
                        l1[index],
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        l2[index],
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      leading: GestureDetector(
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onTap: () async {
                          i = index;
                          var li = await openDialog();
                          if (li != null) {
                            setState(() {
                              l1[i] = li[0];
                              l2[i] = li[1];
                            });
                          }
                          titleCtrl.text = "";
                          descCtrl.text = "";
                        },
                      ),
                      trailing: GestureDetector(
                        child: Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        onTap: () {
                          setState(() {
                            l1.removeAt(index);
                            l2.removeAt(index);
                          });
                        },
                      ),
                      tileColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(color: Colors.black),
                      ),
                      //contentPadding: EdgeInsets.only(top: value==index?40:20, bottom: value==index?40:20, left: 20, right: 20),
                      visualDensity: VisualDensity(vertical: value==index?4:0,),
                      onTap: (){

                      },
                    ),
                    onEnter: (PointerEnterEvent p){
                      hoverNotify.value=index;
                      print(hoverNotify.value);
                    },
                    onExit: (PointerExitEvent p){
                      hoverNotify.value=index;
                      print(hoverNotify.value);
                    },
                  );
                },
              ),
          );
        },
      ),

 body:ListView.separated(
        itemBuilder: (context, position) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                l2[position],
              ),
            ),
          );
        },
        separatorBuilder: (context, position) {
          return Card(
            color: Colors.grey,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                l1[position],
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        itemCount: l1.length,
      ),
* */

// class TodoApp extends StatelessWidget{

// import 'package:flutter/material.dart';

//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         // This is the theme of your application.
//         //
//         // Try running your application with "flutter run". You'll see the
//         // application has a blue toolbar. Then, without quitting the app, try
//         // changing the primarySwatch below to Colors.green and then invoke
//         // "hot reload" (press "r" in the console where you ran "flutter run",
//         // or simply save your changes to "hot reload" in a Flutter IDE).
//         // Notice that the counter didn't reset back to zero; the application
//         // is not restarted.
//         primarySwatch: Colors.yellow,
//       ),
//       home: const MyHomePage(title: 'Flutter Demo My Page'),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//
//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.
//
//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".
//
//   final String title;
//
//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//
//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//       appBar: AppBar(
//         // Here we take the value from the MyHomePage object that was created by
//         // the App.build method, and use it to set our appbar title.
//         title: Text(widget.title),
//       ),
//       body: Center(
//         // Center is a layout widget. It takes a single child and positions it
//         // in the middle of the parent.
//         child: Column(
//           // Column is also a layout widget. It takes a list of children and
//           // arranges them vertically. By default, it sizes itself to fit its
//           // children horizontally, and tries to be as tall as its parent.
//           //
//           // Invoke "debug painting" (press "p" in the console, choose the
//           // "Toggle Debug Paint" action from the Flutter Inspector in Android
//           // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//           // to see the wireframe for each widget.
//           //
//           // Column has various properties to control how it sizes itself and
//           // how it positions its children. Here we use mainAxisAlignment to
//           // center the children vertically; the main axis here is the vertical
//           // axis because Columns are vertical (the cross axis would be
//           // horizontal).
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text(
//               'You have pushed the button this many times:',
//             ),
//             Text(
//               '$_counter',
//               style: Theme.of(context).textTheme.headline4,
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: _incrementCounter,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }
//   void f1()
//   {
//     print("Hello");
//   }
//
//   @override
//   Widget build(BuildContext context){
//
//     return MaterialApp(
//
//       home: Scaffold(
//
//         appBar: AppBar(
//           title: Text("My First Todo App", style: TextStyle(fontFamily: 'Poppins', fontSize: 22, color: Colors.yellow),),
//         ),
//
//         body: Container(
//           height: double.infinity,
//           width: 400,
//           margin: EdgeInsets.all(20),
//           padding: EdgeInsets.all(10),
//           color: Colors.deepPurple,
//           child: Text('Tasks to be done by today EOD! \n\n-> 1. Create first flutter app \n-> 2. Revise git and github concepts \n-> 3. Attend SQL session \n-> 4. Revise excel concepts \n-> 5. Play table tennis for 15 minutes',style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'JetBrainsMono'),),
//         ),
//
//         // body: Row(
//         //     mainAxisAlignment: MainAxisAlignment.center,
//         //     children:[
//         //       Text("Tasks to be done by today EOD",style: TextStyle(color: Colors.black,),),
//         //     ]
//         // ),
//
//         floatingActionButton: FloatingActionButton(
//         onPressed: f1,
//         tooltip: 'Increment',
//         child: const Icon(Icons.add),
//         ), // This trailing comma makes auto-formatting nicer for build methods.
//
//
//
//
//
//       ),
//
//     );
//
//   }
// }
//
