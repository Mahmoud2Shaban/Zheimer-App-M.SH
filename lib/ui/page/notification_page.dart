import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {

  // show data inside email
  String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _dataStream = FirebaseFirestore.instance   //varible receives data
        .collection('timeNotification')    //table users
        .doc(email).collection('data')  // table data
        .orderBy('Time',descending: true)
        .snapshots();

    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.deepPurple,
          title: Center(
            child: Text("Notification",
              style: TextStyle(color: Colors.white,
                  fontSize: 25),),
          ),

        ),

        body: Column(
          children: [

            Expanded(
              // widget show data
              child: StreamBuilder<QuerySnapshot>(
                // data reception
                stream:  _dataStream,
                builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) { // error
                    return const Text('connection error');
                  }
                  // waiting
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text("Loading",style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 25),);
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = snapshot.data!.docs[index];

                      return
                        Container(
                          margin: EdgeInsets.all(10),
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(  // two color listtile
                                colors: [Colors.cyanAccent,
                                  Colors.purpleAccent]
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Text(data["Date"],),
                            subtitle: Text(data["Times"]),
                             trailing:Text(data["DisplayTimes"]),
                          ),
                        );
                    },


                  );
                },),
            ),

          ],
        )
    );




    // DocumentSnapshot data = snapshot.data!.docs[index];
    // Container(
    //   margin: EdgeInsets.all(10),
    //   padding: EdgeInsets.all(4),
    //   decoration: BoxDecoration(
    //     gradient: LinearGradient(  // two color listtile
    //         colors: [Colors.cyanAccent,
    //           Colors.purpleAccent]
    //     ),
    //     borderRadius: BorderRadius.circular(15),
    //   ),
    //   child: ListTile(
    //     title: Text(data["Name"],),
    //     subtitle: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         Text(data["Phone Number"]),
    //         Text(data["Discolsure Date"]),
    //       ],
    //     ),
    //     //trailing:
    //   ),
    // );



    //   Scaffold(
    //   appBar: AppBar(
    //     backgroundColor: Colors.deepPurple,
    //     automaticallyImplyLeading: false,
    //     title: Center
    //       (child: Text("Notification",
    //       style: TextStyle(color: Colors.white,
    //           fontSize: 25),),),
    //   ),
    //   body: Center(
    //     child: Text("Notification",style: TextStyle(fontSize: 60),),
    //   ),
    // );
  }
}
