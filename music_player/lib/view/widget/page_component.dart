import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
import 'package:music_player/view/page/new_playlist/new_playlist_page.dart';

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
  return Expanded(child: ListView(children: widgetList));
}


Widget listViewPlayListVO(List<PlayListVO> sourceVOList, BuildContext context, {bool isNewPlayListEnable = false}) {
  Widget? insertFirst = null;
  if (isNewPlayListEnable) {
    final tempVO = PlayListVO("새로운 플레이리스트 만들기", []);

    void _makeNewPlayListRoute() {
      Navigator.pushNamed(context, NewPlayListPage.routeName);
    }

    insertFirst = Item.playListVOtoListViewItem(context, tempVO, onTapInstead:_makeNewPlayListRoute);
  }
  return _simpleListViewFromVO(sourceVOList, (cont, vo) => Item.playListVOtoListViewItem(cont, vo as PlayListVO), context, insertFirst: insertFirst);
}

Widget listViewMusicListVO(List<MusicVO> sourceVOList, BuildContext context) {
  return _simpleListViewFromVO(sourceVOList, (cont, vo) => Item.musicVOtoListViewItem(cont, vo as MusicVO), context);
}

