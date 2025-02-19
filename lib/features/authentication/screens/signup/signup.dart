import 'package:flutter/material.dart';
import 'package:nearsq/common/widgets/login_signup/social_buttons.dart';
import 'package:nearsq/common/widgets/login_signup/form_divider.dart'; 

import 'package:nearsq/features/authentication/screens/signup/widgets/signup_form.dart';

import 'package:nearsq/utilis/constants/sizes.dart';


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: 
        Padding(padding:   const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ///Title
                 Text("Let's create your account", style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: TSizes.spaceBtwSections,),

               ///Form
               const TSignupForm(),
                const SizedBox(height: TSizes.spaceBtwSections,),
                //Divider
                const TFormDivider(dividerText: 'Or Sign Up with',),

                const SizedBox(height: TSizes.spaceBtwSections,),
                //social buttons
                const TSocialButtons(),



              
            ],
          ),
        ),
      ),
    );
  }
}

