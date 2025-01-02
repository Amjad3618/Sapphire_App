import 'package:flutter/material.dart';


import '../utils/colors.dart';
import 'text_widget.dart';

class AddTile extends StatefulWidget {
  const AddTile({super.key});

  @override
  State<AddTile> createState() => _AddTileState();
}

class _AddTileState extends State<AddTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white
                 ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(radius: 30, backgroundColor: Colors.grey,),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomTextWidget(
                          text: "User name",
                          fontSize: 30,
                          color:btncolor,
                          fontWeight: FontWeight.bold,
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(
                            strokeWidth: 5,
                            value: 50,
                            color: Colors.amber,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextWidget(
                              text: "Cutt of time ",
                              fontSize: 20,
                              color: Color.fromARGB(255, 168, 13, 2),
                              fontWeight: FontWeight.bold,
                            ),
                            CustomTextWidget(
                              text: "10:30 ",
                              fontSize: 15,
                              color: btncolor,
                              fontWeight: FontWeight.bold,
                            ),
                            const CustomTextWidget(
                              text: "Cutt of Date ",
                              fontSize: 20,
                              color: Color.fromARGB(255, 199, 15, 1),
                              fontWeight: FontWeight.bold,
                            ),
                            CustomTextWidget(
                              text: "20/12/2024 ",
                              fontSize: 15,
                              color: btncolor,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            CustomTextWidget(
                              text: "Return time ",
                              fontSize: 20,
                              color: btncolor,
                              fontWeight: FontWeight.bold,
                            ),
                            const CustomTextWidget(
                              text: "10:30 ",
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            CustomTextWidget(
                              text: "Return Date  ",
                              fontSize: 20,
                              color: btncolor,
                              fontWeight: FontWeight.bold,
                            ),
                            const CustomTextWidget(
                              text: "20/12/2024 ",
                              fontSize: 15,
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
            );
  }
}