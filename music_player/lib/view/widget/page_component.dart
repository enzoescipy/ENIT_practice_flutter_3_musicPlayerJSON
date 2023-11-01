import 'package:flutter/material.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
import 'package:music_player/package/debugConsole.dart';

import 'package:music_player/view/widget/item_widget.dart' as Item;

Widget appBar(BuildContext context, {String title = "new AppBar", bool isbackButton = false}) {
  return AppBar(
    title: Container(
      width: 350,
      height: 30,
      alignment: Alignment.center,
      decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
      child: Text(
        title,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    ),
    centerTitle: true,
    automaticallyImplyLeading: isbackButton,
  );
}

Widget listViewFrom(List<Widget> children) {
  return Expanded(child: ListView(children: children));
}

/// if sourceVOList not provided, function will use widgetList by ListView children.
/// if sourceVOList provided, function will use sourceVOList to build items,
/// append them inside widgetList, and then render it.
/// (if sourceVOList provided, context must not be null.)
Widget _simpleListViewFromVO(List<VO> sourceVOList, Widget Function(BuildContext, VO) toItemFunc, BuildContext context, {Widget? insertFirst}) {
  final widgetList = sourceVOList.map((vo) => toItemFunc(context, vo)).toList();
  if (insertFirst != null) {
    widgetList.add(insertFirst);
  }
  return listViewFrom(widgetList);
}

Widget listViewPlayListVO(List<PlayListVO> sourceVOList, BuildContext context,
    {bool isNewPlayListEnable = false, void Function()? routeHandler, void Function()? menuSetState}) {
  if (isNewPlayListEnable == true && routeHandler == null) {
    throw Exception("routehandler must be prepared if you user the isNewPlay어쩌구");
  }

  Widget? insertFirst = null;
  if (isNewPlayListEnable) {
    if (routeHandler == null) {
      throw Exception("route 잇ㅅ어얀하ㅔ");
    }
    final tempVO = PlayListVO("새로운 플레이리스트 만들기", []);
    insertFirst = Item.playListVOtoListViewItem(context, tempVO,
        onTapInstead: routeHandler, isDropDownMenu: false, isLikeButton: false, insteadThumbnail: const Icon(Icons.new_label_outlined, size: 100,));
  } else if (menuSetState == null) {
    throw Exception("menuSetState 잇ㅅ어얀하ㅔ");
  }

  final List<Widget> widgetList = [];

  for (int i = 0; i < sourceVOList.length; i++) {
    final vo = sourceVOList[i];
    // debugConsole([vo.name, vo.isHidden]);
    if (vo.isHidden == true) {
      continue;
    }

    Widget? insteadThumbnail;
    final List<int> showableIndex = [];

    for (int i = 0; i < vo.childrenIndex.length; i++) {
      if (vo.childrenHiddenIndex.contains(i)) {
        continue;
      }
      showableIndex.add(vo.childrenIndex[i]);
    }
    if (showableIndex.isEmpty) {
      insteadThumbnail = const Icon(Icons.image_not_supported_outlined, size: 100,);
    }

    debugConsole([vo.name, showableIndex.isEmpty, insteadThumbnail]);
    final item = Item.playListVOtoListViewItem(context, vo, setStateThen: menuSetState, insteadThumbnail: insteadThumbnail);
    widgetList.add(item);
  }

  if (insertFirst != null) {
    widgetList.add(insertFirst);
  }
  return listViewFrom(widgetList);
}

Widget listViewMusicListVO(List<MusicVO> sourceVOList, BuildContext context, void Function()? menuSetState) {
  return _simpleListViewFromVO(sourceVOList, (cont, vo) => Item.musicVOtoListViewItem(cont, vo as MusicVO, menuSetState), context);
}

Widget listViewMusicListVOFromPlayListVO(PlayListVO playListVO, BuildContext context, void Function()? menuSetState) {
  final List<int> showableIndex = [];

  for (int i = 0; i < playListVO.childrenIndex.length; i++) {
    if (playListVO.childrenHiddenIndex.contains(i)) {
      continue;
    }
    showableIndex.add(playListVO.childrenIndex[i]);
  }

  List<MusicVO> sourceVOList = showableIndex.map((index) => MusicJsonReader.getVOFromIndex(index)!).toList();
  final List<Widget> widgetList = [];

  for (int i = 0; i < sourceVOList.length; i++) {
    final item = Item.musicVOtoListViewItem(
      context,
      null,
      menuSetState,
      playListVO: playListVO,
      musicChildIndex: i,
    );
    widgetList.add(item);
  }

  return listViewFrom(widgetList);
}
