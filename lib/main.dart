import 'package:flutter/material.dart';
import 'screens/landing_page.dart';
import 'screens/destination_detail_page.dart';
import 'services/auth_service.dart';
import 'theme.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tourist Guide',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      home: LandingPage(),
    );
  }
}