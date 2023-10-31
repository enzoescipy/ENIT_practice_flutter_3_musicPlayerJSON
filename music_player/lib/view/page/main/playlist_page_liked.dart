import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;

class PlayListLikedPage extends StatefulWidget {
  const PlayListLikedPage({super.key});

  @override
  State<PlayListLikedPage> createState() => _PlayListLikedPageState();
}

class _PlayListLikedPageState extends State<PlayListLikedPage> {
  final List<PlayListVO> _contentVOList = VOStageCommitGet.getLiked();

  void menuSetState() {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Component.appBar(context, title: "좋아하는 플리"), Component.listViewPlayListVO(_contentVOList, context, menuSetState:menuSetState )],
    );
  }
}
