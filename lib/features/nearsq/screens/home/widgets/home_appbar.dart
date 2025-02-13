
import 'package:flutter/material.dart';
import 'package:nearsq/common/widgets/appbar/appbar.dart';
import 'package:nearsq/common/widgets/products/cart/cart_menu_icon.dart';
import 'package:nearsq/utilis/constants/colors.dart';
import 'package:nearsq/utilis/constants/text_strings.dart';


class THomeAppBar extends StatelessWidget {
  const THomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TAppBar(
      
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            TTexts.homeAppbarTitle,style: Theme.of(context).textTheme.labelMedium!.apply(color:TColors.grey),),
            Text(
            TTexts.homeAppbarSubTitle,style: Theme.of(context).textTheme.labelMedium!.apply(color:TColors.grey),),
    
        ],
      ),
      actions:  [
         TCartCounterIcon(onPressed: () {},iconColor: TColors.white,)
      
        
      ],
    );
  }
}