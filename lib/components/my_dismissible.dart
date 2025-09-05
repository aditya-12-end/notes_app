import 'package:flutter/material.dart';

class MyDismissible extends StatelessWidget {
  final Key item;
  final Function(DismissDirection)? onDismissed;
  const MyDismissible({
    super.key,
    required this.item,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.toString()),
      child: Icon(Icons.delete, color: Colors.red),
      onDismissed: (direction) {
        onDismissed;
      },
    );
  }
}
