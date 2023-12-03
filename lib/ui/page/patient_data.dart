
import'package:flutter/material.dart';


class PatientData extends StatefulWidget {

  final Map<String, dynamic> data;

  PatientData({required this.data});

  @override
  State<PatientData> createState() => _PatientDataState();

}


class _PatientDataState extends State<PatientData> {
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title:Center(child: Text('Patient Information')),
        //Center(child: Text(widget.data["Name"])),

      ),
      body: ListView(
          scrollDirection: Axis.horizontal,
          children: [
        DataTable(
          columns:  [
            DataColumn(label: Text(
                'Patient ID',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
            )),
            DataColumn(label: Text(' ${widget.data["id" ]}', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),),),

          ],
          rows:  [
            DataRow(cells: [
              DataCell(Text('Patient Name',style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              DataCell(Text(widget.data["Name"])),
            ]),
            DataRow(cells: [
              DataCell(Text("Address",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              DataCell(Text(widget.data["Address"])),
                ]),
           DataRow(cells: [
            DataCell(Text("Phone Number",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
             DataCell(Text(widget.data["Phone Number"])),
             ]),
           DataRow(cells: [
             DataCell(Text("Date Of Birth",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              DataCell(Text(widget.data["Date Of Birth"])),
             ]),
          DataRow(cells: [
            DataCell(Text("Discolsure Date",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataCell(Text(widget.data["Discolsure Date"])),
            ]),
          DataRow(cells: [
            DataCell(Text("Chronic Diseases",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataCell(Text(widget.data["Chronic Diseases"])),
          ]),
          DataRow(cells: [
            DataCell(Text("Provious Operations",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataCell(Text(widget.data["Provious Operations"])),
          ]),
            DataRow(cells: [
              DataCell(Text("Gender",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
              DataCell(Text(widget.data["Gender"])),
            ]),
          DataRow(cells: [
            DataCell(Text("Diagnosis",style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
            DataCell(Text(widget.data["Diagnosis"])),
          ]),


          ],
        ),
      ])
    );
  }
}