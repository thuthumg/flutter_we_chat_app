import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/home_page_bloc.dart';
import 'package:we_chat_app/data/vos/user_vo.dart';
import 'package:we_chat_app/pages/chats_page.dart';
import 'package:we_chat_app/pages/contacts_page.dart';
import 'package:we_chat_app/pages/moments_page.dart';
import 'package:we_chat_app/pages/profile_page.dart';
import 'package:we_chat_app/resources/colors.dart';


class HomePage extends StatelessWidget {

    final int navigateIndex;

   HomePage({super.key,required this.navigateIndex});


    Widget _getPage(int pageName, UserVO? userVO) {

      switch (pageName) {
        case 0:
          return MomentsPage();//userVO: userVO
        case 1:
          return ChatsPage(userVO:userVO);
        case 2:
          return ContactsPage(userVO:userVO);
        case 3:
          return ProfilePage(userVO:userVO);
        default:
          return MomentsPage();
      }
    }


    @override
    Widget build(BuildContext context) {

      // print("check param userVO ${widget.userVO.id}");

      return  ChangeNotifierProvider(
        create: (context)=> HomePageBloc(navigateIndex),
        child: Consumer<HomePageBloc>(
          builder: (context,bloc,child)=>Scaffold(
              backgroundColor: PRIMARY_COLOR,

              body:
              _getPage(bloc.selectedIndex,bloc.userVO),
              // _screens[_selectedScreenIndex]["screen"],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: PRIMARY_COLOR,
                type: BottomNavigationBarType.fixed,
                currentIndex: bloc.selectedIndex,
                onTap: (index){
                 return bloc.onTapSelectedIndex(index);
                },
                iconSize: 24.0,
                selectedItemColor: SECONDARY_COLOR,
                unselectedItemColor: TEXT_FIELD_HINT_TXT_COLOR,
                items:  <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/moments/moment_grey.png",scale: 3,),
                    activeIcon: Image.asset("assets/moments/moment_blue.png",scale: 3,),
                    label: 'Moments',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/moments/chat_grey.png",scale: 3,),
                    activeIcon: Image.asset("assets/moments/chat_blue.png",scale: 3,),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/moments/contact_grey.png",scale: 3,),
                    activeIcon: Image.asset("assets/moments/contact_blue.png",scale: 3,),
                    label: 'Contacts',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/moments/profile_grey.png",scale: 3,),
                    activeIcon: Image.asset("assets/moments/profile_blue.png",scale: 3,),
                    label: 'Me',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.asset("assets/moments/setting_grey.png",scale: 3,),
                    activeIcon: Image.asset("assets/moments/setting_blue.png",scale: 3,),
                    label: 'Setting',
                  ),
                ],
              )


          ),
        ),
      );
    }
}


