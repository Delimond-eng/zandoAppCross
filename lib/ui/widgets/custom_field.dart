import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '/services/utils.dart';
import '/ui/widgets/custom_btn_icon.dart';
import '/config/utils.dart';

class CustomField extends StatefulWidget {
  final String hintText;
  final bool? isPassword;
  final String iconPath;
  final double? height;
  final TextInputType? inputType;
  final TextEditingController? controller;
  final Color? borderColor, iconColor;
  final bool? isDropdown;
  final Function(dynamic value)? onChangedDrop;
  final Function(String? value)? onChangedCurrency;
  final Function(String? value)? onDatePicked;
  final List<dynamic>? dropItems;
  final bool? isCurrency;
  final bool? isDatePicker;
  const CustomField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    required this.iconPath,
    this.controller,
    this.inputType,
    this.borderColor,
    this.iconColor,
    this.isDropdown = false,
    this.onChangedDrop,
    this.dropItems,
    this.isCurrency = false,
    this.onChangedCurrency,
    this.height,
    this.isDatePicker = false,
    this.onDatePicked,
  });

  @override
  State<CustomField> createState() => _CustomFieldState();
}

class _CustomFieldState extends State<CustomField> {
  dynamic selectDrop;
  String currency = "USD";
  String? selectedDate;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedDate = dateToString(DateTime.now());
    });
  }

  var obscurText = true;
  @override
  Widget build(BuildContext context) {
    if (widget.isDatePicker!) {
      return Container(
        height: widget.height ?? 50.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white.withOpacity(.7),
          border: Border.all(
            color: widget.borderColor ?? Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: GestureDetector(
          onTap: () async {
            var date = await showDatePicked(context);
            widget.onDatePicked!.call(date);
            setState(() {
              selectedDate = date;
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Row(
              children: [
                Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/calendar-check.svg",
                      colorFilter: ColorFilter.mode(
                        widget.iconColor ?? primaryColor,
                        BlendMode.srcIn,
                      ),
                      width: 20.0,
                    ),
                    const SizedBox(
                      width: 10.0,
                    ),
                    Container(
                      height: 30.0,
                      width: 1,
                      color: widget.borderColor ?? Colors.grey.shade200,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          selectedDate ?? widget.hintText,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            color: selectedDate != null
                                ? defaultTextColor
                                : Colors.grey.shade800,
                            fontWeight: selectedDate != null
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                      if (selectedDate != null) ...[
                        CustomBtnIcon(
                          onPressed: () {
                            setState(() {
                              selectedDate = null;
                            });
                          },
                        )
                      ]
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    } else {
      return Container(
        height: widget.height ?? 50.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white.withOpacity(.7),
          border: Border.all(
            color: widget.borderColor ?? Colors.grey.shade300,
            width: 1.2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10.0,
          ),
          child: Row(
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    widget.iconPath,
                    colorFilter: ColorFilter.mode(
                      widget.iconColor ?? primaryColor,
                      BlendMode.srcIn,
                    ),
                    width: 20.0,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    height: 30.0,
                    width: 1,
                    color: widget.borderColor ?? Colors.grey.shade200,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                ],
              ),
              const SizedBox(
                width: 5,
              ),
              if (widget.isDropdown!) ...[
                Expanded(
                  child: DropdownButtonFormField(
                    menuMaxHeight: 300,
                    dropdownColor: Colors.white,
                    focusColor: Colors.white,
                    isExpanded: true,
                    alignment: Alignment.centerLeft,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 12.0,
                    ),
                    value: selectDrop,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12.0,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w400,
                      ),
                      counterText: '',
                    ),
                    items: widget.dropItems!.map((e) {
                      return DropdownMenuItem(
                        value: e,
                        child: Text(
                          e.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12.0,
                            fontFamily: "Poppins",
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => selectDrop = value);
                      widget.onChangedDrop!.call(value);
                    },
                  ),
                )
              ] else ...[
                Expanded(
                  child: widget.isPassword!
                      ? TextField(
                          controller: widget.controller,
                          keyboardType: TextInputType.text,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                            counterText: '',
                          ),
                          obscureText: obscurText,
                        )
                      : TextField(
                          keyboardType: widget.inputType ?? TextInputType.text,
                          keyboardAppearance: Brightness.dark,
                          controller: widget.controller,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 12.0,
                            color: defaultTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: widget.hintText,
                            hintStyle: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 12.0,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400,
                            ),
                            counterText: '',
                          ),
                        ),
                ),
                if (widget.isCurrency!) ...[
                  if (widget.isCurrency!) ...[
                    SizedBox(
                      width: 70.0,
                      child: DropdownButton(
                        menuMaxHeight: 200,
                        focusColor: Colors.white.withOpacity(.7),
                        dropdownColor: Colors.white,
                        alignment: Alignment.centerLeft,
                        borderRadius: BorderRadius.circular(4.0),
                        style: const TextStyle(
                          fontFamily: defaultFont,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                        ),
                        value: currency,
                        underline: const SizedBox(),
                        hint: const Text(
                          "Devise",
                          style: TextStyle(
                            fontFamily: defaultFont,
                            color: Colors.grey,
                            fontWeight: FontWeight.w400,
                            fontSize: 12.0,
                          ),
                        ),
                        isExpanded: true,
                        items: ["USD", "CDF"].map((e) {
                          return DropdownMenuItem<String>(
                            value: e,
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontFamily: defaultFont,
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 12.0,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            currency = value!;
                            Future.delayed(Duration.zero, () {
                              widget.onChangedCurrency!.call(value);
                            });
                          });
                        },
                      ),
                    )
                  ]
                ]
              ],
              if (widget.isPassword!) ...[
                GestureDetector(
                  onTap: () {
                    setState(() => obscurText = !obscurText);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Icon(
                      obscurText
                          ? CupertinoIcons.eye_solid
                          : CupertinoIcons.eye_slash_fill,
                      color: Colors.black45,
                      size: 18.0,
                    ),
                  ),
                )
              ]
            ],
          ),
        ),
      );
    }
  }
}
