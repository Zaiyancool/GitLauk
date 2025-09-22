import 'package:flutter/material.dart';

import 'package:flutter_application_1/comp_manager/MediaUploadMng.dart';

class  ReportBlock extends StatelessWidget {
  final String title;
  final String description;
  final String date;

   ReportBlock({
    required this.title,
    required this.description,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        height: 250, // Set a fixed height for the ListView
        color: Colors.indigo,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     title,
            //     style: TextStyle(
            //       fontSize: 18.0,
            //       fontWeight: FontWeight.bold,
            //       color: Colors.white,
            //     ),
            //   ),
            // ),



                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      MediaUploadButtons(
                        onPhotoPressed: () {
                          // TODO: handle photo upload
                        },
                        onVideoPressed: () {
                          // TODO: handle video upload
                        },
                        onFilePressed: () {
                          // TODO: handle file upload
                        },
                      ),
                    ],
                  ),
                ),


              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SizedBox(
                  height: 95, 
                  child: SingleChildScrollView(
                    child: Text(
                      description,
                      style: TextStyle(fontSize: 16.0, color: Colors.white),
                    ),
                  ),
                ),
              ),


            Spacer(),

            Padding(
              padding: const EdgeInsets.only(right: 9.0), // adjust this value as needed
              child: Align(
                alignment: Alignment.topRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end, // aligns text to the right
                  children: [
                    Text(
                      date,
                      style: TextStyle(fontSize: 14.0, color: Colors.white70),
                    ),
                    Text(
                      "21:30:00",
                      style: TextStyle(fontSize: 14.0, color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Near USM",
                    style: TextStyle(fontSize: 14.0, color: Colors.white70),
                  ),
                  Text(
                    "STATUS: PENDING",
                    style: TextStyle(fontSize: 14.0, color: Colors.white70),
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