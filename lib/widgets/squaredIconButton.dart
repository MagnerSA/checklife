import 'package:flutter/material.dart';

import '../style/style.dart';

class SquaredIconButton extends StatefulWidget {
  final void Function()? onTap;
  final double? width;
  final double? height;
  final IconData? iconData;
  final double? iconSize;
  final Color? iconColor;

  const SquaredIconButton({
    Key? key,
    this.onTap,
    this.width,
    this.height,
    this.iconData,
    this.iconSize,
    this.iconColor,
  }) : super(key: key);

  @override
  State<SquaredIconButton> createState() => _SquaredIconButtonState();
}

class _SquaredIconButtonState extends State<SquaredIconButton> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: widget.onTap,
        child: Ink(
          width: widget.width,
          height: widget.height,
          child: Center(
            child: Icon(
              widget.iconData,
              size: widget.iconSize,
              color: widget.iconColor,
            ),
          ),
        ),
      ),
    );
  }
}
