// --- Fidget Data ---

import 'package:flutter/material.dart';
import 'screens/profile_feature.dart';
import 'screens/mood_screen.dart';
import 'screens/report_screen.dart';
import 'screens/map_screen.dart';
import 'screens/sos_screen.dart';
import 'services/auth_service.dart';

// --- Fidget Data ---
const List<String> _tipsList = [
  "Take a deep breath and relax.",
  "Stay hydrated! Drink some water.",
  "Reach out to a friend today.",
  "Organize your study space for better focus.",
  "Remember, it's okay to ask for help.",
];

const List<String> _moodEmojis = ["😊", "😔", "😠", "😨", "😐"];

const List<String> _deadlines = [
  "Assignment 1 - Due Sep 5",
  "Midterm Exam - Sep 12",
  "Group Project - Sep 20",
];

const List<String> _selfCare = [
  "Drink water",
  "Take a walk",
  "Meditate",
  "Read for fun",
  "Get enough sleep",
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CampusSafetyApp());
}

class CampusSafetyApp extends StatelessWidget {
  const CampusSafetyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Campus Safety',
      theme: ThemeData(primarySwatch: Colors.red),
      home: LoginScreen(),
      routes: {
        '/main': (context) => const MainScreenWrapper(),
      },
    );
  }
}

// ================= Main Screen Wrapper (with Bottom Navigation) =================
class MainScreenWrapper extends StatefulWidget {
  const MainScreenWrapper({super.key});

  @override
  State<MainScreenWrapper> createState() => _MainScreenWrapperState();
}

class _MainScreenWrapperState extends State<MainScreenWrapper> {
  int _selectedIndex = 0;

  // List of widgets to display in the body based on selection
  // Note: ReportScreen and HeatmapScreen are kept separate for now,
  // they can be added as tabs later if desired.
  static final List<Widget> _widgetOptions = <Widget>[
    const SosScreen(),         // SOS Widget
    const HeatmapScreen(),     // Safety Map Widget
    const MoodDiaryScreen(),   // Mood Widget
    const ReportScreen(),      // Report Widget
    const ProfileScreen(),     // Profile Widget
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( // Using IndexedStack to preserve state of screens
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.shield),
            label: 'SOS',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Safety Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.report),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// ================= Login Screen =================
class LoginScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final email = emailCtrl.text;
                final password = passCtrl.text;
                final success = await AuthService.login(email, password);
                
                if (success) {
                  // Use the context after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacementNamed(context, '/main');
                  });
                } else {
                  // Use the context after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Login failed. Please try again.')),
                    );
                  });
                }
              },
              child: const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignupScreen()),
                );
              },
              child: const Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= Signup Screen =================
class SignupScreen extends StatelessWidget {
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController passCtrl = TextEditingController();

  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailCtrl,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final email = emailCtrl.text;
                final password = passCtrl.text;
                final success = await AuthService.signup(email, password);
                
                if (success) {
                  // Use the context after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreenWrapper()),
                    );
                  });
                } else {
                  // Use the context after the async gap
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signup failed. Please try again.')),
                    );
                  });
                }
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= HomeScreenContent (Extracted from original HomeScreen) =================
class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    // This Scaffold is important if HomeScreenContent needs its own AppBar
    // when it's displayed as a tab.
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Safety Home'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Quick Tips Card
              Card(
                color: Colors.yellow[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text('Tip of the Day', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      const SizedBox(height: 8),
                      Text(_tipsList[DateTime.now().day % _tipsList.length], style: const TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 2. Daily Mood Tracker
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      const Text('How are you feeling today?', style: TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      ..._moodEmojis.map((emoji) => IconButton(
                        icon: Text(emoji, style: const TextStyle(fontSize: 24)),
                        onPressed: () {
                          // You can add logic to save the selected mood
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Mood selected: $emoji')),
                          );
                        },
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 3. Upcoming Deadlines (static for demo)
              Card(
                color: Colors.green[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Upcoming Deadlines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      ..._deadlines.map((d) => Text('• $d', style: const TextStyle(fontSize: 15))),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 4. Self-Care Checklist
              Card(
                color: Colors.purple[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Self-Care Checklist', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 8),
                      ..._selfCare.map((item) => Row(
                        children: [
                          Checkbox(value: false, onChanged: (v) {}),
                          Text(item),
                        ],
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // 5. Peer Support Chat Shortcut
              Card(
                color: Colors.orange[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Need to talk? Peer Support Chat', style: TextStyle(fontSize: 16)),
                      ElevatedButton(
                        onPressed: () {
                          // Placeholder for chat navigation
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Opening Peer Support Chat...')),
                          );
                        },
                        child: const Text('Chat'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // === SOS Button ===
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(150, 150),
                  shape: const CircleBorder(),
                ),
                onPressed: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('SOS Sent!')));
                },
                child: const Text('SOS', style: TextStyle(fontSize: 24, color: Colors.white)),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ReportScreen()),
                  );
                },
                child: const Text('Report Incident'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HeatmapScreen()),
                  );
                },
                child: const Text('View Heatmap'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
