import 'package:flutter/material.dart';

import '../consts/costs.dart';

class UserAvatarView extends StatelessWidget {
  final Widget Function(BuildContext context) buildImage;
  final bool isOnline, isGroup;
  final double size;
  final EdgeInsets margin;

  const UserAvatarView({
    required this.buildImage,
    this.isOnline = true,
    this.isGroup = false,
    this.size = 65,
    this.margin = const EdgeInsets.symmetric(vertical: 5),
    Key? key,
  }) : super(key: key);

  static UserAvatarView image(
    ImageProvider image, {
    bool isOnline = true,
    bool isGroup = false,
    double size = 56,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    Color? backgroundColor,
    Color? borderColor,
  }) =>
      UserAvatarView(
        buildImage: (context) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: backgroundColor ?? UIColors.grey,
            border: Border.all(color: borderColor ?? UIColors.grey, width: 2),
            borderRadius: BorderRadius.circular(50),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        isOnline: isOnline,
        isGroup: isGroup,
        margin: margin,
      );

  static UserAvatarView label(
    String label, {
    bool isOnline = false,
    bool isGroup = false,
    double size = 56,
    EdgeInsets margin = const EdgeInsets.symmetric(vertical: 5),
    Color? backgroundColor,
    Color? borderColor,
    Color? textColor,
  }) =>
      UserAvatarView(
        buildImage: (context) => Container(
          width: size,
          height: size,
          constraints: BoxConstraints(
            minHeight: size,
            minWidth: size,
            maxHeight: size,
            maxWidth: size,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: backgroundColor ?? UIThemeColors.iconBg,
            border: Border.all(color: borderColor ?? UIColors.grey, width: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: textColor ?? UIThemeColors.iconFg1,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        isOnline: isOnline,
        isGroup: isGroup,
        margin: margin,
      );

  @override
  Widget build(BuildContext context) => Container(
        margin: margin,
        child: SizedBox(
          width: size + 5,
          child: Stack(
            children: [
              buildImage(context),
              if (isGroup)
                Positioned(
                  right: 0,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      color: UIColors.grey,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.group,
                      color: UIThemeColors.pageBackground,
                      size: 12,
                    ),
                  ),
                ),
              if (isOnline)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: size * 0.4,
                    height: size * 0.4,
                    decoration: BoxDecoration(
                      color: UIColors.success,
                      border: Border.all(
                          color: UIThemeColors.pageBackground, width: 2),
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
}
