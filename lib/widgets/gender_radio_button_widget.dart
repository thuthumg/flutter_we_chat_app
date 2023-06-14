import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';

enum Gender { male, female, other }

class GenderRadioButtonWidget extends StatefulWidget {
  @override
  _GenderRadioButtonWidgetState createState() => _GenderRadioButtonWidgetState();
}

class _GenderRadioButtonWidgetState extends State<GenderRadioButtonWidget> {
  Gender selectedGender = Gender.male;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildRadioButton('Male', Gender.male),
        SizedBox(width: 16),
        buildRadioButton('Female', Gender.female),
        SizedBox(width: 16),
        buildRadioButton('Other', Gender.other),
      ],
    );
  }

  Widget buildRadioButton(String label, Gender gender) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.grey,
      ),
      child: RadioTheme(
        data: RadioThemeData(
          fillColor: MaterialStateColor.resolveWith((states) {
            if (states.contains(MaterialState.selected)) {
              return SECONDARY_COLOR; // Change the selected color here
            }
            return SECONDARY_COLOR; // Change the unselected color here
          }),
        ),
        child: Row(
          children: [
            Radio<Gender>(
              value: gender,
              groupValue: selectedGender,
              onChanged: (value) {
                setState(() {
                  selectedGender = value ?? Gender.male;
                });
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
