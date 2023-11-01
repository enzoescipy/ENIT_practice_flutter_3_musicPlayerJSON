import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;

class PlayListDetailArguments {
  final PlayListVO playListVO;
  PlayListDetailArguments(this.playListVO);
}

class PlayListDetail extends StatefulWidget {
  const PlayListDetail({super.key});
  static const routeName = '/PlayListDetail';

  @override
  State<PlayListDetail> createState() => _PlayListDetailState();
}

class _PlayListDetailState extends State<PlayListDetail> {
  final List<MusicVO> _contentVOList = [];
  bool revalHiddenForNow = false;

  void musicSetState() {
    setState(() {});
  }

  void onTapAppbar() {
    debugConsole("appbar touched!!! (playlist detail)");
    setState(() {
      if (revalHiddenForNow) {
        revalHiddenForNow = false;
      } else {
        revalHiddenForNow = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final PlayListVO playListVO = (ModalRoute.of(context)!.settings.arguments as PlayListDetailArguments).playListVO;
    final indexToVOList = playListVO.childrenIndex.map((index) => MusicJsonReader.getVOFromIndex(index));

    indexToVOList.forEach((element) {
      if (element != null) {
        _contentVOList.add(element);
      }
    });

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Component.appBar(context, title: "음악 목록", isbackButton: true, onTapAppbar: onTapAppbar),
          Component.listViewMusicListVOFromPlayListVO(playListVO, context, musicSetState, hideHidden: !revalHiddenForNow)
        ],
      ),
    );
  }
}
