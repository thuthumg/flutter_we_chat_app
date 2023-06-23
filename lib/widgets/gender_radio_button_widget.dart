import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';

enum Gender { male, female, other }

class GenderRadioButtonWidget extends StatefulWidget {

  final Function(String) onTapGender;

  final String genderType;

  GenderRadioButtonWidget({
    required this.onTapGender,
    required this.genderType
});

  @override
  _GenderRadioButtonWidgetState createState() => _GenderRadioButtonWidgetState();
}

class _GenderRadioButtonWidgetState extends State<GenderRadioButtonWidget> {
  Gender? selectedGender;

  @override
  void initState() {
    selectedGender =  (widget.genderType != "")? changeGenderType(widget.genderType) : Gender.male;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        buildRadioButton('Male', Gender.male,(selectedGender){
          widget.onTapGender(selectedGender);
        }),
        SizedBox(width: MARGIN_MEDIUM_2),
        buildRadioButton('Female', Gender.female,(selectedGender){
          widget.onTapGender(selectedGender);
        }),
        SizedBox(width: MARGIN_MEDIUM_2),
        buildRadioButton('Other', Gender.other,(selectedGender){
          widget.onTapGender(selectedGender);
        }),
      ],
    );
  }

  Widget buildRadioButton(String label, Gender gender,Function(String) onTapGender) {
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Radio<Gender>(
              value: gender,
              groupValue: selectedGender,
              onChanged: (value) {
                if(value == Gender.male)
                  {
                    onTapGender('Male');
                  }else if(value == Gender.female){
                  onTapGender('Female');
                }else{
                  onTapGender('Other');
                }

                setState(() {
                  selectedGender = value ?? Gender.male;
                });
              },
            ),
            Text(label,
            style: const TextStyle(
              fontSize: TEXT_REGULAR,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w500
            ),),
          ],
        ),
      ),
    );
  }
}

Gender changeGenderType(String genderType) {

  if(genderType == "Male")
    {
      return Gender.male;
    }else if(genderType == "Female")
      {
        return Gender.female;
      }else{
    return Gender.other;
  }

}
