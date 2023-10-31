import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
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

/// if sourceVOList not provided, function will use widgetList by ListView children.
/// if sourceVOList provided, function will use sourceVOList to build items,
/// append them inside widgetList, and then render it.
/// (if sourceVOList provided, context must not be null.)
Widget _listView(List<VO> sourceVOList, Widget Function(BuildContext, VO) toItemFunc,BuildContext context) {
  final widgetList = sourceVOList.map((vo) => toItemFunc(context, vo)).toList();
  return Expanded(child: ListView(children: widgetList));
}

/// if sourceVOList not provided, function will use widgetList by ListView children.
/// if sourceVOList provided, function will use sourceVOList to build items,
/// append them inside widgetList, and then render it.
/// (if sourceVOList provided, context must not be null.)
Widget listViewPlayListVO(List<PlayListVO> sourceVOList,BuildContext context) {
  return _listView(sourceVOList, (cont, vo) => Item.playListVOtoListViewItem(cont, vo as PlayListVO), context);
}

Widget listViewMusicListVO(List<MusicVO> sourceVOList,BuildContext context) {
  return _listView(sourceVOList, (cont, vo) => Item.musicVOtoListViewItem(cont, vo as MusicVO), context);
}