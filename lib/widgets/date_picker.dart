import 'package:flutter/material.dart';

class DatePickerFormField extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;

  const DatePickerFormField({
    Key? key,
    required this.controller,
    this.labelText = 'Pick a date',
  }) : super(key: key);

  @override
  _DatePickerFormFieldState createState() => _DatePickerFormFieldState();
}

class _DatePickerFormFieldState extends State<DatePickerFormField> {
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        widget.controller.text = '${picked.year}-${picked.month}-${picked.day}'; // Format the selected date
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true, // Make it read-only to prevent keyboard input
      onTap: () => _selectDate(context), // Open the date picker on tap
      decoration: InputDecoration(
        labelText: widget.labelText,
        suffixIcon: Icon(Icons.calendar_today), // Icon indicating date selection
      ),
    );
  }
}
