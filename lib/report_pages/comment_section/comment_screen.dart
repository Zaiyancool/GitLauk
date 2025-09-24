import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter_application_1/comp_manager/WriteMng/CommentSubmit.dart';

class CommentScreen extends StatefulWidget {
  final String reportId;
  final String title;

  const CommentScreen({
    super.key,
    required this.reportId,
    required this.title

  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentCtrl = TextEditingController();
  final List<String> comments = []; // Replace with Firestore stream later


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.title} (${widget.reportId})' ),
      ),
      body: Column(
        children: [
          Expanded(
            child: comments.isEmpty
                ? const Center(child: Text('No aditional info yet.'))
                : ListView.builder(
                    itemCount: comments.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(comments[index]),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Write additionals informations...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: ()  {
                     submitComment(widget.reportId, commentCtrl.text.trim());
                  }
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}