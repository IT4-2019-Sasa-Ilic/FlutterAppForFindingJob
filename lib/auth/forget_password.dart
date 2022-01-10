import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zaposlise/auth/login.dart';
import 'package:zaposlise/auth/register.dart';

class ForgetPasswordScreen extends StatefulWidget {

  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {

  final _formKey = GlobalKey<FormState>();

  var email="";
  TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {

    _emailController.dispose();
    super.dispose();
  }

  resetPassword() async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      await Fluttertoast.showToast(
          msg: "The reset email has been sent",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18
      );
    } on FirebaseAuthException catch(error) {
      if (error.code == 'user-not-found') {
        await Fluttertoast.showToast(
            msg: "No user found with thah email",
            toastLength: Toast.LENGTH_LONG,
            backgroundColor: Colors.grey,
            fontSize: 18,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white12,
      appBar: AppBar(
        title: Text(
          'Reset password',
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: Text(
              'Reset link will be sent to your email',
              style: TextStyle(color:Colors.white,fontSize: 20),
            ),
          ),
          Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                  child: ListView(
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
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
                            hintText: 'Email',
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                                onPressed: (){

                                  if(_formKey.currentState!.validate()) {
                                    setState(() {
                                      email=_emailController.text;
                                    });
                                    resetPassword();
                                  }
                                },
                                child: Text(
                                  'Send email',
                                  style: TextStyle(
                                    fontSize: 18
                                  ),
                                ),
                            ),
                           SizedBox(
                             width: 15,
                           ),
                            TextButton(
                                onPressed: ()=>{
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()))
                                },
                              child: RichText(
                                text: TextSpan(
                                  children: [

                                    TextSpan(
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () => Navigator.canPop(context)
                                              ?Navigator.pop(context)
                                              :null,
                                        text: 'Login here',
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),

                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                  text: 'Dont have an account?',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                              TextSpan(text: '     '),
                              TextSpan(
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp())),
                                  text: 'Register here',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  )
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
          )
        ],
      ),
    );
  }
}
