import 'package:flutter/material.dart';

class PopupMenuHItem {
  final String label;
  final Icon icon;
  final void Function() onPress;

  PopupMenuHItem(
      {required this.label, required this.icon, required this.onPress});
}

class PopupMenuH extends StatelessWidget {
  final List<PopupMenuHItem> items;
  final double? iconSize;
  final IconData? icon;
  final String? value;
  const PopupMenuH(
      {super.key, required this.items, this.iconSize, this.icon, this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        value != null
            ? Text(
                value!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
              )
            : SizedBox(),
        PopupMenuButton<String>(
          initialValue: value,
          iconSize: iconSize ?? 24,
          icon: Icon(
            icon ?? Icons.more_vert,
            size: iconSize ?? 24,
          ),
          itemBuilder: (context) {
            return items.map((item) {
              return PopupMenuItem<String>(
                value: item.label,
                onTap: item.onPress,
                child: Row(
                  children: [
                    item.icon,
                    SizedBox(
                      width: 8,
                    ),
                    Text(item.label),
                  ],
                ),
              );
            }).toList();
          },
        ),
      ],
    );
  }
}
