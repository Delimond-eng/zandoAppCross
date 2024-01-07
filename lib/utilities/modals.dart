// ignore_for_file: deprecated_member_use
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class Xloading {
  static dismiss() {
    Get.back();
  }

  static showLottieLoading(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12,
      context: context,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Dialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    child: Container(
                      height: 70.0,
                      width: 70.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white.withOpacity(.5),
                      ),
                      child: const SpinKitFadingCircle(
                        color: Colors.pink,
                        size: 70.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static show(context, String title) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black12,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color.fromARGB(255, 3, 27, 46),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              if (title.isNotEmpty)
                const SizedBox(
                  width: 10,
                ),
              Container(
                margin: const EdgeInsets.only(left: 5),
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 18.0),
                ),
              ),
            ],
          ),
        );
      },
    );

    Future.delayed(const Duration(seconds: 10), () {
      Get.back();
    });
  }
}

//attribution_sharp
class XDialog {
  static show(BuildContext context,
      {String? message, VoidCallback? onValidated, VoidCallback? onFailed}) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.black12,
      context: context,
      builder: (
        BuildContext context,
      ) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 10.0,
          ),
          backgroundColor: Colors.transparent,
          //this right here
          child: Container(
            height: 200.0,
            width: 400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Confirmation",
                        style: TextStyle(
                          color: Colors.indigo,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              message!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Flexible(
                      child: Btn(
                        color: Colors.white,
                        height: 45.0,
                        isOutlined: true,
                        label: 'Non',
                        labelColor: Colors.indigo,
                        onPressed: () {
                          Get.back();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            onFailed!.call();
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Flexible(
                      child: Btn(
                        height: 45.0,
                        label: 'Oui',
                        color: Colors.indigo,
                        labelColor: Colors.white,
                        onPressed: () {
                          Get.back();
                          Future.delayed(const Duration(milliseconds: 100), () {
                            onValidated!.call();
                          });
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  static showMessage(BuildContext context,
      {String? message,
      String? type = "",
      Duration? duration,
      bool repeat = false}) {
    String lottiesPath = "";
    switch (type) {
      case "success":
        lottiesPath = "assets/animated/success_1.json";
        break;
      case "warning":
        lottiesPath = "assets/animated/warning.json";
        break;
      case "error":
        lottiesPath = "assets/animated/error.json";
        break;
      case "connection-error":
        lottiesPath = "assets/animated/no-connection.json";
        break;
      default:
        lottiesPath = "assets/animated/success_1.json";
    }
    showDialog(
      barrierColor: Colors.black12,
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10.0,
          ),
          backgroundColor: Colors.transparent,
          //this right here
          child: Container(
            height: 160.0,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Lottie.asset(
                          lottiesPath,
                          repeat: repeat,
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              message!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.black87,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    Future.delayed(duration ?? const Duration(seconds: 3), () {
      Get.back();
    });
  }
}

class Btn extends StatelessWidget {
  final Color? color;
  final bool? isOutlined;
  final String? label;
  final Color? labelColor;
  final VoidCallback? onPressed;
  final double? height;

  const Btn({
    super.key,
    this.color,
    this.isOutlined = false,
    this.label,
    this.onPressed,
    this.labelColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 55.0,
      width: double.infinity,
      decoration: BoxDecoration(
        color: color ?? Colors.pink,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: isOutlined! ? Colors.indigo : Colors.transparent,
        ),
      ),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed!,
          borderRadius: BorderRadius.circular(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: labelColor ?? Colors.white,
                  fontSize: 12.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
