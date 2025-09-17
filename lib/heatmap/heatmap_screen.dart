import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HeatmapScreen extends StatefulWidget {
  @override
  _HeatmapScreenState createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  // Example data
final List<Map<String, dynamic>> incidents = [
  {
    "userId": "user123",
    "type": "Theft",
    "description": "Wallet stolen near cafeteria",
    "time": "2025-09-16 10:30",
    "location": LatLng(5.3414, 100.2850),
  },
  {
    "userId": "user456",
    "type": "Accident",
    "description": "Minor accident at parking lot",
    "time": "2025-09-16 11:00",
    "location": LatLng(5.3420, 100.2845),
  },
  {
    "userId": "user789",
    "type": "Suspicious Activity",
    "description": "Unknown person loitering near library",
    "time": "2025-09-16 12:15",
    "location": LatLng(5.3408, 100.2840),
  },
  {
    "userId": "user101",
    "type": "Harassment",
    "description": "Verbal harassment reported near dorm",
    "time": "2025-09-16 13:45",
    "location": LatLng(5.3418, 100.2860),
  },
  {
    "userId": "user202",
    "type": "Lost Item",
    "description": "Lost bag reported at canteen",
    "time": "2025-09-16 14:20",
    "location": LatLng(5.3425, 100.2855),
  },
];

  String? selectedUser; // track which marker is active

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Heatmap")),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(5.3414, 100.2850),
          zoom: 17.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: incidents.map((incident) {
              bool isSelected = selectedUser == incident["userId"];
              return Marker(
                width: 40,
                height: 40,
                point: incident["location"],
                builder: (ctx) => GestureDetector(
                  onTap: () async {
                    setState(() {
                      selectedUser = incident["userId"];
                    });

                    // Show dialog and wait until it's closed
                    await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: Text(incident["type"]),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("User ID: ${incident["userId"]}"),
                            Text("Description: ${incident["description"]}"),
                            Text("Time: ${incident["time"]}"),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Close"),
                          )
                        ],
                      ),
                    );

                    // Reset selectedUser so dot shrinks back
                    setState(() {
                      selectedUser = null;
                    });
                  },
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 1.0,
                      end: isSelected ? 1.5 : 1.0,
                    ),
                    duration: const Duration(milliseconds: 300),
                    builder: (context, scale, child) {
                      return Transform.scale(
                        scale: scale,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.7),
                            shape: BoxShape.circle,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}