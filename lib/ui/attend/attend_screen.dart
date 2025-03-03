import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:attendance_/ui/home_screen.dart';

class AttendScreen extends StatefulWidget {
  const AttendScreen({super.key});

  @override
  State<AttendScreen> createState() => _AttendScreenState();
}

class _AttendScreenState extends State<AttendScreen> {
  var categoriesList = [
    "Please Choose:",
    "Present",
    "Late",
    "Permission",
    "Sick",
    "Absent"
  ];

  final controllerName = TextEditingController();
  final controllerNotes = TextEditingController();
  final CollectionReference dataCollection =
      FirebaseFirestore.instance.collection('attendance');

  String dropValueCategories = "Please Choose:";
  String checkInTime = "Select Time";
  String checkOutTime = "Select Time";

  Future<void> selectTime(BuildContext context, bool isCheckIn) async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        String formattedTime = pickedTime.format(context);
        if (isCheckIn) {
          checkInTime = formattedTime;
        } else {
          checkOutTime = formattedTime;
        }
      });
    }
  }

  Future<void> submitAttendance() async {
    if (controllerName.text.isEmpty ||
        dropValueCategories == "Please Choose:" ||
        checkInTime == "Select Time" ||
        checkOutTime == "Select Time") {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please complete all required fields!"),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    try {
      await dataCollection.add({
        'name': controllerName.text,
        'status': dropValueCategories,
        'check_in': checkInTime,
        'check_out': checkOutTime,
        'notes': controllerNotes.text,
        'created_at': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Attendance recorded successfully!"),
        backgroundColor: Colors.green,
      ));

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.redAccent,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance Screen"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controllerName,
              decoration: const InputDecoration(labelText: "Your Name"),
            ),
            DropdownButtonFormField(
              value: dropValueCategories,
              items: categoriesList.map((String category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  dropValueCategories = value.toString();
                });
              },
              decoration: const InputDecoration(labelText: "Status"),
            ),
            ListTile(
              title: Text("Check-in Time: $checkInTime"),
              trailing: const Icon(Icons.access_time),
              onTap: () => selectTime(context, true),
            ),
            ListTile(
              title: Text("Check-out Time: $checkOutTime"),
              trailing: const Icon(Icons.access_time),
              onTap: () => selectTime(context, false),
            ),
            TextField(
              controller: controllerNotes,
              decoration: const InputDecoration(labelText: "Additional Notes (Optional)"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: submitAttendance,
              child: const Text("Submit Attendance"),
            ),
          ],
        ),
      ),
    );
  }
}
  