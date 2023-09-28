import 'package:flutter/material.dart';
import '/config/utils.dart';

class CustomCheckBox extends StatefulWidget {
  final bool? value;
  final VoidCallback? onChanged;
  final String title;
  const CustomCheckBox({
    super.key,
    this.value = false,
    this.onChanged,
    required this.title,
  });

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged!.call();
      },
      child: Container(
        height: 50.0,
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(5.0),
        decoration: const BoxDecoration(
          color: Colors.transparent,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 20.0,
              width: 20.0,
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              padding: const EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(
                  width: 2.0,
                  color: primaryColor,
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              child: Container(
                height: 18.0,
                width: 18.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  gradient: (widget.value!)
                      ? LinearGradient(
                          colors: [
                            primaryColor,
                            primaryColor.shade300,
                          ],
                        )
                      : const LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white,
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              child: Text(
                widget.title,
                style: const TextStyle(
                  letterSpacing: 1.0,
                  color: defaultTextColor,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
