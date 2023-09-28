import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/config/utils.dart';

class SearchInput extends StatelessWidget {
  final String? hinteText;
  final Function(String? val)? onSearched;
  const SearchInput({super.key, this.hinteText, this.onSearched});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(5.0),
        border: Border.all(
          color: Colors.grey.shade300,
          width: 2.0,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              "assets/icons/search.svg",
              height: 15.0,
              colorFilter:
                  const ColorFilter.mode(primaryColor, BlendMode.srcIn),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: TextField(
                onChanged: onSearched,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12.0,
                  color: defaultTextColor,
                  fontWeight: FontWeight.w400,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: hinteText ?? "Recherche...",
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12.0,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400,
                  ),
                  counterText: '',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
