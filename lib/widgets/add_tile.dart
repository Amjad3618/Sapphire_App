import 'package:flutter/material.dart';
import '../utils/colors.dart';
import 'text_widget.dart';

class AddTile extends StatefulWidget {
  final String email;
  final String cutoffTime;
  final String turnOnTime;
  final String cutoffDate;
  final String turnOnDate;
  final double fuelLevel; // Now expects value between 0-100

  const AddTile({
    super.key,
    required this.email,
    required this.cutoffTime,
    required this.turnOnTime,
    required this.cutoffDate,
    required this.turnOnDate,
    required this.fuelLevel,
  });

  @override
  State<AddTile> createState() => _AddTileState();
}

class _AddTileState extends State<AddTile> {
  @override
  Widget build(BuildContext context) {
    // Convert fuel level to decimal for CircularProgressIndicator
    final progressValue = widget.fuelLevel / 100;
    
    return Container(
      height: MediaQuery.of(context).size.height*0.3,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage("assets/man.png")
                ),
                const SizedBox(width: 10),
                CustomTextWidget(
                  text: widget.email,
                  fontSize: 20,
                  color: btncolor,
                  fontWeight: FontWeight.bold,
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          strokeWidth: 5,
                          value: progressValue, // Using converted value here
                          backgroundColor: Colors.grey[200],
                          color: Colors.green,
                        ),
                      ),
                      Text(
                        '${widget.fuelLevel.toInt()}%', // Display original value directly
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextWidget(
                      text: "Cut-off Time",
                      fontSize: 18,
                      color: Color.fromARGB(255, 168, 13, 2),
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: widget.cutoffTime,
                      fontSize: 16,
                      color: btncolor,
                      fontWeight: FontWeight.w600,
                    ),
                    const CustomTextWidget(
                      text: "Cut-off Date",
                      fontSize: 18,
                      color: Color.fromARGB(255, 199, 15, 1),
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: widget.cutoffDate,
                      fontSize: 16,
                      color: btncolor,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomTextWidget(
                      text: "Return Time",
                      fontSize: 18,
                      color: btncolor,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: widget.turnOnTime,
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomTextWidget(
                      text: "Return Date",
                      fontSize: 18,
                      color: btncolor,
                      fontWeight: FontWeight.bold,
                    ),
                    CustomTextWidget(
                      text: widget.turnOnDate,
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}