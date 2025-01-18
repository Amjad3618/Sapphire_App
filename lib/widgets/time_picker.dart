import 'package:flutter/material.dart';

class TimePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const TimePickerFormField({
    super.key,
    required this.controller,
    this.labelText = 'Pick a time',
  });

  @override
  _TimePickerFormFieldState createState() => _TimePickerFormFieldState();
}

class _TimePickerFormFieldState extends State<TimePickerFormField> {
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = picked.format(context); // Format and set the picked time
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // Make it read-only to prevent keyboard input
      onTap: () => _selectTime(context), // Open the time picker on tap
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: Icon(Icons.access_time), // Icon indicating time selection
      ),
    );
  }
}
