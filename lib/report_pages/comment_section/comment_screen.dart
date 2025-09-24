import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CommentScreen extends StatefulWidget {
  final String reportId; // document ID in Firestore
  final String title;

  const CommentScreen({
    super.key,
    required this.reportId,
    required this.title,
    });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(' ${widget.title} (${widget.reportId})' ),),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('comments_reports')
            .doc(widget.reportId) // use the docId passed into the widget
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text("No comments found"));
          }

          if (snapshot.hasData) {
            debugPrint("Document data: ${snapshot.data!.data()}");
}

          // Get comments array
          List<String> comments =
              List<String>.from(snapshot.data!['Comments'] ?? []);

          if (comments.isEmpty) {
            return const Center(child: Text("Be the first to comment!"));
          }

          return ListView.builder(
            itemCount: comments.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Icon(Icons.comment),
                title: Text(comments[index]),
              );
            },
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import 'package:flutter_application_1/comp_manager/WriteMng/CommentSubmit.dart';
// import 'package:flutter_application_1/comp_manager/FetchMng/FetchComments.dart';

// class CommentScreen extends StatefulWidget {
//   final String reportId;
//   final String title;

//   const CommentScreen({
//     super.key,
//     required this.reportId,
//     required this.title

//   });

//   @override
//   State<CommentScreen> createState() => _CommentScreenState();
// }

// class _CommentScreenState extends State<CommentScreen> {
//   final TextEditingController commentCtrl = TextEditingController();
//   //final List<String> allComments = []; // Replace with Firestore stream later
//   late Future<List<Comments>> futureComments;

//   @override
//   void initState() {
//     super.initState();
//     futureComments = fetchComments(widget.reportId);
//   }

//=====================
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text(' ${widget.title} (${widget.reportId})' ),
  //     ),
  //     body: RefreshIndicator(
  //       onRefresh: () async {
  //         setState(() {
  //           futureComments = fetchComments(widget.reportId);
  //         });
  //         await futureComments;
  //       },

        // child: FutureBuilder<List<Comments>>(
        //   future: futureComments,
        //   builder: (context, snapshot) {
        //        if (snapshot.connectionState == ConnectionState.waiting) {
        //       return const Center(child: CircularProgressIndicator());
        //     }

        //     if (snapshot.hasError) {
        //       return Center(child: Text('Error: ${snapshot.error}'));
        //     }

        //     final allComments = snapshot.data ?? [];
        //     if (allComments.isEmpty) {
        //       return const Center(child: Text('No comments found.'));
        //     }

        //     return ListView.builder(
        //       itemCount: allComments.length,
        //       itemBuilder: (context, index) {
        //         final comment = allComments[index];

        //         return ListTile(
        //           title: Text(comment.toString()),
        //         );
        //       },
        //     );
                  
        // }
        
  //     Column(
  //       children: [
  //=====================================

        //   Expanded(
        //     child: comments.isEmpty
        //         ? const Center(child: Text('No aditional info yet.'))
        //         : ListView.builder(
        //             itemCount: comments.length,
        //             itemBuilder: (context, index) {
        //               return ListTile(
        //                 title: Text(comments[index]),
        //               );
        //             },
        //           ),
        //   ),
        //   Padding(
        //     padding: const EdgeInsets.all(12.0),
        //     child: Row(
        //       children: [
        //         Expanded(
        //           child: TextField(
        //             controller: commentCtrl,
        //             decoration: const InputDecoration(
        //               hintText: 'Write additionals informations...',
        //               border: OutlineInputBorder(),
        //             ),
        //           ),
        //         ),
        //         const SizedBox(width: 8),

        //         IconButton(
        //           icon: const Icon(Icons.send),
        //           onPressed: ()  {
        //              submitComment(widget.reportId, commentCtrl.text.trim());
        //           }
        //         ),

        //       ],
        //     ),
        //   ),
        // ],
