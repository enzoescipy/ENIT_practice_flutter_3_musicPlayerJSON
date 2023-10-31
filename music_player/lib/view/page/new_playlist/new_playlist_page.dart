import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/widget/item_widget.dart' as Item;
import 'package:music_player/view/widget/page_component.dart' as Component;

class NewPlayListPage extends StatefulWidget {
  const NewPlayListPage({super.key});
  static const routeName = '/MusicDetail';

  @override
  State<NewPlayListPage> createState() => _NewPlayListPageState();
}

class _NewPlayListPageState extends State<NewPlayListPage> {
  int _stageNum = 0;
  late final PlayListVO handlingVO;

  /// each indices are music vo indices from DB, and value is "if that musicVO is included with the playlist"
  late List<bool> _musicVOIndexAll;
  late List<MusicVO> _musicVOList;
  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _musicVOList = MusicJsonReader.getAll();
    _musicVOIndexAll = _musicVOList.map((vo) => false).toList();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [Component.appBar(context)];
    switch (_stageNum) {
      case 0:
        children.add(askNameOfPlayList());
      default:
        children.add(selectMusicIncluded());
    }

    return Material(
      child: Column(children: children),
    );
  }

  void onSubmitMusic() {
    _stageNum = 0;
    _musicVOList = MusicJsonReader.getAll();
    _musicVOIndexAll = _musicVOList.map((vo) => false).toList();
    Navigator.pop(context);
  }

  Widget selectMusicIncluded() {
    debugConsole("Called!!");

    final widgetList = _musicVOList.map((vo) => Item.musicVOtoListViewItem(context, vo)).toList();
    final List<Widget> widgetWithCheckBoxList = [];
    for (int i = 0; i < widgetList.length; i++) {
      widgetWithCheckBoxList.add(Row(children: [
        Expanded(flex: 4, child: widgetList[i]),
        Flexible(
          flex: 1,
          child: Checkbox(
              value: _musicVOIndexAll[i],
              onChanged: (bool? value) {
                setState(() {
                  _musicVOIndexAll[i] = value!;
                });
              }),
        )
      ]));
    }

    final textWidget = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: const Text("원하는 음악을 체크한 뒤 제출!"),
    );

    final submit = ElevatedButton(
      onPressed: onSubmitMusic,
      child: const Icon(Icons.search),
    );

    return Flexible(
      child: Column(
        children: [
          Flexible(
            flex: 1,
            child: Row(
              children: [textWidget, submit],
            ),
          ),
          Component.listViewFrom(widgetWithCheckBoxList),
        ],
      ),
    );
  }

  void onSubmitTitle() {
    final text = _textController.text.replaceAll(RegExp(r"[ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]"), "");
    if (text.isEmpty) {
      return;
    }
    setState(() {
      handlingVO = PlayListVO(text, []);
      _stageNum++;
    });
  }

  Widget askNameOfPlayList() {
    final textWidget = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: const Text("플레이 리스트의 제목을 적어주세요!"),
    );

    final textField = Container(
      width: 250,
      padding: const EdgeInsets.only(right: 20),
      child: TextField(
        controller: _textController,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-z|A-Z|0-9|ㄱ-ㅎ|ㅏ-ㅣ|가-힣|ᆞ|ᆢ|ㆍ|ᆢ|ᄀᆞ|ᄂᆞ|ᄃᆞ|ᄅᆞ|ᄆᆞ|ᄇᆞ|ᄉᆞ|ᄋᆞ|ᄌᆞ|ᄎᆞ|ᄏᆞ|ᄐᆞ|ᄑᆞ|ᄒᆞ]'))],
        style: Theme.of(context).textTheme.bodyMedium,
        maxLines: 1,
      ),
    );

    final submit = ElevatedButton(
      onPressed: onSubmitTitle,
      child: const Icon(Icons.search),
    );

    return Container(
      color: Theme.of(context).colorScheme.background,
      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
      child: Column(
        children: [
          textWidget,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textField,
              submit,
            ],
          ),
        ],
      ),
    );
  }
}
