import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/reports/models/dashboard_count.dart';
import '/config/utils.dart';

class DashCard extends StatelessWidget {
  final DashboardCount item;
  const DashCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            gradient: LinearGradient(
              colors: [
                item.color!.shade600.withOpacity(.8),
                item.color!.shade300.withOpacity(.8),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 40.0,
                  width: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        item.color!.shade400,
                        item.color!.shade800,
                      ],
                    ),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      item.icon!,
                      height: 20.0,
                      alignment: Alignment.center,
                      colorFilter: const ColorFilter.mode(
                        lightColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 5.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title!,
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        color: lightColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      item.countValue.toString().padLeft(2, "0"),
                      style: const TextStyle(
                        fontFamily: defaultFont,
                        color: lightColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 10.0,
          right: 10.0,
          child: FadeInRight(
            child: Container(
              decoration: const BoxDecoration(color: Colors.transparent),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  "assets/icons/next_big.svg",
                  height: 15.0,
                  colorFilter: ColorFilter.mode(
                      lightColor.withOpacity(.5), BlendMode.srcIn),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
