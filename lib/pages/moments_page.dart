import 'package:flutter/material.dart';
import 'package:we_chat_app/components/moments_list_view.dart';
import 'package:we_chat_app/pages/create_moment_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/each_moment_view_item.dart';

class MomentsPage extends StatelessWidget{

  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

  MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PRIMARY_COLOR,
      appBar: AppBar(
        backgroundColor: PRIMARY_COLOR,
        automaticallyImplyLeading: false,
        title:  const Text(
          MOMENT_TXT,
          style: TextStyle(
            fontSize: TEXT_HEADING_2X,
            color: SECONDARY_COLOR,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          GestureDetector(
              onTap: (){
                navigateToScreen(context,CreateMomentPage(),false);
              },
              child: Image.asset('assets/moments/add_new_moment_icon.png',scale: 3,))
        ],

      ),
      body: MomentsListView(items: items,isBookmark: false,),
    );
  }

}



