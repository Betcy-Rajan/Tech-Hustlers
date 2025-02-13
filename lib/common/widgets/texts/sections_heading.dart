

import 'package:flutter/material.dart';

class TSectionHeading extends StatelessWidget {
  const TSectionHeading({
    super.key, required this.title, this.buttonTitle = 'View All', this.textColor, this.onPressed,  this.showActionButton = true,
  });
final String title;
final String buttonTitle;
final Color ? textColor;
final void Function()? onPressed;
final bool showActionButton;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Popular Categories',style: Theme.of(context).textTheme.headlineSmall!.apply(color: textColor),maxLines: 1,overflow: TextOverflow.ellipsis,),
        if(showActionButton) TextButton(onPressed: onPressed, child: Text(buttonTitle,))
      ],
    );
  }
}