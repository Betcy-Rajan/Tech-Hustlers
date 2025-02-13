import 'package:flutter/material.dart';


import 'package:nearsq/common/styles/spacing_styles.dart';
import 'package:nearsq/common/widgets/login_signup/form_divider.dart';
import 'package:nearsq/common/widgets/login_signup/social_buttons.dart';
import 'package:nearsq/features/authentication/screens/login/widgets/login_form.dart';
import 'package:nearsq/features/authentication/screens/login/widgets/login_header.dart';

import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';






class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
  
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding:TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              ///Logo,Title, and Subtitle
              TLoginHeader(),
                ///Form
                 TLoginForm(),
               TFormDivider(dividerText: TTexts.orSignInWith,),
              SizedBox(height: TSizes.spaceBtwSections,),

              //Footer
               TSocialButtons(),
                ],
              ),
              
            
          ),
           ),
       
      );
  }
}



