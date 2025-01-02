import 'package:flutter/material.dart';

import '../widgets/date_picker.dart';
import '../widgets/text_widget.dart';
import '../widgets/time_picker.dart';

class AddAnotherCutOff extends StatefulWidget {
  const AddAnotherCutOff({Key? key}) : super(key: key);

  @override
  State<AddAnotherCutOff> createState() => _AddAnotherCutOffState();
}

class _AddAnotherCutOffState extends State<AddAnotherCutOff> {
  double _fuelLevel = 0.5; // Initial fuel level (50%)
  final TextEditingController _cutOffTimeController = TextEditingController();
  final TextEditingController _cutOffDateController = TextEditingController();
  final TextEditingController _turnOnTimeController = TextEditingController();
  final TextEditingController _turnOnDateController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free resources
    _cutOffTimeController.dispose();
    _cutOffDateController.dispose();
    _turnOnTimeController.dispose();
    _turnOnDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
       
        title: const CustomTextWidget(
          text: "Add Cut off",
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          TextButton(
            onPressed: (){}, 
            child: const Text(
              "Submit",
              style:  TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600
              )
            )
          )
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    // Cut-Off Section
                    _buildSection(
                      TimePickerFormField(
                        controller: _cutOffTimeController,
                        labelText: 'Cut off Time',
                      ),
                      DatePickerFormField(
                        controller: _cutOffDateController,
                        labelText: 'Cut off Date',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Turn-On Section
                    _buildSection(
                      TimePickerFormField(
                        controller: _turnOnTimeController,
                        labelText: 'Turn On Time',
                      ),
                      DatePickerFormField(
                        controller: _turnOnDateController,
                        labelText: 'Turn On Date',
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Fuel Level Circular Selector
                    _buildFuelLevelSelector(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Build a reusable section
  Widget _buildSection(Widget child1, Widget child2) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [child1, const SizedBox(height: 10), child2],
      ),
    );
  }

  // Fuel Level Selector
  Widget _buildFuelLevelSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CustomTextWidget(
            text: "Fuel Level Selector",
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          const SizedBox(height: 10),
          GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                _fuelLevel = (_fuelLevel + details.delta.dy / 300)
                    .clamp(0.0, 1.0);
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _fuelLevel,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey[300],
                    color: Colors.green,
                  ),
                ),
                Text(
                  "${(_fuelLevel * 100).toInt()}%",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CustomTextWidget(
            text: "Selected Fuel Level: ${(_fuelLevel * 100).toInt()}%",
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}