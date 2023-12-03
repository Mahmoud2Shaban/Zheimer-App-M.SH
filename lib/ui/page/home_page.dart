import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zheimer/ui/auth/login_screen.dart';
import 'package:zheimer/utils/utils.dart';

import 'patient_data.dart';

import 'package:http/http.dart' as http;


class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Firebase
  final auth = FirebaseAuth.instance;

  // realtime database
  //final databaseRef = FirebaseDatabase.instance.ref("PatientData");

  // variable Search
  final searchFilter = TextEditingController();
  //variable date
  TextEditingController date = TextEditingController();
  //variable hour
  TextEditingController hour = TextEditingController();
  //variable display_times
  TextEditingController display_times = TextEditingController();
  // varible date
  //DateTime dateTime=DateTime.now();
  DateTime dateTime=DateTime(3000);
  // Key validator
  final _formKey =GlobalKey<FormState>();

  // show data inside email
  String? email = FirebaseAuth.instance.currentUser!.email;
  // Delete data
  deletedata(id) async{
    await FirebaseFirestore.instance.
    collection('PatientData')
        .doc(email).collection('data').doc(id).delete();
  }

  // getdata(id){
  //   // show data inside email
  //   String? email = FirebaseAuth.instance.currentUser!.email;
  //
  //   CollectionReference showdata = FirebaseFirestore.instance.collection("PatientData");
  //   showdata.doc(email).collection("data").doc(id).get().then((DocumentSnapshot snapshot){
  //     snapshot.data();
  //     print(showdata.doc(email).collection("data").doc(id));
  //
  //   } );
  // }

  // Firebase
  // Database name table PatientData
  CollectionReference users = FirebaseFirestore.instance.collection('timeNotification');
  void Savedata(){

    // add data inside the user's email
    String? email = FirebaseAuth.instance.currentUser!.email;
    // name table database data
    users.doc(email).collection('data').add({

      "Date" :date.text.toString(),
      "Times" :hour.text.toString(),
      "DisplayTimes" :display_times.text.toString(),
      'Time' : DateTime.now(),

    }).then((value){
      setState(() {
        // show Message Successfully and clear data
        Utils().toastMessage("Data saved successfully");
        //  Clear Data
        date.clear();
        hour.clear();
        display_times.clear();

      });
    }).onError((error, stackTrace){
      // show Message error and clear data
      Utils().toastMessage(error.toString());
      // & Clear Data
      setState(() {
        date.clear();
        hour.clear();
        display_times.clear();
      });
    });
  }


  @override
  Widget build(BuildContext context) {

    final Stream<QuerySnapshot> _dataStream = FirebaseFirestore.instance   //varible receives data
        .collection('PatientData')    //table users
        .doc(email).collection('data')  // table data
        .orderBy('Time',descending: true)
        .snapshots();

    //var snapshot;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.deepPurple,
        title: Center(
          child: Text("Home",
          style: TextStyle(color: Colors.white,
              fontSize: 25),),
        ),
        actions: [
          IconButton(onPressed: (){
            // logout in firebase
            auth.signOut().then((value){
              Navigator.push(context,
                  MaterialPageRoute(builder: (context)=>LoginScreen()));
            }).onError((error, stackTrace) {
              // message error
              Utils().toastMessage(error.toString(),);
            });
          },
              icon: Icon(Icons.login_outlined)),
        ],

      ),

      body: Column(
        children: [
          SizedBox(height: 10,),
          // TextFormField (Search)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextFormField(
              controller: searchFilter,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder()
              ),
              onChanged: (String value){
                setState(() {

                });
              },
            ),
          ),

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

                    itemBuilder: (context,index){
                      final documentSnapshot = snapshot.data!.docs[index];
                      final data = documentSnapshot.data() as Map<String, dynamic>;
                    //DocumentSnapshot data = snapshot.data!.docs[index];
                    // show phone call
                    final String _phones = data["Phone Number"];
                    if(searchFilter.text.isEmpty){
                      return Slidable(   // withdraw
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(onPressed: ((context) async{
                              // call number
                              final _call = 'tel:$_phones';
                              if(await canLaunchUrlString(_call)){
                                await launchUrlString(_call);
                              }
                            }),
                              backgroundColor: Colors.green,
                              icon: Icons.phone,
                              label: 'Phone',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion:StretchMotion(),
                          children: [
                            SlidableAction(onPressed: ((context)async{
                              // message
                              final _sms = 'sms:$_phones';
                              if(await canLaunchUrlString(_sms)){
                                await launchUrlString(_sms);
                              }
                            }),
                              backgroundColor: Colors.blue,
                              icon: Icons.chat,
                              label: 'Message',
                            ),
                          ],
                        ),
                        child: Container(
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
                            title: Text(data["Name"],),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data["Phone Number"]),
                                Text(data["Discolsure Date"]),
                              ],
                            ),
                            trailing:PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value :1,
                                    child: ListTile(
                                      onTap: ()async{
                                        Navigator.pop(context);
                                        await deletedata(snapshot.data?.docs[index].id);
                                        Utils().toastMessage("Data Deleted successfully");
                                      },
                                      leading: Icon(Icons.delete,color: Colors.red,),
                                      title: Text('Delete'),
                                    )
                                ),
                                PopupMenuItem(
                                    value :1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        showDialog(context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                backgroundColor: Colors.grey[200],
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.notifications,color: Colors.deepPurple,),
                                                    SizedBox(width: 5,),
                                                    Text("Add Notification"),
                                                  ],
                                                ),
                                                content: Form(
                                                  // pass key validator
                                                  key: _formKey,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(left: 10,right: 10),
                                                            child: Text('Determine the time,date and frequency of notification')),
                                                        SizedBox(height: 10,),

                                                        //TextFormField(Date )
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable Date
                                                            controller: date,
                                                            keyboardType: TextInputType.datetime,
                                                            decoration: InputDecoration(
                                                                hintText: "Date",
                                                                suffixIcon:  IconButton(onPressed: (){

                                                                  setState(() {
                                                                    // click icon show date
                                                                    showDatePicker(context: context,
                                                                      initialDate: DateTime.now(),
                                                                      firstDate: DateTime(1950),
                                                                      lastDate: DateTime(3000),).then((value) {
                                                                      setState(() {
                                                                        dateTime=value!;
                                                                        // show data in textfromfield
                                                                        final DateFormat formatter = DateFormat("dd/MM/yyyy");
                                                                        final String formatted = formatter.format(value);
                                                                        date.text=formatted;
                                                                      });
                                                                    });
                                                                  });
                                                                },icon: Icon(Icons.date_range,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Date";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),

                                                        //TextFormField(Hour )
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable Hour
                                                            controller: hour,
                                                            keyboardType: TextInputType.datetime,
                                                            decoration: InputDecoration(
                                                                hintText: "Hour",
                                                                suffixIcon:  IconButton(onPressed: ()async{
                                                                  var time = await showTimePicker(
                                                                      context: context, initialTime: TimeOfDay.now());

                                                                  if (time != null) {
                                                                    hour.text = time.format(context);}

                                                                },icon: Icon(Icons.access_time_outlined,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Hour";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),

                                                        //TextFormField(display_times )
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable date_birth
                                                            controller: display_times,
                                                            keyboardType: TextInputType.number,
                                                            decoration: InputDecoration(
                                                                hintText: "Display Times",
                                                                suffixIcon:  IconButton(onPressed: () {

                                                                },icon: Icon(Icons.numbers_outlined,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Display Times";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Row( Send & Close )
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(onPressed:(){
                                                        if(_formKey.currentState!.validate()){
                                                        Savedata();}
                                                        }, child: Text('Save',style: TextStyle(color:Colors.deepPurple),)),
                                                      TextButton(onPressed:(){
                                                        Navigator.of(context).pop();
                                                      },
                                                        child: Text('Close',style: TextStyle(color: Colors.red),),)
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      leading: Icon(Icons.notifications,color: Colors.deepPurple,),
                                      title: Text('Add Notification'),
                                      //trailing: Icon(Icons.notifications,color: Colors.deepPurple,),
                                    )
                                ),
                              ],
                            ),
                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>PatientData(data:data ,)));
                              //getdata(snapshot.data?.docs[index].id);
                             //print(data['id']);
                            },
                          ),
                        ),
                      );
                    }else if(data["Name"].toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
                      return Slidable(   // withdraw
                        startActionPane: ActionPane(
                          motion: StretchMotion(),
                          children: [
                            SlidableAction(onPressed: ((context) async{
                              // call number
                              final _call = 'tel:$_phones';
                              if(await canLaunchUrlString(_call)){
                                await launchUrlString(_call);
                              }
                            }),
                              backgroundColor: Colors.green,
                              icon: Icons.phone,
                              label: 'Phone',
                            ),
                          ],
                        ),
                        endActionPane: ActionPane(
                          motion:StretchMotion(),
                          children: [
                            SlidableAction(onPressed: ((context)async{
                              // message
                              final _sms = 'sms:$_phones';
                              if(await canLaunchUrlString(_sms)){
                                await launchUrlString(_sms);
                              }
                            }),
                              backgroundColor: Colors.blue,
                              icon: Icons.chat,
                              label: 'Message',
                            ),
                          ],
                        ),
                        child: Container(
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
                            title: Text(data["Name"]),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(data["Phone Number"]),
                                Text(data["Discolsure Date"]),
                              ],
                            ),
                            trailing:
                            PopupMenuButton(
                              icon: Icon(Icons.more_vert),
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                    value :1,
                                    child: ListTile(
                                      onTap: ()async{
                                        Navigator.pop(context);
                                        await deletedata(snapshot.data?.docs[index].id);
                                        Utils().toastMessage("Data Deleted successfully");
                                      },
                                      leading: Icon(Icons.delete,color: Colors.red,),
                                      title: Text('Delete'),
                                    )
                                ),
                                PopupMenuItem(
                                    value :1,
                                    child: ListTile(
                                      onTap: (){
                                        Navigator.pop(context);
                                        showDialog(context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                backgroundColor: Colors.grey[200],
                                                title: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons.notifications,color: Colors.deepPurple,),
                                                    SizedBox(width: 5,),
                                                    Text("Add Notification"),
                                                  ],
                                                ),
                                                content: Form(
                                                  // pass key validator
                                                  key: _formKey,
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      mainAxisSize: MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                            margin: EdgeInsets.only(left: 10,right: 10),
                                                            child: Text('Determine the time,date and frequency of notification')),
                                                        SizedBox(height: 10,),

                                                        //TextFormField(Date )
                                                        Container(

                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable Date
                                                            controller: date,
                                                            keyboardType: TextInputType.datetime,
                                                            decoration: InputDecoration(
                                                                hintText: "Date",
                                                                suffixIcon:  IconButton(onPressed: (){

                                                                  setState(() {
                                                                    // click icon show date
                                                                    showDatePicker(context: context,
                                                                      initialDate: DateTime.now(),
                                                                      firstDate: DateTime(1950),
                                                                      lastDate: DateTime(3000),).then((value) {
                                                                      setState(() {
                                                                        dateTime=value!;
                                                                        // show data in textfromfield
                                                                        final DateFormat formatter = DateFormat("dd/MM/yyyy");
                                                                        final String formatted = formatter.format(value);
                                                                        date.text=formatted;
                                                                      });
                                                                    });
                                                                  });
                                                                },icon: Icon(Icons.date_range,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Date";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),

                                                        //TextFormField(Hour )
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable Hour
                                                            controller: hour,
                                                            keyboardType: TextInputType.datetime,
                                                            decoration: InputDecoration(
                                                                hintText: "Hour",
                                                                suffixIcon:  IconButton(onPressed: ()async{
                                                                  var time = await showTimePicker(
                                                                      context: context, initialTime: TimeOfDay.now());

                                                                  if (time != null) {
                                                                    hour.text = time.format(context);}

                                                                },icon: Icon(Icons.access_time_outlined,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Hour";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),

                                                        //TextFormField(display_times )
                                                        Container(
                                                          margin: EdgeInsets.only(top: 20,left: 10,right: 10),
                                                          width: double.infinity,
                                                          child: TextFormField(
                                                            // pass variable date_birth
                                                            controller: display_times,
                                                            keyboardType: TextInputType.number,
                                                            decoration: InputDecoration(
                                                                hintText: "Display Times",
                                                                suffixIcon:  IconButton(onPressed: () {

                                                                },icon: Icon(Icons.numbers_outlined,),),
                                                                border: OutlineInputBorder(
                                                                  borderRadius: BorderRadius.circular(15),
                                                                )
                                                            ),
                                                            // Validator check Date of Birth
                                                            validator: (value){
                                                              if(value!.isEmpty){
                                                                return "Enter Display Times";
                                                              }else{
                                                                return null;
                                                              }
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                //Row( Send & Close )
                                                actions: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      TextButton(onPressed:(){
                                                        if(_formKey.currentState!.validate()){
                                                          Savedata();}
                                                      }, child: Text('Save',style: TextStyle(color:Colors.deepPurple),)),
                                                      TextButton(onPressed:(){
                                                        Navigator.of(context).pop();
                                                      },
                                                        child: Text('Close',style: TextStyle(color: Colors.red),),)
                                                    ],
                                                  ),
                                                ],
                                              );
                                            });
                                      },
                                      leading: Icon(Icons.notifications,color: Colors.deepPurple,),
                                      title: Text('Add Notification'),
                                      //trailing: Icon(Icons.notifications,color: Colors.deepPurple,),
                                    )
                                ),
                              ],
                            ),
                            // IconButton(onPressed: ()async{
                            //   await deletedata(snapshot.data?.docs[index].id);
                            //   Utils().toastMessage("Data Deleted successfully");
                            // },icon:Icon(Icons.delete,color: Colors.red,),),

                            onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>PatientData(data: data,)));

                            },
                          ),
                        ),
                      );
                    }else{
                      return Container();
                    }
                    },
                  );
              },),
          ),


          // RealTime Database

          // Expanded(
          //   child: FirebaseAnimatedList(
          //     //pass data from Realtime database
          //       query: databaseRef,
          //       // Waiting show data
          //       defaultChild: Text("Loading",style: TextStyle(color: Colors.deepPurpleAccent,fontSize: 25),),
          //       itemBuilder: (context,snapshot,animation,index){
          //         final name = snapshot.child("Name :").value.toString();
          //         //Show data and Search in Data
          //         if(searchFilter.text.isEmpty){
          //           return Container(
          //             margin: EdgeInsets.all(10),
          //             padding: EdgeInsets.all(4),
          //             decoration: BoxDecoration(
          //               gradient: LinearGradient(  // two color listtile
          //                   colors: [Colors.cyanAccent,
          //                     Colors.purpleAccent]
          //               ),
          //               borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ListTile(
          //
          //               title: Text(snapshot.child("Name :").value.toString()),
          //               subtitle: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   //Text(snapshot.child("Address").value.toString()),
          //                   Text(snapshot.child("Phone Number :").value.toString()),
          //                   Text(snapshot.child("Discolsure Date :").value.toString()),
          //                 ],
          //               ),
          //              trailing:PopupMenuButton(
          //                 icon: Icon(Icons.more_vert),
          //                 itemBuilder: (context) => [
          //                   PopupMenuItem(
          //                       value: 1,
          //                       child: ListTile(
          //                         onTap: (){
          //                           Navigator.pop(context);
          //                           databaseRef.child(snapshot.child("id :").value.toString()).remove();
          //                         },
          //                         leading: Icon(Icons.delete),
          //                         title: Text("Delete"),
          //                       )
          //                   )
          //                 ],
          //               ),
          //               onTap: (){
          //                 Navigator.push(context,
          //                     MaterialPageRoute(builder: (context)=>PatientData()));
          //
          //               },
          //             ),
          //           );
          //         }else if(name.toLowerCase().contains(searchFilter.text.toLowerCase().toLowerCase())){
          //           return Container(
          //             margin: EdgeInsets.all(10),
          //             padding: EdgeInsets.all(4),
          //             decoration: BoxDecoration(
          //               gradient: LinearGradient(  // two color listtile
          //                   colors: [Colors.cyanAccent,
          //                     Colors.purpleAccent]
          //               ),
          //               borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ListTile(
          //               title: Text(snapshot.child("Name :").value.toString()),
          //               subtitle: Column(
          //                 crossAxisAlignment: CrossAxisAlignment.start,
          //                 children: [
          //                   //Text(snapshot.child("Address").value.toString()),
          //                   Text(snapshot.child("Phone Number :").value.toString()),
          //                   Text(snapshot.child("Discolsure Date :").value.toString()),
          //                 ],
          //               ),
          //               trailing:PopupMenuButton(
          //                 icon: Icon(Icons.more_vert),
          //                 itemBuilder: (context) => [
          //                   PopupMenuItem(
          //                       value: 1,
          //                       child: ListTile(
          //                         onTap: (){
          //                           Navigator.pop(context);
          //                           databaseRef.child(snapshot.child("id :").value.toString()).remove();
          //                         },
          //                         leading: Icon(Icons.delete),
          //                         title: Text("Delete"),
          //                       )
          //                   )
          //                 ],
          //               ),
          //             ),
          //           );
          //         }else{
          //           return Container();
          //         }
          //
          //       }
          //       ),
          // )


        ],
      )
    );
  }
}
