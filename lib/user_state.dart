import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaposlise/jobs/jobs_screen.dart';
import 'auth/login.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder
      (
      stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx,userSnapshot) {
          if(userSnapshot.data==null){
            print('User is not logged in yet');
            return Login();
          }
          else if(userSnapshot.hasData) {
            print('User is already logged in ');
            return JobsScreen();
          }
          else if(userSnapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text('An error has been occurred!'),
                ),
              );
          }
          if(userSnapshot.connectionState==ConnectionState.waiting) {
            return Scaffold(
                body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
          }
          return Scaffold(
            body: Center(
              child: Text('Something went wrong'),
            ),
          );
        }
    );
  }
}
