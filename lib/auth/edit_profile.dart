import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zaposlise/search/profile_company.dart';
import 'package:zaposlise/services/global_methods.dart';

class EditProfile extends StatefulWidget {

  final String userID;

  const EditProfile({

    required this.userID,

  });


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {

  final _formKey = GlobalKey<FormState>();


  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _isLoading=false;
  String phoneNumber ="";
  String email ="";
  String? name;
  String? imageUrl ="";
  String joinedAt = "";
  String location ="";
  bool _obscureText=true;




  FocusNode _emailFocusNode = FocusNode();
  FocusNode _passFocusNode = FocusNode();
  FocusNode _postitionCPFocusNode = FocusNode();
  FocusNode _phoneNumberFocusNode = FocusNode();

  void getUserData() async {

      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userID)
          .get();

      setState(() {
        email = userDoc.get('email');
        name = userDoc.get('name');
        phoneNumber = userDoc.get('phoneNumber');
        imageUrl = userDoc.get('userImage');
        location = userDoc.get('location');
      });

  }
  @override
  void dispose() {
    _emailTextController.dispose();
    _passTextController.dispose();
    _fullNameController.dispose();
    _phoneNumberController.dispose();
    _emailFocusNode.dispose();
    _passFocusNode.dispose();
    _postitionCPFocusNode.dispose();
    _phoneNumberFocusNode.dispose();

    super.dispose();
  }
  @override
  void initState() {
    super.initState();
    getUserData();

  }


  late TextEditingController _fullNameController ;
  late TextEditingController _emailTextController ;
  late TextEditingController _passTextController= new TextEditingController(text:'') ;
  late TextEditingController _locationController;
  late TextEditingController _phoneNumberController;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white60,
      body: Stack(
        children: [
          Container(
            color: Colors.black54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 80),
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_emailFocusNode),
                          keyboardType: TextInputType.name,
                          controller: _fullNameController= new TextEditingController(text:name),
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'This field is missing';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(color:Colors.lightBlue),
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_passFocusNode),
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailTextController = new TextEditingController(text:email),
                          validator: (value){
                            if(value!.isEmpty || !value.contains('@'))
                            {
                              return 'Please enter the valid email';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(color:Colors.lightBlue),
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_phoneNumberFocusNode),
                          focusNode: _passFocusNode,
                          keyboardType: TextInputType.visiblePassword,
                          controller: _passTextController,
                          validator: (value){
                            if(value!.isEmpty || value.length<7)
                            {
                              return 'Please enter the valid password';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          //obscureText: _obscureText? false: true,
                          obscureText: _obscureText? false: true,
                          decoration: InputDecoration(
                            suffixIcon: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _obscureText=!_obscureText;
                                });
                              },
                              child: Icon(
                                _obscureText ? Icons.visibility : Icons.visibility_off,
                                color: Colors.white,
                              ),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color:Colors.lightBlue),
                            hintStyle: TextStyle(color: Colors.white),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_postitionCPFocusNode),
                          focusNode: _phoneNumberFocusNode,
                          keyboardType: TextInputType.phone,
                          controller: _phoneNumberController=new TextEditingController(text:phoneNumber),
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'This field is missing';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Phone number',
                            labelStyle: TextStyle(color:Colors.lightBlue),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          onEditingComplete: () =>FocusScope.of(context).requestFocus(_postitionCPFocusNode),
                          focusNode: _postitionCPFocusNode,
                          keyboardType: TextInputType.text,
                          controller: _locationController = new TextEditingController(text:location),
                          validator: (value){
                            if(value!.isEmpty)
                            {
                              return 'This field is missing';
                            }
                            else
                            {
                              return null;
                            }
                          },
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Address',
                            labelStyle: TextStyle(color:Colors.lightBlue),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        _isLoading
                            ? Center(
                          child: Container(
                            width: 70,
                            height: 70,
                            child: CircularProgressIndicator(),
                          ),
                        ) : MaterialButton(
                          onPressed: () {
                            _submitFormOnSignUp();
                          },// _submitFormOnSignUp,
                          color: Colors.blue,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Edit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),

                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );


  }
  void _submitFormOnSignUp() async {

        var collection =  FirebaseFirestore.instance.collection('users');
        collection.doc(widget.userID).update({
          'name':_fullNameController.text,
          'location':_locationController.text,
          'phoneNumber':_phoneNumberController.text,
        });

        if(_passTextController.text.isNotEmpty==true){
          final user = FirebaseAuth.instance.currentUser;
          user!.updatePassword(_passTextController.text);
        }

        if(_emailTextController.text != email!) {
          final user = FirebaseAuth.instance.currentUser;
          user!.updateEmail(_emailTextController.text);
          collection.doc(widget.userID).update({
          'email': _emailTextController.text
          });
        }

        await Fluttertoast.showToast(
            msg: "The profile has been updated",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18
        );

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.userID)));

  }






  }



