import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../config/utils.dart';

class ActionBtn extends StatelessWidget {
  final VoidCallback? onTap;
  final VoidCallback? onClear;
  final IconData? icon;
  final String? hintText;
  final String? value;
  const ActionBtn(
      {super.key,
      this.onTap,
      this.onClear,
      this.icon,
      this.hintText,
      this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(5),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(
                  width: 5,
                ),
                if (value != null) ...[
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            value!,
                            style: const TextStyle(
                              color: defaultTextColor,
                              fontFamily: defaultFont,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          iconSize: 12.0,
                          onPressed: onClear,
                          icon: const Icon(
                            CupertinoIcons.xmark,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                ] else ...[
                  Text(
                    hintText!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: defaultFont,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
