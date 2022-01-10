import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zaposlise/persistent/persistent.dart';
import 'package:zaposlise/search/search_job.dart';
import 'package:zaposlise/services/global_variables.dart';
import 'package:zaposlise/widgets/bottomNavBar.dart';
import 'package:zaposlise/widgets/job_widget.dart';
class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  _JobsScreenState createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {

  String? jobCategoryFilter;




  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      bottomNavigationBar: BottomNavigationBarForApp(i:0,),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: IconButton(
            icon: Icon(Icons.filter_list_outlined,color: Colors.grey,),
          onPressed: (){
              _showTaskCategoriesDialog(size: size);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search_outlined,color: Colors.grey,),
              onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => SearchScreen()));
              },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot<Map<String,dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('jobs')
            .where('jobCategory',isEqualTo: jobCategoryFilter)
            .orderBy('createdAt',descending: false)
            .snapshots(),
        builder:(context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Center(child:CircularProgressIndicator());
          }
          else if(snapshot.connectionState==ConnectionState.active) {
            if(snapshot.data?.docs.isNotEmpty==true){
              return ListView.builder(
                  itemCount: snapshot.data?.docs.length,
                  itemBuilder: (BuildContext context,int index){

                    return JobWidget(
                        jobTitle: snapshot.data?.docs[index]['jobTitle'],
                        jobDescription: snapshot.data?.docs[index]['jobDescription'],
                        jobId: snapshot.data?.docs[index]['jobID'],
                        uploadedBy: snapshot.data?.docs[index]['uploadedBy'],
                        userImage: snapshot.data?.docs[index]['userImage'],
                        name: snapshot.data?.docs[index]['name'],
                        recruitment: snapshot.data?.docs[index]['recruitment'],
                        email: snapshot.data?.docs[index]['email'],
                        location: snapshot.data?.docs[index]['location']
                    );
                  }
              );
            }else {
              return Center(
                child: Text('There is no jobs'),
              );
            }
          }
          return Center(
            child: Text(
              'Something went wrong',
              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
            ),

          );
        } ,
      )
    );

  }

  _showTaskCategoriesDialog({required Size size}){
    showDialog(
      context: context,
      builder: (ctx){
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            'Job Category',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize:20,color:Colors.white),
          ),
          content: Container(
            width: size.width*0.9,
            child: ListView.builder(
              shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx,index){
                return InkWell(
                 onTap: (){
                   setState(() {
                     jobCategoryFilter=Persistent.jobCategoryList[index];
                   });
                   Navigator.canPop(ctx)? Navigator.pop(ctx):null;
                   print(
                     'jobCategoryList[index], ${Persistent.jobCategoryList[index]}'

                   );
                 },
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_right_outlined,
                        color:Colors.grey
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                            Persistent.jobCategoryList[index],
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                            ),
                        ),
                      )
                    ],
                  ),
                );
                }
            ),
          ),
          actions: [
            TextButton(onPressed:  () {
              Navigator.canPop(ctx) ? Navigator.pop(ctx) : null;
            } ,
                child: Text('Close',style:TextStyle(color: Colors.white))
            ),
            TextButton(onPressed:  () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => JobsScreen()));
            } ,
                child: Text('Cancel Filter',style:TextStyle(color: Colors.white))
            ),
          ],
        );
      }
    );
  }
}
