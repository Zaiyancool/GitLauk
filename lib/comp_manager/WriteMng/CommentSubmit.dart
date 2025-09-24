import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Future<void> submitComment(String reportId, String commentText) async {
//   final docRef = FirebaseFirestore.instance
//       .collection('comments_reports')
//       .doc(reportId);

//   try {
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       final snapshot = await transaction.get(docRef);

//       Map<String, dynamic> newComment = {
//         'text': commentText,
//         'timestamp': FieldValue.serverTimestamp(),
//       };

//       String targetArray = '';

//       if (snapshot.exists) {
//         final data = snapshot.data()!;
//         for (int i = 1; i <= 1000; i++) {
//           String key = 'comments_$i';
//           if (!data.containsKey(key)) {
//             targetArray = key;
//             break;
//           }
//         }
//       } else {
//         targetArray = 'comments_1';
//       }

//       if (targetArray.isEmpty) {
//         throw Exception("No available comment array field found");
//       }

//       Map<String, dynamic> updates = {
//         targetArray: FieldValue.arrayUnion([newComment]),
//       };

//       if (snapshot.exists) {
//         transaction.update(docRef, updates);
//       } else {
//         transaction.set(docRef, updates);
//       }
//     });
//   } catch (e) {
//     debugPrint("Transaction failed: $e");
//     throw Exception("Failed to submit comment");
//   }
// }

Future<void> submitComment(String reportId, String commentText) async {
final docRef = FirebaseFirestore.instance
    .collection('comments_reports')
    .doc(reportId);

await FirebaseFirestore.instance.runTransaction((transaction) async {
  final snapshot = await transaction.get(docRef);

  final newComment = commentText; // Just a string

  if (snapshot.exists) {
    transaction.update(docRef, {
      'Comments': FieldValue.arrayUnion([newComment]),
    });
  } else {
    transaction.set(docRef, {
      'Comments': [newComment],
    });
  }
});
}
/// Submits a comment to the Firestore 'comments_reports' collection for a given report.
///
/// Takes the [reportId] of the report and the [commentText] to be added.
/// Throws an [Exception] if the transaction fails.
/// 

// Future<void> submitComment(String reportId, String commentText) async {
//   final docRef = FirebaseFirestore.instance
//       .collection('comments_reports')
//       .doc(reportId);

//   try {
//     await FirebaseFirestore.instance.runTransaction((transaction) async {
//       final snapshot = await transaction.get(docRef);

//       if (snapshot.exists) {
//         transaction.update(docRef, {
//           'Comments': FieldValue.arrayUnion([commentText]),
//         });
//       } else {
//         transaction.set(docRef, {
//           'Comments': [commentText],
//         });
//       }
//     });
//   } catch (e) {
//     debugPrint("Transaction failed: $e");
//     throw Exception("Failed to submit comment: $e");
//   }
// }