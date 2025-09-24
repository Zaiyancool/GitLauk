import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

//   class CommentDetails {
//     final List<String> comments;

//     CommentDetails({required this.comments});

//     factory CommentDetails.fromFirestore(DocumentSnapshot doc) {
//       final data = doc.data() as Map<String, dynamic>;
//       final List<String> comments = List<String>.from(data['Comments'] ?? []);
//       return CommentDetails(comments: comments);
//     }
//   }

// Future<CommentDetails?> fetchComments(String docId) async {
//   try {
//     final doc = await FirebaseFirestore.instance
//         .collection('comments_reports')
//         .doc(docId)
//         .get();

//     if (doc.exists) {
//       debugPrint("Fetched comments: ${doc.data()}");
//       return CommentDetails.fromFirestore(doc);
//     } else {
//       debugPrint("No comments found for $docId");
//       return null;
//     }
//   } catch (e) {
//     debugPrint("Error fetching comments: $e");
//     return null;
//   }
// }

class Comments {
  final List<String> allComments;

  Comments({
    required this.allComments,
  });

  factory Comments.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final List<String> storedComments = List<String>.from(data['Comments'] ?? []);
    return Comments(allComments : storedComments);
  }
}

Future<List<Comments>> fetchComments(String reportId) async {
  List<Comments> allComments = [];

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('comments_reports')
        //.orderBy('Time', descending: true)
        .get();

      debugPrint("Fetched ${snapshot.docs.length} comments_reports");

    for (var doc in snapshot.docs) {
      debugPrint("Raw Firestore comments: ${doc.data()}");

      final data = doc.data();
      final List<String> storedComments = List<String>.from(data['Comments'] ?? []);

      allComments.add(Comments(allComments: storedComments));
    }
  } catch (e) {
    debugPrint("Error fetching comments: $e");
  }

  return allComments;
}