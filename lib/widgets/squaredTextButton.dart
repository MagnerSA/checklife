import 'package:flutter/material.dart';

import '../style/style.dart';

class SquaredTextButton extends StatefulWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final String? text;
  final Color? color;

  const SquaredTextButton(
      {Key? key, this.onTap, this.width, this.height, this.text, this.color})
      : super(key: key);

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
            child: Text(
              widget.text ?? "",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
