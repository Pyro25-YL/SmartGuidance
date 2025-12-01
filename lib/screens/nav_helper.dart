import 'package:flutter/material.dart';
import 'placeholder_page.dart';

VoidCallback openPlaceholder(BuildContext context, String title) {
  return () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PlaceholderPage(title: title),
      ),
    );
  };
}
