// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Services/auth_services.dart';
import '../Services/pdf services.dart';
import '../Widgets/add_tile.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _authService = Get.put(AuthService());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
Future<void> _showDownloadConfirmation() async {
  // First show the confirmation dialog
  bool? shouldDownload = await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Download PDF Report'),
        content: const Text('Do you want to download the PDF report?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );

  // If user didn't select yes, return
  if (shouldDownload != true || !context.mounted) return;

  // Show a persistent loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return const Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Generating PDF...'),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );

  try {
    // Fetch data
    final snapshot = await _firestore
        .collection('cutoffs')
        .orderBy('cutoffDate', descending: true)
        .get();

    if (!context.mounted) return;

    // Pop the loading dialog
    Navigator.of(context).pop();

    // Generate PDF
    if (snapshot.docs.isNotEmpty) {
      await PDFService.generatePDF(snapshot.docs, context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No data available to generate PDF'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  } catch (e) {
    // Make sure we're still mounted
    if (!context.mounted) return;

    // Pop the loading dialog if it's still showing
    Navigator.of(context).pop();

    // Show error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error generating PDF: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
Future<void> _showLogoutConfirmation() async {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            child: const Text('No'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
            },
          ),
          TextButton(
            child: const Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog
              _authService.signOut(); // Sign out the user
            },
          ),
        ],
      );
    },
  );
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomTextWidget(
          text: "S A P P H I R E",
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              await _showDownloadConfirmation();
            },
            icon: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {
              _showLogoutConfirmation();
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('cutoffs').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: CustomTextWidget(
                        text: "No data available",
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    );
                  }

                  final cutoffData = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: cutoffData.length,
                    itemBuilder: (context, index) {
                      final data = cutoffData[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AddTile(
                          email: (data['email'] ?? 'N/A').toString().split('@')[0],
                          cutoffTime: data['cutoffTime'] ?? 'N/A',
                          cutoffDate: data['cutoffDate'] ?? 'N/A',
                          turnOnTime: data['turnOnTime'] ?? 'N/A',
                          turnOnDate: data['turnOnDate'] ?? 'N/A',
                          fuelLevel: data['fuelLevel'] != null
                              ? double.tryParse(data['fuelLevel'].toString()) ?? 0.0
                              : 0.0,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}