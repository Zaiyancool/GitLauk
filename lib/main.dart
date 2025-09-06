import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter_application_1/auth_pages/loginPage.dart';
import 'package:flutter_application_1/auth_pages/singupPage.dart';
import 'package:flutter_application_1/auth_pages/authPage.dart';

import 'package:flutter_application_1/comp_manager/TextFileMng.dart';
import 'package:flutter_application_1/comp_manager/ButtonMng.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

// ================= Login Screen =================
// class LoginScreen extends StatelessWidget {
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Campus Safety', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
//             SizedBox(height: 40),
//             TextField(
//               controller: emailCtrl,
//               decoration: InputDecoration(labelText: 'Email'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: passCtrl,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                     context, MaterialPageRoute(builder: (_) => HomeScreen()));
//               },
//               child: Text('Login'),
//             ),
//             SizedBox(height: 16),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (_) => SignupScreen()));
//               },
//               child: Text('Sign Up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ================= Signup Screen =================

// class SignupScreen extends StatelessWidget {
//   final TextEditingController emailCtrl = TextEditingController();
//   final TextEditingController passCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Sign Up')),
//       body: Padding(
//         padding: EdgeInsets.all(24),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: emailCtrl,
//               decoration: InputDecoration(labelText: 'email'),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               controller: passCtrl,
//               obscureText: true,
//               decoration: InputDecoration(labelText: 'Password'),
//             ),
//             SizedBox(height: 32),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                     context, MaterialPageRoute(builder: (_) => HomeScreen()));
//               },
//               child: Text('Create Account'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// ================= Home Screen =================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Simulated user locations around USM Penang
  final List<LatLng> userPoints = [
    LatLng(5.3414, 100.2850),
    LatLng(5.3420, 100.2845),
    LatLng(5.3408, 100.2840),
    LatLng(5.3418, 100.2860),
    LatLng(5.3410, 100.2855),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Campus Safety')),
      body: Column(
        children: [
          // Top Half: Map
          Expanded(
            flex: 1,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(5.3414, 100.2850), // USM Penang center
                zoom: 17.0, // higher zoom to see the campus clearly
                maxZoom: 19.0,
                minZoom: 14.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                      minimumSize: Size(150, 150),
                      shape: CircleBorder(),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('SOS Sent!')),
                      );
                    },
                    child: Text('SOS', style: TextStyle(fontSize: 24)),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Report Incident Clicked')),
                      );
                    },
                    child: Text('Report Incident'),
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
class ReportScreen extends StatelessWidget {
  final TextEditingController reportCtrl = TextEditingController();
  String category = "Suspicious";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Report Incident')),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            DropdownButton<String>(
              value: category,
              items: ["Suspicious", "Harassment", "Theft"].map((e) {
                return DropdownMenuItem(value: e, child: Text(e));
              }).toList(),
              onChanged: (val) {},
            ),
            SizedBox(height: 16),
            TextField(
              controller: reportCtrl,
              decoration: InputDecoration(labelText: "Describe incident"),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Report submitted: ${reportCtrl.text}')));
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}

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