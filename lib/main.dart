import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:zaposlise/user_state.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  final Future<FirebaseApp> _initilization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initilization,
      builder: (context,snapshot) {

        if(snapshot.connectionState==ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('Please wait'),
                ),
              ),
            ),
          );
        }else if(snapshot.hasError){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Center(
                  child: Text('An error has been occurred!'),
                ),
              ),
            ),
          );
        }
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'ZaposliSe',
          theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            primarySwatch: Colors.blue,
          ),
          home: UserState(),
        );
      }
    );
  }
}

