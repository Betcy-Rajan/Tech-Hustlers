import 'package:flutter/material.dart';

class TProductPriceText extends StatelessWidget {
const TProductPriceText({
  super.key,
  required this.price, 
  this.currrencySign = '\$', 
  this.maxLines = 1, 
   this.isLarge = false, 
   this.lineThrough = false,});
  
  final String price;
  final String currrencySign;
  final int maxLines;
  final bool isLarge;
  final bool lineThrough;

  @override
  Widget build(BuildContext context) {
    return Text(
    currrencySign +  price,
    maxLines: maxLines,
    overflow: TextOverflow.ellipsis,
      style: isLarge
      ? Theme.of(context).textTheme.headlineMedium!.copyWith(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ) 
      : Theme.of(context).textTheme.titleLarge!.copyWith(
        decoration: lineThrough ? TextDecoration.lineThrough : null,
      ),
    );
  }
}