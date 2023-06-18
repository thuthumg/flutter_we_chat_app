import 'package:flutter/material.dart';
import 'package:we_chat_app/resources/dimens.dart';

class SearchBoxWidget extends StatefulWidget{

  final Function(String) onSearch;

  const SearchBoxWidget({super.key,required this.onSearch});

  @override
  State<SearchBoxWidget> createState() => _SearchBoxWidgetState();

}

class _SearchBoxWidgetState extends State<SearchBoxWidget> {

  TextEditingController _controller = TextEditingController();
  // List<String> _filteredItems = [];
  bool _hasText = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
      margin: const EdgeInsets.all(MARGIN_CARD_MEDIUM_2),

      decoration: BoxDecoration(
        color: const Color.fromRGBO(17, 58, 93, 0.21),
        borderRadius: BorderRadius.circular(CUSTOM_BUTTON_RADIUS),
      ),
      // Custom search box UI implementation
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          hintText: 'Search...',
          hintStyle: const TextStyle(color: Color.fromRGBO(17, 58, 93, 0.5)),
          prefixIcon: const Icon(Icons.search,color: Color.fromRGBO(17, 58, 93, 1),),
          filled: true,
          suffixIcon: _hasText
              ? IconButton(
            icon: const Icon(Icons.clear,color: Color.fromRGBO(17, 58, 93, 1),),
            onPressed: _clearSearchQuery,
          )
              : null,
        ),
        // Handle the text input and search functionality
        style: const TextStyle(color: Colors.black54,fontSize: TEXT_REGULAR_2X),
        onChanged: _onSearchTextChanged,
      ),
    );
  }



  @override
  void initState() {
    super.initState();
    _controller.addListener((){
      _hasText = _controller.text.isNotEmpty;
      widget.onSearch(_controller.text);
    });

    // _filteredItems = widget.items;
  }
  //
  void _onSearchTextChanged(String text) {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  void _clearSearchQuery() {
    setState(() {
      _hasText = false;
      _controller.clear();
    });
  }
}
