import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:we_chat_app/blocs/login_page_bloc.dart';
import 'package:we_chat_app/pages/home_page.dart';
import 'package:we_chat_app/resources/colors.dart';
import 'package:we_chat_app/resources/dimens.dart';
import 'package:we_chat_app/resources/strings.dart';
import 'package:we_chat_app/utils/extensions.dart';
import 'package:we_chat_app/widgets/custom_button_widget.dart';
import 'package:we_chat_app/widgets/edit_text_widget.dart';
import 'package:we_chat_app/widgets/loading_view.dart';

class LoginPage extends StatelessWidget{
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>LoginPageBloc(),
      child: Scaffold(
        backgroundColor: PRIMARY_COLOR,
        appBar: AppBar(
          backgroundColor: PRIMARY_COLOR,
          elevation: 0,
          leading: GestureDetector(
              onTap: (){Navigator.pop(context);},
              child: Image.asset('assets/left_button.png')),
        ),
        body: Selector<LoginPageBloc,bool>(
          selector: (context,bloc) => bloc.isLoading,
          builder:(context,isLoading,child)=> Padding(
            padding: const EdgeInsets.only(left: MARGIN_XXLARGE,right: MARGIN_LARGE),
            child: SingleChildScrollView(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ///Title
                      const Text(
                        WELCOME_TXT,
                        style: TextStyle(
                          fontSize: HI_TXT_FONT_SIZE,
                          color: SECONDARY_COLOR,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_MEDIUM,
                      ),
                      ///SubTitle
                      const Text(
                        LOGIN_TO_CONTINUE_TXT,
                        style: TextStyle(
                          fontSize: TEXT_REGULAR_1X,
                          color: CREATE_NEW_ACCOUNT_TXT_COLOR,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_MEDIUM,
                      ),

                      ///Image
                      Center(
                        child: Image.asset('assets/login/login_bg_img.png',
                            fit: BoxFit.cover),),

                      ///Phone Number edit text section
                      Consumer<LoginPageBloc>(
                          builder: (context,bloc,child)=>
                          EmailTextFieldSectionView(bloc:bloc)),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),

                      ///Password edit text section
                      Consumer<LoginPageBloc>(
                          builder: (context,bloc,child)=>
                          PasswordTextFieldSectionView(bloc:bloc)),
                      const SizedBox(
                        height: MARGIN_XLARGE,
                      ),

                      ///Forgot password link section
                      const Align(
                        alignment:  Alignment.centerRight,
                        child: Text(
                          FORGET_PW_TXT,
                          style: TextStyle(
                            fontSize: TEXT_REGULAR_1X,
                            color: SECONDARY_COLOR,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: MARGIN_XXLARGE,
                      ),

                      ///Login Section
                      Consumer<LoginPageBloc>(
                          builder: (context,bloc,child)=>
                          LoginSectionView(bloc:bloc))
                    ],
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                     bottom: 0,
                     child: Visibility(
                        visible: isLoading,
                        child: Container(
                          // color: Colors.transparent,
                          child: Center(
                            child: LoadingView(),
                          ),
                        ),)
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class LoginSectionView extends StatelessWidget {

  LoginPageBloc bloc;

  LoginSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomButtonWidget(
        buttonText: LOGIN_TXT,
        buttonTextColor: Colors.white,
        buttonBackground: SECONDARY_COLOR,
        buttonBorderColor: SECONDARY_COLOR,
        buttonHeight: 50,
        buttonWidth: 150,
        onTapButton: () {
          bloc.onTapLogin().then((value){
            navigateToScreen(context, HomePage(),false);
          });

        },
      ),
    );
  }
}

class EmailTextFieldSectionView extends StatelessWidget {

  LoginPageBloc bloc;

  EmailTextFieldSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CUSTOM_BUTTON_HEIGHT,
      child: EditTextWidget(
        isSecure: false,
        editTextName: "",
        editTextType: "emailText",
        hintTextName: EMAIL_TXT,//ENTER_YOUR_PHONE_NUM_TXT
        isGroupNameText: false,
        onChanged: (emailtxt){
          bloc.onEmailChanged(emailtxt);
        },
      ),
    );
  }
}

class PasswordTextFieldSectionView extends StatelessWidget {

  LoginPageBloc bloc;

  PasswordTextFieldSectionView({
    super.key,
    required this.bloc
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CUSTOM_BUTTON_HEIGHT,
      child: EditTextWidget(
        isSecure: true,
        editTextName: "",
        editTextType: "text",
        hintTextName: ENTER_YOUR_PW_TXT,
        isGroupNameText: false,
        onChanged: (password){
          bloc.onPasswordChanged(password);
        },
      ),
    );
  }
}