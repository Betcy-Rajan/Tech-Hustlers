import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/common/widgets/appbar/appbar.dart';
import 'package:nearsq/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:nearsq/common/widgets/list_tiles/settings_menu_title.dart';
import 'package:nearsq/common/widgets/list_tiles/user_profile_title.dart';
import 'package:nearsq/common/widgets/texts/sections_heading.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/constants/sizes.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ///Header
            TPrimaryHeaderContainer(
              child:Column(
                children: [
                  TAppBar(title: Text('Account', style: Theme.of(context).textTheme.headlineLarge!.apply(color: TColors.white),),),
                  const TUserProfileTitle(),
                  const SizedBox(height: TSizes.spaceBtwSections,)
                ],
              ) ),
            ///body
            Padding(padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                /// Account Settings
                const TSectionHeading(title: 'Account Settings',showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),
                TSettingMenuTitle(icon: Iconsax.safe_home,title: 'My Addresses', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.shopping_cart,title: 'My Cart', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.bag_tick,title: 'My Orders', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.bank,title: 'Bank Account', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.discount_shape,title: 'My Coupons', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.notification,title: 'Notification', subTitle: 'Set shopping delivery address',onTap: (){},),
                TSettingMenuTitle(icon: Iconsax.security_card,title: 'Account Privacy', subTitle: 'Set shopping delivery address',onTap: (){},),


                const SizedBox(height: TSizes.spaceBtwSections,),
                const TSectionHeading(title: 'App Settings',showActionButton: false,),
                const SizedBox(height: TSizes.spaceBtwItems,),
                 TSettingMenuTitle(icon: Iconsax.location, title: 'Geolocation', subTitle: 'Set Recomendation based on location',trailing: Switch(value: true, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.location, title: 'Geolocation', subTitle: 'Set Recomendation based on location',trailing: Switch(value: true, onChanged: (value) {}),),
                TSettingMenuTitle(icon: Iconsax.location, title: 'Geolocation', subTitle: 'Set Recomendation based on location',trailing: Switch(value: true, onChanged: (value) {}),),
                

                //Logout Button
                const SizedBox(height: TSizes.spaceBtwSections,),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(onPressed: (){}, child: const Text('Logout')),
                ),
                const SizedBox(height: TSizes.spaceBtwSections* 2.5)
              ],
            ),
            
            ),

            ///User Profile Screen
            ///
             
          ],
        ),
      ),
    );
  }
}

