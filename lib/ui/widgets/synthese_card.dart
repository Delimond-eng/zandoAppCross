import 'package:flutter/material.dart';
import '/config/utils.dart';

class SyntheseInfo extends StatelessWidget {
  final Color? titleColor;
  final String? title, currency;
  final double? thikness;
  final double? amount;
  final IconData? icon;
  const SyntheseInfo({
    super.key,
    this.titleColor,
    this.title,
    this.thikness,
    this.amount,
    this.currency,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: thikness ?? .5),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: titleColor,
            ),
            const SizedBox(
              width: 8.0,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontFamily: defaultFont,
                      fontWeight: FontWeight.w600,
                      color: titleColor ?? Colors.green[700],
                    ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: amount!.toStringAsFixed(2),
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w800,
                            fontSize: 18.0,
                            fontFamily: defaultFont,
                          ),
                        ),
                        TextSpan(
                          text: " $currency",
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 10.0,
                            fontFamily: defaultFont,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
