import 'package:app_scoop/ui/homepage/homepage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'global_bloc.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalBloc globalBloc;
  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: MaterialApp(
        theme: ThemeData.light().copyWith(primaryColor: Colors.white),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
