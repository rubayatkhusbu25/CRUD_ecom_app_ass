import 'package:flutter/material.dart';

class TextfieldWidget extends StatelessWidget {

  final TextEditingController textEditingController;
  final String label;
  TextfieldWidget({super.key, required this.textEditingController, required this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(labelText: label),
    );
  }
}
