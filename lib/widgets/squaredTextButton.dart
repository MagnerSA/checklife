import 'package:flutter/material.dart';

import '../style/style.dart';

class SquaredTextButton extends StatefulWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final String? text;
  final Color? color;
  final Color? textColor;
  final FontWeight? fontWeight;
  final double? textSize;

  const SquaredTextButton({
    Key? key,
    this.onTap,
    this.width,
    this.height,
    this.text,
    this.color,
    this.textColor,
    this.fontWeight,
    this.textSize,
  }) : super(key: key);

  @override
  State<SquaredTextButton> createState() => _SquaredTextButtonState();
}

class _SquaredTextButtonState extends State<SquaredTextButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onTap,
        child: Ink(
          color: widget.color,
          width: widget.width,
          height: widget.height,
          child: Center(
            child: FittedBox(
              fit: BoxFit.fill,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 10,
                ),
                child: Text(
                  widget.text ?? "",
                  style: TextStyle(
                    color: widget.textColor,
                    fontSize: 14,
                    fontWeight: widget.fontWeight,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
