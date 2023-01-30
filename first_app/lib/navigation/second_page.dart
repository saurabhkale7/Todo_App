import 'package:flutter/cupertino.dart';

class SecondPage extends StatefulWidget {
  final String title;
  final String desc;
  const SecondPage({Key? key, required this.title,required this.desc}) : super(key: key);

  @override
  StateSecondPage createState() => StateSecondPage(title:title, desc:desc);
}

class StateSecondPage extends State<SecondPage> {
  final String title;
  final String desc;
  StateSecondPage({Key? key, required this.title,required this.desc}):super();

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
