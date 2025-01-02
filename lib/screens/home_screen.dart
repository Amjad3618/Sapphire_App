import 'package:flutter/material.dart';

import '../Widgets/add_tile.dart';
import '../utils/colors.dart';
import '../widgets/text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              onPressed: () {},
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Colors.blue, Colors.black]),
                    color: btncolor,
                    border: Border.all(),
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),topRight: Radius.circular(20))),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomTextWidget(
                      text: "Total Hours",
                      color: Colors.white,
                      fontSize: 20,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                        ),
                        Icon(
                          Icons.arrow_downward,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomTextWidget(
                      text: " 68 hrs",
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ],
                )),
            const SizedBox(
              height: 20,
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: 30,
                    itemBuilder: (context, index) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: AddTile(),
                      );
                    }))
          ],
        ),
      ),
    );
  }
}
