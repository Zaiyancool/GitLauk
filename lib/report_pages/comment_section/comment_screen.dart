import 'package:flutter/material.dart';

class CommentScreen extends StatefulWidget {
  final String reportId;

  const CommentScreen({
    super.key,
    required this.reportId,

  });

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  final TextEditingController commentCtrl = TextEditingController();
  final List<String> comments = []; // Replace with Firestore stream later

  void submitComment() {
    final comment = commentCtrl.text.trim();
    if (comment.isEmpty) return;

    setState(() {
      comments.add(comment); // Replace with Firestore write
      commentCtrl.clear();
    });

    // TODO: Firestore logic to save comment under widget.reportId
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(' ${widget.reportId}'),
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
                  onPressed: submitComment,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}