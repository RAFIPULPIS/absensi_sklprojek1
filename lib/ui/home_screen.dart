import 'package:attendance_/ui/absent/absent_screen.dart';
import 'package:attendance_/ui/attend/attend_screen.dart';
import 'package:attendance_/ui/attendance_history/history_screen.dart';
import 'package:attendance_/ui/izin/Form_screen.dart';
import 'package:attendance_/ui/update/update_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        title: const Text(
          "Attendance - Flutter App Admin",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildMenuItem(
              context,
              title: "Attendance Record",
              icon: "assets/images/ic_absent.png",
              screen: AttendScreen(),
            ),
            _buildMenuItem(
              context,
              title: "Absent Record",
              icon: "assets/images/ic_leave.png",
              screen: AbsentScreen(),
            ),
            _buildMenuItem(
              context,
              title: "History",
              icon: "assets/images/ic_history.png",
              screen: const AttendanceHistoryScreen(),
            ),
            _buildMenuItem(
              context,
              title: "Register Form",
              icon: "assets/images/ic_apa.png",
              screen: const StudentRegistrationForm(),
            ),
            _buildMenuItem(
              context,
              title: "Update",
              icon: "assets/images/ic_history.png",
              screen: UpdateScreen(
                docId: "123",
                name: "John Doe",
                date: "2024-03-10",
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blueAccent,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "IDN Boarding School Solo",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, {
    required String title,
    required String icon,
    required Widget screen,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(icon, height: 80, width: 80),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
