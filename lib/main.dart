import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_application_1/auth_pages/loginPage.dart';
import 'package:flutter_application_1/auth_pages/singupPage.dart';
import 'package:flutter_application_1/auth_pages/authPage.dart';

import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/comp_manager/ButtonMng.dart';

import 'report_pages/report_screen.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(CampusSafetyApp());
}

class CampusSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Safety',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AuthPage(),
    );
  }
}

// ================= Sign out =================

void signOut() {
  FirebaseAuth.instance.signOut();
}

// ================= Home Screen =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<LatLng> userPoints = [
    LatLng(5.3414, 100.2850),
    LatLng(5.3420, 100.2845),
    LatLng(5.3408, 100.2840),
    LatLng(5.3418, 100.2860),
    LatLng(5.3410, 100.2855),
  ];

  String userName = '';

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (doc.exists) {
          setState(() {
            userName = doc.data()?['name'] ?? '';
          });
        }
      }
    } catch (e) {
      print("Error fetching user name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Row(
    children: [
      // Username on the left
      Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.4,
        ),

        child: Text(
          'Hello, $userName',
          style: const TextStyle(fontSize: 14),
          overflow: TextOverflow.ellipsis,
        ),

      ),

      const Spacer(), // pushes the title to center
      const Text(
        'Campus Safety',
        style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      const Spacer(flex: 2), // keeps the title centered with space for logout button
    ],
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () async {
        final shouldLogout = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Sign Out"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Cancel")),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Sign Out")),
            ],
          ),
        );

        if (shouldLogout == true) {
          await FirebaseAuth.instance.signOut();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Signed out successfully')));
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => AuthPage()));
        }
      },
    ),
  ],
),
      body: Column(
        children: [
          // Top Half: Map
          Expanded(
            flex: 1,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(5.3414, 100.2850),
                zoom: 17.0,
                maxZoom: 19.0,
                minZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                  subdomains: ['a', 'b', 'c'],
                  userAgentPackageName: 'com.example.flutter_application_1',
                ),
                MarkerLayer(
                  markers: userPoints.map((point) {
                    return Marker(
                      width: 30,
                      height: 30,
                      point: point,
                      builder: (ctx) => Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.7),
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // Bottom Half: Buttons
          Expanded(
            flex: 1,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(150, 150),
                      shape: const CircleBorder(),
                    ),

                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('SOS Sent!')),
                      );
                    },
                    child: const Text('SOS', style: TextStyle(fontSize: 24)),
                  ),

                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => ReportScreen()),
                      );
                    },
                    child: const Text('Report Incident'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// ================= Report Screen =================


// class ReportScreen extends StatelessWidget {
//   final TextEditingController reportCtrl = TextEditingController();
//   String category = "Suspicious";

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Report Incident')),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           children: [
//             DropdownButton<String>(
//               value: category,
//               items: ["Suspicious", "Harassment", "Theft"].map((e) {
//                 return DropdownMenuItem(value: e, child: Text(e));
//               }).toList(),
//               onChanged: (val) {},
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: reportCtrl,
//               decoration: InputDecoration(labelText: "Describe incident"),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text('Report submitted: ${reportCtrl.text}')),
//                 );
//                 Navigator.pop(context); // go back to HomeScreen after submit
//               },
//               child: Text('Submit Report'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ================= Heatmap Screen =================
class HeatmapScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // For hackathon demo, we’ll just show placeholder
    return Scaffold(
      appBar: AppBar(title: Text('Heatmap')),
      body: Center(
        child: Text('Heatmap will appear here', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}