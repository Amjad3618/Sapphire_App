import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Services/auth_services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const CustomTextWidget(
          text: "H O M E",
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              _authService
                  .signOut(); // Call the signOut method from AuthService
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
            // Container(
            //   height: 100,
            //   width: double.infinity,
            //   decoration: BoxDecoration(
            //     gradient: const LinearGradient(
            //       colors: [Colors.blue, Colors.black],
            //     ),
            //     color: btncolor,
            //     border: Border.all(),
            //     borderRadius: const BorderRadius.only(
            //       bottomLeft: Radius.circular(20),
            //       topRight: Radius.circular(20),
            //     ),
            //   ),
            //   child: const Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       CustomTextWidget(
            //         text: "Total Hours",
            //         color: Colors.white,
            //         fontSize: 20,
            //       ),
            //       SizedBox(width: 10),
            //       Row(
            //         children: [
            //           Icon(
            //             Icons.arrow_upward,
            //             color: Colors.green,
            //           ),
            //           Icon(
            //             Icons.arrow_downward,
            //             color: Colors.red,
            //           ),
            //         ],
            //       ),
            //       SizedBox(width: 10),
            //       CustomTextWidget(
            //         text: " 68 hrs",
            //         color: Colors.white,
            //         fontSize: 20,
            //       ),
            //     ],
            //   ),
            // ),
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
                    reverse: true,
                    itemCount: cutoffData.length,
                    itemBuilder: (context, index) {
                      final data =
                          cutoffData[index].data() as Map<String, dynamic>;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AddTile(
                          email: data['email'] ?? 'N/A',
                          cutoffTime: data['cutoffTime'] ?? 'N/A',
                          cutoffDate: data['cutoffDate'] ?? 'N/A',
                          turnOnTime: data['turnOnTime'] ?? 'N/A',
                          turnOnDate: data['turnOnDate'] ?? 'N/A',
                          fuelLevel: data['fuelLevel'] != null
                              ? double.tryParse(data['fuelLevel'].toString()) ??
                                  0.0
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
