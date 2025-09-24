import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/comp_manager/ButtonMng.dart';
import 'package:flutter_application_1/comp_manager/WriteMng/TypeReportCounter.dart';
import 'package:flutter_application_1/comp_manager/ReportBlock.dart';

import 'package:flutter_application_1/comp_manager/FetchMng/FetchLocation.dart';
import 'package:flutter_application_1/comp_manager/FetchMng/FetchReport.dart';


class ReportListScreen extends StatefulWidget {

  const ReportListScreen({super.key});

  @override
  State<ReportListScreen> createState() => _ReportListScreenState();
}

class _ReportListScreenState extends State<ReportListScreen> {

  Future<List<ReportDetails>> futureReports = fetchReports();

    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report List'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            futureReports = fetchReports();
          });
          await futureReports;
        },
        child: FutureBuilder<List<ReportDetails>>(
          future: futureReports,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            final reports = snapshot.data ?? [];
            if (reports.isEmpty) {
              return const Center(child: Text('No reports found.'));
            }

            return ListView.builder(
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];

                return ReportBlock(
                  title: report.type,
                  reportId: report.reportId,
                  description: report.description,
                  date: DateFormat('yyyy-MM-dd').format(report.timestamp),
                  time: DateFormat('HH:mm:ss').format(report.timestamp),
                  status: report.status,
                  location: report.location,
                );
              },
            );
          },
        ),
      ),
    );
  }
}