import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:zaposlise/jobs/job_details.dart';
import 'package:zaposlise/search/profile_company.dart';
import 'package:zaposlise/services/global_methods.dart';

class CommentWidget extends StatefulWidget {
  final String commentID;
  final String commenterID;
  final String commenterName;
  final String commentBody;
  final String commenterImageUrl;
  final String jobId;
  final Timestamp time;


  // final Timestamp commentTime;

  const CommentWidget({
    required this.commentID,
    required this.commenterID,
    required this.commenterName,
    required this.commentBody,
    required this.commenterImageUrl,
    required this.jobId,
    required this.time,
  });

  @override
  _CommentWidgetState createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  var uploadedBy;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  List<Color> _colors = [
    Colors.amber,
    Colors.orange,
    Colors.pink.shade200,
    Colors.brown,
    Colors.cyan,
    Colors.blue,
    Colors.deepOrange,
  ];

  @override
  Widget build(BuildContext context) {
    _colors.shuffle();
    return InkWell(
      onTap: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileScreen(userID: widget.commenterID)));
      },
      onLongPress: () {_deleteDialog();},
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
            flex: 1,
              child: Container(

                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 2,
                    color: Colors.amber,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(image: NetworkImage(widget.commenterImageUrl),fit: BoxFit.fill),
                ),
              ),
          ),
          SizedBox(
            width: 6,
          ),
          Flexible(
            flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.commenterName,
              style: TextStyle(
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            Text(
              widget.commentBody,
              maxLines: 5,
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
                fontSize: 13,
              ),
            ),
                ],
              ),
          ),
        ],
      ),
    );
  }
  _deleteDialog(){
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    final obj = {
      'userId':widget.commenterID,
      'commentId': widget.commentID,
      'name': widget.commenterName,
      'userImageUrl':widget.commenterImageUrl,
      'commentBody':widget.commentBody,
      'time':widget.time,
       };

    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  try{
                    final DocumentSnapshot jobDatabase = await FirebaseFirestore.instance
                        .collection('jobs')
                        .doc(widget.jobId)
                        .get();
                    uploadedBy=jobDatabase.get('uploadedBy');

                    if(widget.commenterID==_uid || uploadedBy == _uid ) {
                      await FirebaseFirestore.instance
                          .collection('jobs')
                          .doc(widget.jobId)
                          .update(
                          {'jobComments':
                          FieldValue.arrayRemove([
                            {
                              'userId': widget.commenterID,
                              'commentId': widget.commentID,
                              'name': widget.commenterName,
                              'userImageUrl':widget.commenterImageUrl,
                              'commentBody':widget.commentBody,
                              'time':widget.time,
                            }
                          ])
                          });

                      await Fluttertoast.showToast(
                        msg: 'Comment has been deleted',
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18.0,
                      );

                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobDetailsScreen(jobID: widget.jobId, uploadedBy: uploadedBy)));
                    }
                    else{
                      GlobalMethod.showErrorDialog(error: "You can't preform this action", ctx: ctx);
                    }
                  }
                  catch(error){
                    GlobalMethod.showErrorDialog(error: "This comment can't be deleted", ctx: context);

                  }
                  finally {

                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ],

                ),
              ),
            ],
          );
        }
    );
  }
}
