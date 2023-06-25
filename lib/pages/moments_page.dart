import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/moments_page_bloc.dart';
import 'package:we_chat_app/components/moments_list_view.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/create_moment_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/viewitems/each_moment_view_item.dart';

class MomentsPage extends StatelessWidget{

 // final UserVO? userVO;


  MomentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MomentsPageBloc(),
      child: Consumer<MomentsPageBloc>(
        builder: (context,bloc,child)=> Scaffold(
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
          body: MomentsListView(
            loginUserPhoneNum:bloc.userVO?.phoneNumber.toString()??"",
            items: bloc.mMomentsList??[],
            isBookmark: false,
          onTapBookMark: (momentVO){
              bloc.saveBookMark(bloc.userVO!, momentVO);
          },
          ),
        ),
      ),
    );
  }

}



