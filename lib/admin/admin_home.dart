import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:js' as js;

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final reportsRef = FirebaseFirestore.instance.collection('reports');

  Future<void> openMap(GeoPoint point) async {
    final url = 'https://www.google.com/maps/search/?api=1&query=${point.latitude},${point.longitude}';

    try {
      if (kIsWeb) {
        js.context.callMethod('open', [url]);
      } else {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open map.')),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error opening map: $e')),
      );
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Reports"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Sign Out",
            onPressed: () async {
              await signOut();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out successfully')),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: reportsRef.orderBy('Time', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          List<QueryDocumentSnapshot> reports = snapshot.data!.docs;

          if (reports.isEmpty) {
            return const Center(child: Text("No reports found"));
          }

          // Sort: Pending SOS first, then other Pending, then Solved
          reports.sort((a, b) {
            final statusA = a['Status'] as String;
            final statusB = b['Status'] as String;
            final typeA = a['Type'] ?? '';
            final typeB = b['Type'] ?? '';

            if (statusA == 'Pending' && typeA == 'SOS') return -1;
            if (statusB == 'Pending' && typeB == 'SOS') return 1;

            if (statusA == statusB) return 0;
            return statusA == 'Pending' ? -1 : 1;
          });

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final id = report.id;
              final geoPoint = report['GeoPoint'] as GeoPoint?;
              final status = report['Status'] as String;
              final type = report['Type'] ?? '';

              // Colors based on type and status
              Color cardColor;
              if (status == 'Pending' && type == 'SOS') {
                cardColor = Colors.redAccent.shade100; // bright red for SOS
              } else if (status == 'Pending') {
                cardColor = Colors.red.shade50;
              } else {
                cardColor = Colors.green.shade50;
              }

              final statusColor = status == 'Pending' ? Colors.red : Colors.green;

              return Card(
                color: cardColor,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(
                    report['Details'] ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Type: $type"),
                      Row(
                        children: [
                          const Text("Location: "),
                          geoPoint != null
                              ? GestureDetector(
                                  onTap: () => openMap(geoPoint),
                                  child: Text(
                                    "${report['Location'] ?? ''}",
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                )
                              : Text("${report['Location'] ?? ''}"),
                        ],
                      ),
                      Text(
                        "Status: $status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                      Text("User: ${report['Username'] ?? ''}"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (status == 'Pending')
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await reportsRef.doc(id).update({'Status': 'Solved'});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Marked as Resolved')),
                              );
                            } catch (e) {
                              print('Error updating status: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          icon: const Icon(Icons.check, color: Colors.white),
                          label: const Text('Mark as Resolved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      if (status == 'Solved')
                        ElevatedButton.icon(
                          onPressed: () async {
                            try {
                              await reportsRef.doc(id).update({'Status': 'Pending'});
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Marked as Unresolved')),
                              );
                            } catch (e) {
                              print('Error updating status: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          },
                          icon: const Icon(Icons.undo, color: Colors.white),
                          label: const Text('Mark as Unresolved'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}