import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/features/authentication/controllers/forget_password/forget_password_controller.dart';

import 'package:nearsq/utilis/constants/sizes.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';
import 'package:nearsq/utilis/validators/validation.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =Get.put(ForgetPasswordController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///Headings
            
            Text(TTexts.forgetPasswordTitle, style: Theme.of(context).textTheme.headlineMedium,textAlign: TextAlign.center,),
            const SizedBox(height: TSizes.spaceBtwItems,),
            Text(TTexts.forgetPasswordSubTitle, style: Theme.of(context).textTheme.labelMedium,textAlign: TextAlign.center,),
            const SizedBox(height: TSizes.spaceBtwSections * 2,),
        
            //Text Field
            Form(
              key: controller.forgetPasswordFormKey,
              child: TextFormField(
                controller: controller.email,
                validator: TValidator.validateEmail,
                decoration: const InputDecoration(hintText: TTexts.email,prefixIcon: Icon(Iconsax.direct_right),),
                ),
            ),
              const SizedBox(height: TSizes.spaceBtwSections,),
          
            ///Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.sendPasswordResetEmail();
                },
                child: const Text(TTexts.submit,),
              ),
            ),
            
        
          ],
        ),
        ),
      ),
      );
  }
}