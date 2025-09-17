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
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/heatmap/heatmap_screen.dart';

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
            const Spacer(),
            const Text(
              'Campus Safety',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const Spacer(flex: 2),
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
          // 🔥 Heatmap from other file
          Expanded(
            flex: 1,
            child: HeatmapScreen(),
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
                  SnackBar(content: Text('Report submitted: ${reportCtrl.text}')),
                );
                Navigator.pop(context); // go back to HomeScreen after submit
              },
              child: Text('Submit Report'),
            ),
          ],
        ),
      ),
    );
  }
}
