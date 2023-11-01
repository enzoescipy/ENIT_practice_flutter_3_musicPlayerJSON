import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/page/new_playlist/new_playlist_page.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  final List<PlayListVO> _contentVOList = VOStageCommitGet.getAll();
  bool revalHiddenForNow = false;

  // final List<Widget> _contentWidgetList = _contentVOList.map((vo) => Item.playListVOtoListViewItem(context, vo)).toList();

  void _makeNewPlayListRoute() {
    debugConsole([NewPlayListPage.routeName, "route pushed"]);
    Navigator.pushNamed(context, NewPlayListPage.routeName, arguments: NewPlayListPageArguments(null)).then((value) {
      setState(() {
        _contentVOList.clear();
        _contentVOList.addAll(VOStageCommitGet.getAll());
      });
    });
  }

  void menuSetState() {
    setState(() {
      _contentVOList.clear();
      _contentVOList.addAll(VOStageCommitGet.getAll());
    });
  }

  void onTapAppbar() {
    debugConsole("appbar touched!!! (playlist page)");
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
    //debug
    // debugConsole(_contentVOList.map((e) => e.isHidden));
    //debug
    return Column(
      children: [
        Component.appBar(context, title: "플레이 리스트", onTapAppbar: onTapAppbar),
        Component.listViewPlayListVO(_contentVOList, context,
            isNewPlayListEnable: true,
            routeHandler: _makeNewPlayListRoute,
            menuSetState: menuSetState,
            hideHidden: !revalHiddenForNow)
      ],
    );
  }
}
