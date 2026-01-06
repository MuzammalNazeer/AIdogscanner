
import 'package:dog_breed/Valid/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/utils.dart';

class CommonInputField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode currentFocusNode;
  final FocusNode? nextFocusNode;
  final FormFieldValidator<String> validator;
  final String hintText;
  final Icon? prefixIcon;
  final IconData? suffixIcon;
  final bool obscureText;
  final bool isEnabled;

  final ValueChanged<String>?onChanged;
  final String? validationMessage;
  final IconData? errorIcon;
  const CommonInputField({
    super.key,
    required this.controller,
    required this.currentFocusNode,
    this.nextFocusNode,
    required this.validator,
    required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.isEnabled = true,
    this.validationMessage,
    this.errorIcon, this.onChanged,
  });

  @override
  State<CommonInputField> createState() => _CommonInputFieldState();
}

class _CommonInputFieldState extends State<CommonInputField> {
  late bool _isObscure;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 55.h,
          width: double.infinity,
          child: TextFormField(
            controller: widget.controller,
            focusNode: widget.currentFocusNode,
            obscureText: _isObscure,
            enabled: widget.isEnabled,
            decoration: InputDecoration(
                errorStyle: const TextStyle(height: 0, fontSize: 0),
                fillColor: const Color(0xFFF5F5F5),
                filled: true,
                prefixIcon: widget.prefixIcon,
                suffixIcon: widget.obscureText
                    ? IconButton(
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  },
                )
                    : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
                hintText: widget.hintText,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: _hasError ? Colors.red : AppColors.whiteSmoke,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(9),
                    borderSide: const BorderSide(
                        color: AppColors.whiteSmoke
                    )
                )
            ),
            onFieldSubmitted: (_) {
              Utils.fieldFocusChange(
                context,
                widget.currentFocusNode,
                widget.nextFocusNode!,
              );
            },
            validator: (value) {
              final error = widget.validator(value);
              setState(() {
                _hasError = error != null;
              });
              return error;
            },
          ),
        ),
        if (_hasError && widget.validationMessage != null)
          Row(
            children: [
              Icon(widget.errorIcon ?? Icons.error_outline, color: Colors.red),
              SizedBox(width: 5.w),
              Expanded(
                child: Text(
                  widget.validationMessage!,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),

      ],
    );
  }
}





// import 'package:dog_breed/Valid/AppColors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../../utils/utils.dart';
//
// class CommonInputField extends StatefulWidget {
//   final TextEditingController controller;
//   final FocusNode currentFocusNode;
//   final FocusNode? nextFocusNode;
//   final FormFieldValidator<String> validator;
//   final String hintText;
//   final Icon? prefixIcon;
//   final IconData? suffixIcon;
//   final bool obscureText;
//   final bool isEnabled;
//
//   final ValueChanged<String>?onChanged;
//   final String? validationMessage;
//   final IconData? errorIcon;
//   const CommonInputField({
//     super.key,
//     required this.controller,
//     required this.currentFocusNode,
//     this.nextFocusNode,
//     required this.validator,
//     required this.hintText,
//     this.prefixIcon,
//     this.suffixIcon,
//     this.obscureText = false,
//     this.isEnabled = true,
//     this.validationMessage,
//     this.errorIcon, this.onChanged,
//   });
//
//   @override
//   State<CommonInputField> createState() => _CommonInputFieldState();
// }
//
// class _CommonInputFieldState extends State<CommonInputField> {
//   late bool _isObscure;
//   bool _hasError = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _isObscure = widget.obscureText;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         SizedBox(
//           height: 45,
//           width: double.infinity,
//           child: TextFormField(
//             controller: widget.controller,
//             focusNode: widget.currentFocusNode,
//             obscureText: _isObscure,
//             enabled: widget.isEnabled,
//             decoration: InputDecoration(
//                 fillColor: const Color(0xFFF5F5F5),
//                 filled: true,
//                 prefixIcon: widget.prefixIcon,
//               suffixIcon: widget.obscureText
//                   ? IconButton(
//                 icon: Icon(
//                   _isObscure ? Icons.visibility : Icons.visibility_off,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _isObscure = !_isObscure;
//                   });
//                 },
//               )
//                   : (widget.suffixIcon != null ? Icon(widget.suffixIcon) : null),
//               hintText: widget.hintText,
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8),
//                 borderSide: BorderSide(
//                   color: _hasError ? Colors.red : AppColors.whiteSmoke,
//                 ),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(9),
//                 borderSide: const BorderSide(
//                   color: AppColors.whiteSmoke
//                 )
//               )
//             ),
//             onFieldSubmitted: (_) {
//               Utils.fieldFocusChange(
//                 context,
//                 widget.currentFocusNode,
//                 widget.nextFocusNode!,
//               );
//             },
//             validator: (value) {
//               final error = widget.validator(value);
//               setState(() {
//                 _hasError = error != null;
//               });
//               return error;
//             },
//           ),
//         ),
//         if (_hasError && widget.validationMessage != null)
//           Row(
//             children: [
//               Icon(widget.errorIcon ?? Icons.error_outline, color: Colors.red),
//                SizedBox(width: 5.w),
//               Expanded(
//                 child: Text(
//                   widget.validationMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               ),
//             ],
//           ),
//
//       ],
//     );
//   }
// }
//
//
