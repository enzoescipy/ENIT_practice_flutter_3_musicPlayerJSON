import 'package:flutter/material.dart';
import 'Model/PlayList_MusicList_Model.dart';
import 'View/HomeView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Data().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
