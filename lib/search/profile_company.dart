import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:zaposlise/auth/edit_profile.dart';
import 'package:zaposlise/widgets/bottomNavBar.dart';

import '../user_state.dart';
class ProfileScreen extends StatefulWidget {
  final String userID;

  const ProfileScreen({
    required this.userID
});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading=false;
  String phoneNumber ="";
  String email ="";
  String? name;
  String? imageUrl ="";
  String joinedAt = "";
  String location ="";
  bool _isSameUser = false;

  void getUserData() async {
    try {
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

        setState(() {
          email = userDoc.get('email');
          name = userDoc.get('name');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          location = userDoc.get('location');


          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.year}-${joinedDate.month}-${joinedDate.day}';
        });

        final _uid =FirebaseAuth.instance.currentUser!.uid;
        setState(() {
          _isSameUser = _uid == widget.userID;
        });

    } catch(error) {

    } finally{
      _isLoading=false;
    }
  }

@override
  void initState() {
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(i:3),
      body: Center(
        child: _isLoading ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top:0),
                child: Stack(
                  children: [
                    Card(
                      color: Colors.white10,
                      margin: EdgeInsets.all(30),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height:137 ,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                name==null? 'Name here' : name!,
                                style: TextStyle(color: Colors.white,fontSize: 22),
                              ),
                            ),
                            SizedBox(
                              height:15 ,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.limeAccent,
                            ),
                            SizedBox(
                              height:30 ,
                            ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Account information:',
                            style: TextStyle(color: Colors.grey,fontSize: 22),
                          ),
                        ),
                            SizedBox(
                              height:20 ,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: userInfo(
                                icon:Icons.email,
                                content: email,
                              ),
                            ),
                            SizedBox(
                              height:10 ,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:10.0),
                              child: userInfo(
                                icon:Icons.phone_android,
                                content: phoneNumber,
                              ),

                            ),
                            SizedBox(
                              height:10 ,
                            ),
                            Padding(
                        padding: const EdgeInsets.only(left:10.0),
                        child: userInfo(
                          icon:Icons.location_city ,
                          content: location,
                        ),
                            ),

                            SizedBox(
                              height:35 ,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.limeAccent,
                            ),
                            _isSameUser ? Container()
                                : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _contactBy(
                                    color: Colors.green,
                                    fct: (){
                                      _oppenWhatsAppChat();
                                    },
                                    icon: FontAwesome.whatsapp,
                                ),
                                _contactBy(
                                  color: Colors.red,
                                  fct: (){
                                    _mailTo();
                                  },
                                  icon: Icons.mail_outline,
                                ),
                                _contactBy(
                                  color: Colors.purple,
                                  fct: (){
                                    _callPhoneNumber();
                                  },
                                  icon: Icons.call_outlined,
                                ),
                                _contactBy(
                                  color: Colors.lightGreen,
                                  fct: (){
                                    _getLocationOnMaps();
                                  },
                                  icon: Icons.location_on,
                                ),
                                ],
                            ),
                            SizedBox(
                              height:25 ,
                            ),
                            Divider(
                              thickness: 1,
                              color: Colors.limeAccent,
                            ),
                            SizedBox(
                              height:25 ,
                            ),
                            !_isSameUser ? Container()
                                :Row(
                                children :[ MaterialButton(
                                  onPressed: (){
                                    _auth.signOut();
                                    Navigator.push(
                                      context,MaterialPageRoute(builder: (context) => UserState()),

                                    );
                                  },
                                  color: Colors.white,
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(13),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical:14),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        SizedBox(
                                          width:8 ,
                                        ),
                                        Icon(
                                          Icons.logout,
                                          color: Colors.black54,
                                        )
                                      ],


                                  ),
                                ),
                              ),
                      SizedBox(width: 25,),
                      MaterialButton(
                                      onPressed: (){

                                        Navigator.push(
                                          context,MaterialPageRoute(builder: (context) => EditProfile(userID: widget.userID)),

                                        );
                                      },
                                      color: Colors.white,
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(13),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(vertical:14),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Edit profile',
                                              style: TextStyle(
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                            SizedBox(
                                              width:8 ,
                                            ),
                                            Icon(
                                              Icons.settings,
                                              color: Colors.black54,
                                            )
                                          ],


                                        ),

                                    ),
                                  ),
                              ]
                            ),




                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: size.width*0.28,
                          height: size.height*0.28,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 3,
                              color: Colors.limeAccent,

                            ),
                            image: DecorationImage(
                              image:NetworkImage(
                                  imageUrl==null
                                      ? 'https://cdn.pixabay.com/photo/2016/08/08/09/17/avatar-1577909_1280.png'
                                      : imageUrl!,
                              ),
                                fit: BoxFit.fill
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
        )
      ),
    );
  }

  void _oppenWhatsAppChat() async {
    var url='https://wa.me/$phoneNumber?text=Hello';
    launch(url);
  }

  void _mailTo() async {
    final Uri params= Uri(
      scheme:'mailto',
      path: email,
      query: 'subject=Write subject here,please&body=Please write details here',

    );

    final url = params.toString();
    launch(url);

  }

  void _callPhoneNumber() async {
    var url='tel://$phoneNumber';
     launch(url);

  }

  void _getLocationOnMaps() async {
    var url='https://www.google.com/maps/search/${Uri.encodeFull(location)}';
    launch(url);

  }


  Widget _contactBy({required Color color,required Function fct,required IconData icon}) {
    return CircleAvatar(
      backgroundColor: color,
      radius: 25,
      child: CircleAvatar(
        radius: 23,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: Icon(
            icon,
            color: color,
          ),
          onPressed: (){
            fct();
          },
        ),
      ),
    );
  }

  Widget userInfo({required IconData icon,required String content}) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            content,
            style: TextStyle(color: Colors.grey,fontSize: 16),
          ),
        )
      ],
    );
  }

}
