import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;
import 'package:music_player/view/widget/item_widget.dart' as Item;
import 'package:music_player/controller/vo_controle.dart';

class PlayListPage extends StatefulWidget {
  const PlayListPage({super.key});

  @override
  State<PlayListPage> createState() => _PlayListPageState();
}

class _PlayListPageState extends State<PlayListPage> {
  final List<PlayListVO> _contentVOList = [
    PlayListVO("debugName0", const [0])
  ];

  final List<Widget> _contentWidgetList = [];

  // final List<Widget> _contentWidgetList = _contentVOList.map((vo) => Item.playListVOtoListViewItem(context, vo)).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Component.appBar(context, title: "플레이 리스트"), Component.listView(_contentWidgetList, sourceVOList: _contentVOList, context: context)],
    );
  }
}
