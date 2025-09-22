import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/comp_manager/ButtonMng.dart';
import 'package:flutter_application_1/comp_manager/FetchLocation.dart';
import 'package:flutter_application_1/comp_manager/TypeReportCounter.dart';
import 'package:flutter_application_1/comp_manager/ReportBlock.dart';

class ReportListScreen extends StatefulWidget {

  ReportListScreen({super.key});

  final List reports = [
    {
      'title': 'Report 1',
      'description': 'Description of Report 1, let see how it looks like when the text is really long. This should ideally wrap around to the next line and demonstrate the text wrapping functionality in Flutter., how long can this go?, hopefully not too long, it should be fine. huh how about now?, right this is getting a bit excessive but still good to test.',
      'date': '2023-10-01',
    },
    {
      'title': 'Report 2',
      'description': 'Description of Report 2',
      'date': '2023-10-02',
    },
    {
      'title': 'Report 3',
      'description': 'Description of Report 3',
      'date': '2023-10-03',
    },
    {
      'title': 'Report 4',
      'description': 'Description of Report 4',
      'date': '2023-10-04',
    },
    {
      'title': 'Report 5',
      'description': 'Description of Report 5',
      'date': '2023-10-05',
    },
    {
      'title': 'Report 6',
      'description': 'Description of Report 6',
      'date': '2023-10-06',
    },
    {
      'title': 'Report 7',
      'description': 'Description of Report 7',
      'date': '2023-10-07',
    },
    {
      'title': 'Report 8',
      'description': 'Description of Report 8',
      'date': '2023-10-08',
    },
    {
      'title': 'Report 9',
      'description': 'Description of Report 9',
      'date': '2023-10-09',
    },
    {
      'title': 'Report 10',
      'description': 'Description of Report 10',
      'date': '2023-10-10',
    },
  ];

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report List')),
      // body: ListView.builder(itemBuilder: (context, index) => Column(
      //   return ReportBlock(
      //     title: widget.reports[index]['title'],
      //     description: widget.reports[index]['description'],
      //     date: widget.reports[index]['date'],
      //   ),

      // ),

      body: ListView.builder(
        itemCount: widget.reports.length,
        itemBuilder: (context, index) {
          final report = widget.reports[index];
          return ReportBlock(
            title: report['title'],
            description: report['description'],
            date: report['date'],
          );
        },
    ),
  );
  }
}

