import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({
    super.key,
    this.controller,
    this.validator,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: const TextStyle(color: AppColors.white),
      obscureText: _obscure,
      autofillHints: const [AutofillHints.password],
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      onFieldSubmitted: widget.onSubmitted,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        suffixIcon: ExcludeFocus(
          child: IconButton(
            onPressed: () => setState(() => _obscure = !_obscure),
            icon: Icon(
              _obscure ? Icons.visibility : Icons.visibility_off,
            ),
          ),
        ),
      ),
    );
  }
}
