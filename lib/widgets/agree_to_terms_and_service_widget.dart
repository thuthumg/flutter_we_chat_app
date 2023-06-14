
import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';

class AgreeToTermsAndServiceWidget extends StatefulWidget {
  const AgreeToTermsAndServiceWidget({
    super.key,
  });

  @override
  State<AgreeToTermsAndServiceWidget> createState() => _AgreeToTermsAndServiceSectionState();
}

class _AgreeToTermsAndServiceSectionState extends State<AgreeToTermsAndServiceWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: MARGIN_LARGE),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: CHECK_BOX_SIZE_HEIGHT,
            width: CHECK_BOX_SIZE_WIDTH,
            child: Theme(
              data: ThemeData(
                unselectedWidgetColor: SECONDARY_COLOR, // Change the unselected checkbox color
                checkboxTheme: CheckboxThemeData(
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return SECONDARY_COLOR; // Change the selected checkbox color
                    }
                    return Colors.grey; // Change the default checkbox color
                  }),
                ),
              ),
              child: Checkbox(
                value: isChecked,
                onChanged: (newValue) {
                  setState(() {
                    isChecked = newValue ?? false;
                  });
                },
              ),
            ),
          ),
          const SizedBox(width: MARGIN_MEDIUM_3,),
          const Text(
            AGREE_TO_TXT,
            style: TextStyle(
              fontSize: TEXT_REGULAR_1X,
              color: TEXT_FIELD_HINT_TXT_COLOR,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Text(
            TERM_AND_SERVICE_TXT,
            style: TextStyle(
              fontSize: TEXT_REGULAR_1X,
              color: SECONDARY_COLOR,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}