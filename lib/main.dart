import 'package:authentications/screens/authentication%20page.dart';
import 'package:authentications/screens/success_page.dart';
import 'package:authentications/screens/upload_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

  Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const UploadFiles(),
    );
  }
}



