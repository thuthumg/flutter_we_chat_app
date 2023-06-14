import 'package:flutter/material.dart';
import 'package:we_chat_app/pages/chats_page.dart';
import 'package:we_chat_app/pages/contacts_page.dart';
import 'package:we_chat_app/pages/moments_page.dart';
import 'package:we_chat_app/pages/profile_page.dart';
import 'package:we_chat_app/resources/colors.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _selectedScreenIndex = 0;
  bool appBarVisible = true;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  int _currentIndex = 0;
  void _selectScreen(int index){
    setState(() {
      _selectedScreenIndex = index;

      if(index == 0)
      {
        appBarVisible = true;
      }else{
        appBarVisible = false;
      }
      // navigatorKey.currentState.pushNamed('/tab$index');
    });
  }
  Widget _getPage(int pageName) {

    switch (pageName) {
      case 0:
        return MomentsPage();
      case 1:
        return ChatsPage();
      case 2:
        return ContactsPage();
      case 3:
        return ProfilePage();
      default:
        return MomentsPage();
    }
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: PRIMARY_COLOR,

        body:
        _getPage(_selectedScreenIndex),
        // _screens[_selectedScreenIndex]["screen"],
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: PRIMARY_COLOR,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedScreenIndex,
          onTap: _selectScreen,
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


    );
  }
}


