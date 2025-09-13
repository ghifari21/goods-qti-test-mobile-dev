import 'package:flutter/material.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';

class SearchTextField extends StatelessWidget {
  final Function(String) onChangedEvent;

  const SearchTextField({super.key, required this.onChangedEvent});

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChangedEvent,
      decoration: InputDecoration(
        hintText: 'Search assets',
        hintStyle: bodyMedium.copyWith(color: grey700),
        suffixIcon: Icon(Icons.search, color: grey700),
        filled: true,
        fillColor: primary300,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: primary500, width: 1.1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(color: primary800, width: 1.1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: red400, width: 1.1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: const BorderSide(color: red400, width: 1.1),
        ),
        errorStyle: bodySmall.copyWith(color: red400),
      ),
    );
  }
}