// ======================================
        // Expanded(
        //     child: StreamBuilder<DocumentSnapshot>(
        //       stream: FirebaseFirestore.instance
        //           .collection('comments_reports')
        //           .doc(widget.reportId)
        //           .snapshots(),
                  
                  
        //       builder: (context, snapshot) {

        //         debugPrint("StreamBuilder triggered");

        //         List<String> allComments = [];

        //         if (snapshot.connectionState == ConnectionState.waiting) {
        //           return const Center(child: CircularProgressIndicator());
        //         }

        //         if (!snapshot.hasData || !snapshot.data!.exists) {
        //           return const Center(child: Text('No additional info yet.'));
        //         }

        //         else {
        //           final data = snapshot.data!;
        //           debugPrint("Raw Firestore data: ${data.data()}");

        //           allComments = List<String>.from(data['Comments'] ?? []);

        //           debugPrint("$allComments");
        //         }


        //         if (allComments.isEmpty) {
        //           return const Center(child: Text('No additional info yet.'));
        //         }

        //         return ListView.builder(
        //           itemCount: allComments.length,
        //           itemBuilder: (context, index) {
        //             return ListTile(
        //               title: Text(allComments[index]),
        //             );
        //           },
                  
        //         );
        //       },
        //     ),
        //   ),
//=========================

//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('comments_reports')
//                     .doc(widget.reportId)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   if (!snapshot.hasData || !snapshot.data!.exists) {
//                     return const Center(child: Text('No additional info yet.'));
//                   }

//                   final rawData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
//                   final comments = List<String>.from(rawData['Comments'] ?? []);

//                   if (comments.isEmpty) {
//                     return const Center(child: Text('No additional info yet.'));
//                   }

//                   return ListView.builder(
//                     itemCount: comments.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(comments[index]),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),

//           Padding(
//             padding: const EdgeInsets.all(12.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: commentCtrl,
//                     decoration: const InputDecoration(
//                       hintText: 'Write additional information...',
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 IconButton(
//                   icon: const Icon(Icons.send),
//                   onPressed: () {
//                     submitComment(widget.reportId, commentCtrl.text.trim());
//                     commentCtrl.clear();
//                   },
//                 ),
//               ],
//             ),
//           ),

//         ]
//       ),
//       ),
//       )
//     );
//   }
// }

//=====================
// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       title: Text('${widget.title} (${widget.reportId})'),
//     ),
//     body: RefreshIndicator(
//         onRefresh: () async {
//           setState(() {
//             futureComments = fetchComments(widget.reportId);
//           });
//           await futureComments;
//         },

//         child: FutureBuilder<List<Comments>>(
//           future: futureComments,
//           builder: (context, snapshot) {
//                if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }

//             if (snapshot.hasError) {
//               return Center(child: Text('Error: ${snapshot.error}'));
//             }

//             final allComments = snapshot.data ?? [];
//             if (allComments.isEmpty) {
//               return const Center(child: Text('No comments found.'));
//             }

//             return ListView.builder(
//               itemCount: allComments.length,
//               itemBuilder: (context, index) {
//                 final comment = allComments[index];

//                 return ListTile(
//                   title: Text(comment.toString()),
//                 );
//               },
//             );
                  
//         },

      // child: StreamBuilder<DocumentSnapshot>(
      //   stream: FirebaseFirestore.instance
      //       .collection('comments_reports')
      //       .doc(widget.reportId)
      //       .snapshots(),
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const Center(child: CircularProgressIndicator());
      //     }

      //     if (!snapshot.hasData || !snapshot.data!.exists) {
      //       return const Center(child: Text('No comments found.'));
      //     }

      //     final rawData = snapshot.data!.data() as Map<String, dynamic>? ?? {};
      //     final comments = List<String>.from(rawData['Comments'] ?? []);

      //     if (comments.isEmpty) {
      //       return const Center(child: Text('No comments found.'));
      //     }

      //     return ListView.builder(
      //       physics: const AlwaysScrollableScrollPhysics(), // required for RefreshIndicator
      //       itemCount: comments.length,
      //       itemBuilder: (context, index) {
      //         return ListTile(
      //           title: Text(comments[index]),
      //         );
      //       },
      //     );
      //   },
      // ),
//     ),
//     )
//   );
// }
// }