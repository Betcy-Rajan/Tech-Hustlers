import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nearsq/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:nearsq/common/widgets/custom_shapes/containers/search_container.dart';
import 'package:nearsq/common/widgets/layouts/grid_layout.dart';
import 'package:nearsq/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:nearsq/common/widgets/texts/sections_heading.dart';
import 'package:nearsq/features/nearsq/screens/home/widgets/home_appbar.dart';
import 'package:nearsq/features/nearsq/screens/home/widgets/home_categories.dart';
import 'package:nearsq/features/nearsq/screens/home/widgets/promo_slider.dart';
import 'package:nearsq/navigation_drawer_widget.dart';
import 'package:nearsq/utilis/constants/image_strings.dart';
import 'package:nearsq/utilis/constants/sizes.dart';






class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      drawer: NavigationDrawerWidget(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            
              const TPrimaryHeaderContainer(
                
               child:  Column(
                children: [
                  THomeAppBar(),
                   SizedBox(height: TSizes.spaceBtwSections,),
                  TSearchContainer(
                    text: 'Search in nearsq',
                    icon: Iconsax.search_normal,
                  ),
                  SizedBox(height: TSizes.spaceBtwSections,),
                  Padding(padding: 
                  EdgeInsets.only(left: TSizes.defaultSpace,),
                  child: Column(
                    children: [
                      TSectionHeading(
                        title: 'Popular Categories',
                        showActionButton: false,
                        textColor: Colors.white,
                      ),
                      SizedBox(height: TSizes.spaceBtwItems,),

                      //categories
                      THomeCategories(),
                    
                    ],
                  ),

                  ),
                  SizedBox(height: TSizes.spaceBtwSections,)

                ],
              ),
            ),
             Padding(
               padding: const EdgeInsets.all(TSizes.defaultSpace),
               child: Column(
                 children: [
                    const TPromoSlider(
                    banners: [ TImages.promoBanner1,TImages.promoBanner2, TImages.promoBanner3,],),
                     const SizedBox(height: TSizes.spaceBtwSections,),
                     //heading
                     TSectionHeading(
                       title: 'Popular Products',
                       onPressed: () {},
                       ),
                       const SizedBox(height: TSizes.spaceBtwItems,),
                    //Popular Products
                      TGridLayout(
                        itemCount: 4,
                        itemBuilder: (_, index) => const TProductCardVertical(),
                      ),
                    
                 ],
               ),
             ),
            
          ],
        ),

      )
      );
  }
}

















