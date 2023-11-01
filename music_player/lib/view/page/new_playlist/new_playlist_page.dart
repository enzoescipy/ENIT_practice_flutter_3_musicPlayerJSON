import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/view/static/text_input_formatter.dart' as Format;

import 'package:music_player/view/page/main/playlist_page.dart';

import 'package:music_player/view/widget/item_widget.dart' as Item;
import 'package:music_player/view/widget/page_component.dart' as Component;

class NewPlayListPageArguments {
  final PlayListVO? playListVO;
  NewPlayListPageArguments(this.playListVO);
}

class NewPlayListPage extends StatefulWidget {
  const NewPlayListPage({super.key});
  static const routeName = '/NewPlayListPage';

  @override
  State<NewPlayListPage> createState() => _NewPlayListPageState();
}

class _NewPlayListPageState extends State<NewPlayListPage> {
  int _stageNum = 0;
  PlayListVO? playListVO;

  /// each indices are music vo indices from DB, and value is "if that musicVO is included with the playlist"
  final List<bool> _musicVOIndexBoolAll = [];
  final List<MusicVO> _musicVOList = [];
  final _textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _musicVOList.addAll(MusicJsonReader.getAll());
    _musicVOIndexBoolAll.addAll(_musicVOList.map((vo) => false).toList());

    Future.delayed(Duration.zero, () {
      final PlayListVO? playListVOFromArg = (ModalRoute.of(context)!.settings.arguments as NewPlayListPageArguments).playListVO;
      // initialize params
      playListVO = playListVOFromArg;
      if (playListVO != null) {
        _musicVOList.clear();
        _musicVOIndexBoolAll.clear();
        _musicVOList.addAll(MusicJsonReader.getAll());
        _musicVOIndexBoolAll.addAll(_musicVOList.map((vo) => false).toList());

        // convert index list to the boolean list
        for (int i = 0; i < playListVO!.childrenIndex.length; i++) {
          int index = playListVO!.childrenIndex[i];
          _musicVOIndexBoolAll[index] = true;
        }

        setState(() {
          _stageNum = 1;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> children = [Component.appBar(context, title: "플레이 리스트 만들기", isbackButton: true)];

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
    // convert the boolean list to index list
    playListVO!.childrenIndex.clear();
    for (int i = 0; i < _musicVOIndexBoolAll.length; i++) {
      if (_musicVOIndexBoolAll[i] == true) {
        playListVO!.childrenIndex.add(i);
      }
    }

    // save to DB
    VOStageCommitGet.insertVO(playListVO!);
    VOStageCommitGet.commit();

    // initialization
    _stageNum = 0;
    _musicVOList.clear();
    _musicVOIndexBoolAll.clear();
    _musicVOList.addAll(MusicJsonReader.getAll());
    _musicVOIndexBoolAll.addAll(_musicVOList.map((vo) => false).toList());

    // route
    Navigator.pop(context);
  }

  Widget selectMusicIncluded() {
    // debugConsole("Called!!");

    final widgetList = _musicVOList.map((vo) => Item.musicVOtoListViewItem(context, vo, null)).toList();
    final List<Widget> widgetWithCheckBoxList = [];
    for (int i = 0; i < widgetList.length; i++) {
      widgetWithCheckBoxList.add(Row(children: [
        Expanded(flex: 4, child: widgetList[i]),
        Flexible(
          flex: 1,
          child: Checkbox(
              value: _musicVOIndexBoolAll[i],
              onChanged: (bool? value) {
                debugConsole(value);
                setState(() {
                  _musicVOIndexBoolAll[i] = value!;
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
    final text = Format.afterSubmitFormatter(_textController.text);
    if (text.isEmpty) {
      return;
    }
    setState(() {
      playListVO = PlayListVO(text, []);
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
        inputFormatters: Format.textFieldFormatKorEngNum,
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
