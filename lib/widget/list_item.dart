import 'dart:io';

import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  const ListItem({
    super.key,
    required this.file,
    required this.place,
    required this.latitudine,
    required this.longitudine,
  });

  final File file;
  final String place;
  final String latitudine;
  final String longitudine;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: MemoryImage(file.readAsBytesSync()),
      ),
      title: Text(place),
      subtitle: Text("${latitudine}, ${longitudine}"),
    );
  }
}
