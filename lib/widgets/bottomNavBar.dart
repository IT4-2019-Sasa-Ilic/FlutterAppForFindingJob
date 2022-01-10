import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaposlise/jobs/jobs_screen.dart';
import 'package:zaposlise/jobs/upload_job.dart';
import 'package:zaposlise/search/profile_company.dart';
import 'package:zaposlise/search/search_companies.dart';
import 'package:zaposlise/user_state.dart';

class BottomNavigationBarForApp extends StatelessWidget {

  int i=0;
  BottomNavigationBarForApp({
    required this.i
});

  void _logout (context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Row(
              children: [
                Padding(
                  padding:const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color:Colors.white70,
                    size: 36,
                  ),
                ),
                Padding(
                  padding:const EdgeInsets.all(8.0),
                  child: const Text(
                    'Sign out',
                    style: TextStyle(color: Colors.grey,fontSize: 28),
                  ),
                ),
              ],
            ),
            content: Text(
              'Do you want to logout from app?',
              style: TextStyle(color: Colors.grey,fontSize: 20),
            ),
            actions: [
              TextButton(
                  onPressed:(){
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: Text('No',style: TextStyle(color: Colors.green,fontSize: 18),)
              ),
              TextButton(
                  onPressed: (){
                    _auth.signOut();
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserState()));

                  },
                  child: Text('Yes',style: TextStyle(color: Colors.red,fontSize: 18),)
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        color: Colors.white,
        backgroundColor: Colors.black,
        buttonBackgroundColor: Colors.white,
        height: 52,
        index: i,
        items: <Widget>[
          Icon(Icons.list,size: 18,color: Colors.blue,),
          Icon(Icons.search,size: 18,color: Colors.blue,),
          Icon(Icons.add,size: 18,color: Colors.blue,),
          Icon(Icons.person_pin,size: 18,color: Colors.blue,),
          Icon(Icons.exit_to_app,size: 18,color: Colors.blue,),

        ],
      animationDuration: Duration(
        milliseconds: 300,
      ),
      animationCurve: Curves.bounceInOut,
      onTap: (index){
          if(index==0) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobsScreen()));
          }
          else if(index==1) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AllWorkersScreen()));

          }
          else if(index==2) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UploadJob()));

          }
          else if(index==3){
            final FirebaseAuth _auth = FirebaseAuth.instance;
            final User? user = _auth.currentUser;
            final String uid=user!.uid;
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(
              userID: uid,
            )));
          }
          else if (index==4) {

            _logout(context);
          }
      },
    );
  }
}
