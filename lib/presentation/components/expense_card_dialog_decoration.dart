import 'package:flutter/material.dart';

import 'colors.dart';

var expenseCardDecoration = InputDecoration(
  filled: true,
  fillColor: const Color.fromARGB(36, 255, 255, 255),
  labelStyle: TextStyle(fontSize: 20, color: Colors.white70),
  hintStyle:
      const TextStyle(fontSize: 15, color: Color.fromARGB(117, 255, 255, 255)),
  errorStyle: TextStyle(color: mainGreen),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: mainGreen)),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: mainGreen)),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: mainGreen)),
  focusedErrorBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(20),
    borderSide: BorderSide(color: mainGreen),
  ),
);
