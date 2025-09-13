import 'package:flutter/material.dart';
import 'package:goods/domain/models/common_model.dart';
import 'package:goods/ui/theme/colors.dart';
import 'package:goods/ui/theme/text_styles.dart';

class AutocompleteTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData? prefixIcon;
  final List<CommonModel> suggestions;
  final Function(String) onSuggestionSelected;
  final String? Function(String?)? validator;

  const AutocompleteTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIcon = null,
    required this.suggestions,
    required this.onSuggestionSelected,
    this.validator,
  });

  @override
  State<AutocompleteTextFormField> createState() =>
      _AutocompleteTextFormFieldState();
}

class _AutocompleteTextFormFieldState extends State<AutocompleteTextFormField> {
  final FocusNode _focusNode = FocusNode();
  List<CommonModel> _filteredSuggestions = [];
  bool _isSuggestionsVisible = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isSuggestionsVisible = _focusNode.hasFocus;
        if (_focusNode.hasFocus) {
          _filterSuggestions();
        }
      });
    });

    widget.controller.addListener(() {
      _filterSuggestions();
    });

    // Initialize with all suggestions if field is empty
    _filteredSuggestions = widget.suggestions;
  }

  @override
  void dispose() {
    _focusNode.dispose();
    widget.controller.removeListener(_filterSuggestions);
    super.dispose();
  }

  void _filterSuggestions() {
    final query = widget.controller.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredSuggestions = widget.suggestions;
      } else {
        _filteredSuggestions = widget.suggestions
            .where(
              (suggestion) => suggestion.name.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  Widget _buildSuggestionsList() {
    return Material(
      color: primary300,
      borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 150),
        child: ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: _filteredSuggestions.length,
          itemBuilder: (context, index) {
            final suggestion = _filteredSuggestions[index];
            return ListTile(
              title: Text(suggestion.name),
              onTap: () {
                widget.onSuggestionSelected(suggestion.id);
                widget.controller.text = suggestion.name;
                // Hide suggestions and remove focus
                _focusNode.unfocus();
              },
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: bodyMedium.copyWith(color: grey700),
            prefixIcon: widget.prefixIcon != null
                ? Icon(widget.prefixIcon, color: grey700)
                : null,
            suffixIcon: Icon(
              _isSuggestionsVisible
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              color: grey700,
            ),
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
        ),

        if (_isSuggestionsVisible && _filteredSuggestions.isNotEmpty) ...[
          const SizedBox(height: 8),
          _buildSuggestionsList(),
        ],
      ],
    );
  }
}
