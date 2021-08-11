import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptativeTextField extends StatelessWidget {
  final bool plataformaIos;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final Function(String) onSubmitted;
  final String label;

  AdaptativeTextField({
    required this.plataformaIos,
    required this.controller,
    this.keyboardType = TextInputType.text,
    required this.onSubmitted,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return plataformaIos
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: CupertinoTextField(
              controller: controller,
              keyboardType: keyboardType,
              onSubmitted: (_) => onSubmitted,
              placeholder: label,
              padding: EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
            ),
          )
        : TextField(
            controller: controller,
            keyboardType: keyboardType,
            onSubmitted: (_) => onSubmitted,
            decoration: InputDecoration(
              labelText: label,
            ),
          );
  }
}
