import 'package:flutter/material.dart';

class CustomDropdownWidget extends StatefulWidget {
  List<String> dateOfBirthArrayObj;

  CustomDropdownWidget({required this.dateOfBirthArrayObj});

  @override
  _FilterDropdownState createState() => _FilterDropdownState(dateOfBirthArrayObj);
}

class _FilterDropdownState extends State<CustomDropdownWidget> {
  List<String> dateOfBirthArrayObj = [];

  _FilterDropdownState(this.dateOfBirthArrayObj);
  String _selectedItem = "";
  @override
  Widget build(BuildContext context) {
    //   _selectedItem = filterArrayObj[0].toString();
    _selectedItem = _selectedItem.isEmpty? dateOfBirthArrayObj[0].toString() : _selectedItem;
    final List<String> _ItemName = dateOfBirthArrayObj;
    return Container(
      margin: const EdgeInsets.only(top: 10.0, right: 10.0),
      constraints: BoxConstraints(
        minHeight: 5.0,
        minWidth: 70.0,
        maxHeight: 30.0,
        maxWidth: 200.0,
      ),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),

      // decoration:
      //     BoxDecoration(border: Border.all(color: Colors.white70, width: 1)),
      // width: double.infinity,
      // margin: const EdgeInsets.all(5),
      child: DropdownButtonHideUnderline(
        //     decoration: InputDecoration(
        //       contentPadding:
        //           EdgeInsets.only(left: 10.0, right: 10.0, top: 2.0, bottom: 2.0),
        //       enabledBorder: OutlineInputBorder(
        //         // borderSide: BorderSide(color: Colors.white, width: 2),
        //         borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        //       ),
        //       border: OutlineInputBorder(
        //         // borderSide: BorderSide(color: Colors.white, width: 2),
        //         borderRadius: BorderRadius.circular(MARGIN_MEDIUM),
        //       ),
        //       filled: true,
        //       fillColor: Colors.white,
        //     ),
        child: ButtonTheme(
          minWidth: 100,
          height: 70,
          alignedDropdown: true,
          child: DropdownButton(
            // dropdownColor: Colors.white70,
            iconSize: 20,
            icon: Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black,
            ),
            value: _selectedItem,
            items: _ItemName.map((countryCode) {
              return DropdownMenuItem<String>(
                value: countryCode,
                child: Text(
                  countryCode,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedItem = newValue ?? "";
              });
            },
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}