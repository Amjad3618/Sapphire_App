import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Services/auth_services.dart';
import '../models/gen_model.dart';
import '../widgets/date_picker.dart';
import '../widgets/text_widget.dart';
import '../widgets/time_picker.dart';

class AddAnotherCutOff extends StatefulWidget {
  const AddAnotherCutOff({super.key});

  @override
  State<AddAnotherCutOff> createState() => _AddAnotherCutOffState();
}

class _AddAnotherCutOffState extends State<AddAnotherCutOff> {
 double _fuelLevel = 0.5;
  final TextEditingController _cutOffTimeController = TextEditingController();
  final TextEditingController _cutOffDateController = TextEditingController();
  final TextEditingController _turnOnTimeController = TextEditingController();
  final TextEditingController _turnOnDateController = TextEditingController();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();
  bool _isLoading = false;

  @override
  void dispose() {
    _cutOffTimeController.dispose();
    _cutOffDateController.dispose();
    _turnOnTimeController.dispose();
    _turnOnDateController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_validateInputs()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Create GenModel instance
        final genData = GenModel(
          email: _authService.currentUser.value?.email,
          name: _authService.currentUser.value!.displayName,
          cutoffTime: _cutOffTimeController.text,
          cutoffDate: _cutOffDateController.text,
          turnOnTime: _turnOnTimeController.text,
          turnOnDate: _turnOnDateController.text,
          fuelLevel: (_fuelLevel * 100).toInt(),
          addonid: DateTime.now().millisecondsSinceEpoch.toString(), // Unique ID
        );

        // Store in Firebase
        await _firestore
            .collection('cutoffs')
            .doc(genData.addonid)
            .set(genData.toJson());

        Get.snackbar(
          'Success',
          'Cut-off schedule saved successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.1),
          colorText: Colors.green,
        );

        // Clear form
        _clearForm();
      } catch (e) {
        Get.snackbar(
          'Error',
          'Failed to save cut-off schedule: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  bool _validateInputs() {
    if (_cutOffTimeController.text.isEmpty ||
        _cutOffDateController.text.isEmpty ||
        _turnOnTimeController.text.isEmpty ||
        _turnOnDateController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
      return false;
    }
    return true;
  }

  void _clearForm() {
    _cutOffTimeController.clear();
    _cutOffDateController.clear();
    _turnOnTimeController.clear();
    _turnOnDateController.clear();
    setState(() {
      _fuelLevel = 0.5;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
       
        title: const CustomTextWidget(
          text: "Add Cut off",
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              style: TextButton.styleFrom(
                elevation: 50,
                side: const BorderSide(color: Colors.black, width: 1.0),
                backgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isLoading ? null : _submitData,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      ),
                    )
                  : const Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
            ),
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