import 'package:flutter/material.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;

class PlayListLikedPage extends StatefulWidget {
  const PlayListLikedPage({super.key});

  @override
  State<PlayListLikedPage> createState() => _PlayListLikedPageState();
}

class _PlayListLikedPageState extends State<PlayListLikedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Component.appBar(context),
      ],
    );
  }
}