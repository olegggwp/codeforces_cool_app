import 'package:flutter/material.dart';
import 'package:go_hard/madrawer.dart';
import 'package:go_hard/problemsLists.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return WeekList();
  }

}