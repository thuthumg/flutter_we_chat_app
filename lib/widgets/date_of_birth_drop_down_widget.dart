import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class DateOfBirthDropDownWidget extends StatefulWidget {
  Function(String) onTapDay;
  Function(String) onTapMonth;
  Function(String) onTapYear;

  DateOfBirthDropDownWidget({
    required this.onTapDay,
  required this.onTapMonth,
  required this.onTapYear});

  @override
  _DateOfBirthDropDownWidgetState createState() =>
      _DateOfBirthDropDownWidgetState();
}

class _DateOfBirthDropDownWidgetState extends State<DateOfBirthDropDownWidget> {
  String selectedDay = "";
  String selectedMonth = "";
  String selectedYear = "";

  List<String> daysList =
      ['Day'] + List.generate(31, (index) => (index + 1).toString());
  List<String> monthsList = ['Month'] +
      [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
  List<String> yearsList =
      ['Year'] + List.generate(100, (index) => (2023 - index).toString());

  @override
  void initState() {
    selectedDay = daysList[0];
    selectedMonth = monthsList[0];
    selectedYear = yearsList[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildDropdown('Day', daysList, selectedDay, (String? newValue) {
          widget.onTapDay(newValue.toString());
          setState(() {
            selectedDay = newValue ?? 'Day';
          });
        }),
        SizedBox(width: 8),
        buildDropdown('Month', monthsList, selectedMonth, (String? newValue) {
          widget.onTapMonth(newValue.toString());
          setState(() {
            selectedMonth = newValue ?? 'Month';
          });
        }),
        SizedBox(width: 8),
        buildDropdown('Year', yearsList, selectedYear, (String? newValue) {
          widget.onTapYear(newValue.toString());
          setState(() {
            selectedYear = newValue ?? 'Year';
          });
        }),
      ],
    );
  }

  Widget buildDropdown(String label, List<String> items, String selectedValue,
      Function(String?) onChanged) {
    return DropdownButton<String>(
      //elevation: 10,
      value: selectedValue,
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      hint: Text(label),
    );
  }
}
