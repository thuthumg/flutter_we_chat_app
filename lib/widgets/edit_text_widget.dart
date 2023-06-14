import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:we_chat_app/resources/colors.dart';


class EditTextWidget extends StatefulWidget {
  final String editTextName;
  final String hintTextName;
  final String editTextType;

  EditTextWidget({
    super.key,
    required this.editTextName,
    required this.hintTextName,
    required this.editTextType,
  });

  @override
  State<EditTextWidget> createState() => _EditTextWidgetState();
}

class _EditTextWidgetState extends State<EditTextWidget> {
  TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      inputFormatters: [
        (widget.editTextType == "number")? FilteringTextInputFormatter.allow(RegExp(r'[0-9]')) : FilteringTextInputFormatter.allow(RegExp(r'[A-Z,0-9,a-z]')),
        // Only allow numbers
      ],
      keyboardType: (widget.editTextType == "number")? TextInputType.number :
      (widget.editTextType == "password")?
      TextInputType.visiblePassword :TextInputType.text,
      decoration: InputDecoration(
         labelText: widget.hintTextName,
       // hintText: widget.hintTextName ,//
        labelStyle: TextStyle(
          color: TEXT_FIELD_HINT_TXT_COLOR,
        ),
        // hintStyle: TextStyle(
        //   color: TEXT_FIELD_HINT_TXT_COLOR,
        // ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: SECONDARY_COLOR,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: SECONDARY_COLOR,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
