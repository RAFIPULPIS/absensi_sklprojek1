import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance History"),
        backgroundColor: Colors.blueAccent,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('attendance') // DULUNYA 'attendance_history', SEKARANG UDAH BENER
            .orderBy('created_at', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No attendance history available."));
          }
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;

              // Format tanggal dengan baik
              String formattedDate = "Unknown";
              if (data['created_at'] != null) {
                formattedDate = DateFormat('dd MMM yyyy, HH:mm').format(
                  (data['created_at'] as Timestamp).toDate(),
                );
              }

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    title: Text(
                      data['name'] ?? "Unknown",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("📌 Status: ${data['status'] ?? 'N/A'}"),
                        Text("⏰ Check-in: ${data['check_in'] ?? 'N/A'}"),
                        Text("🏁 Check-out: ${data['check_out'] ?? 'N/A'}"),
                        if (data['notes'] != null && data['notes'].isNotEmpty)
                          Text("📝 Notes: ${data['notes']}"),
                        Text("📅 Date: $formattedDate"),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
