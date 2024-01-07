import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final MaterialColor? color;
  final bool? loading;
  final VoidCallback onPressed;
  final IconData? icon;
  const SubmitButton({
    super.key,
    required this.label,
    this.color,
    required this.onPressed,
    this.loading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: loading! ? null : onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(20.0),
        disabledBackgroundColor:
            color != null ? color!.shade300 : Colors.indigo.shade300,
        backgroundColor: color ?? Colors.indigo,
      ),
      child: loading!
          ? const SpinKitThreeBounce(
              color: Colors.white,
              size: 20.0,
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Colors.white,
                    size: 15.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
    );
  }
}
