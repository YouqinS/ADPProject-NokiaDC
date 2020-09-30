import 'package:flutter/material.dart';

void navigateToPage(BuildContext context, var page) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return page;
      },
    ),
  );
}