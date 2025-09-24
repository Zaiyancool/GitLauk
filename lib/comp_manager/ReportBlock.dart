import 'package:flutter/material.dart';

import 'package:flutter_application_1/comp_manager/MediaUploadMng.dart';
import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/report_pages/comment_section/comment_screen.dart';

class ReportBlock extends StatelessWidget {
  final String title;
  final String reportId;
  final String description;
  final String date;
  final String status;
  final String location;
  final String time;

  final commentCtrl = TextEditingController();

  ReportBlock({
    required this.title,
    required this.reportId,
    required this.description,
    required this.date,
    required this.status,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 300,
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "$title  ($reportId) ",
                      style: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    "STATUS: $status",
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                height: 140,
                child: SingleChildScrollView(
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 16.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        location,
                        style: const TextStyle(fontSize: 14.0, color: Colors.white70),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            date,
                            style: const TextStyle(fontSize: 14.0, color: Colors.white70),
                          ),
                          Text(
                            time,
                            style: const TextStyle(fontSize: 14.0, color: Colors.white70),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.add_comment, color: Colors.white70),
                      tooltip: 'View Comments',
                      onPressed: () {
                        debugPrint("Comment button pressed");
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CommentScreen(reportId: reportId, title: title)),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}