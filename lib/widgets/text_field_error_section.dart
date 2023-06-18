import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/sign_up_page_bloc.dart';

class TextFieldErrorSection extends StatelessWidget {

  final String errorMsg;

  const TextFieldErrorSection({
    super.key,
    required this.errorMsg
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpPageBloc>(
      builder: (context, bloc, child) => Visibility(
        visible: bloc.isTextFieldError,
        child: Container(
          child: Text(
           errorMsg,
            style: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}