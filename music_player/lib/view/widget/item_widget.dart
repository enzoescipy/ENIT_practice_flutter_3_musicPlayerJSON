import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/page/detail/playlist_detail.dart';
import 'package:music_player/view/page/detail/music_detail.dart';
import 'package:music_player/view/page/new_playlist/new_playlist_page.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/static/text_input_formatter.dart' as Format;
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:like_button/like_button.dart';

Future<bool> _changeIsLiked(status) async {
  return Future.value(!status);
}

enum PlayListCRUD { delete, updateTitle, updateChildren, hide }

Widget popupMenuPlayListCRUD(PlayListVO vo, BuildContext context, void Function() setStateThen) {
  return PopupMenuButton<PlayListCRUD>(
    onSelected: (PlayListCRUD selected) {
      switch (selected) {
        case PlayListCRUD.delete:
          VOStageCommitGet.deleteVO(vo);
          VOStageCommitGet.commit();
          setStateThen();
        case PlayListCRUD.updateTitle:
          final textController = TextEditingController();
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("제목을 다시 입력해주세요."),
                  content: TextField(
                    controller: textController,
                    inputFormatters: Format.textFieldFormatKorEngNum,
                    maxLines: 1,
                  ),
                  actions: [
                    MaterialButton(
                        child: Text("제출"),
                        onPressed: () {
                          final currentText = Format.afterSubmitFormatter(textController.text);
                          if (currentText.isEmpty) {
                            return;
                          }
                          VOStageCommitGet.deleteVO(vo);
                          final newVO = vo.copy();
                          newVO.name = currentText;
                          // final newVO = PlayListVO(currentText, vo.childrenIndex);
                          // newVO.likeOrder = vo.likeOrder;
                          VOStageCommitGet.insertVO(newVO);
                          VOStageCommitGet.commit();
                          setStateThen();
                          Navigator.pop(context);
                        })
                  ],
                );
              });
        case PlayListCRUD.updateChildren:
          Navigator.pushNamed(context, NewPlayListPage.routeName, arguments: NewPlayListPageArguments(vo)).then((value) {
            VOStageCommitGet.commit();
            setStateThen();
          });
        default:
          vo.isHidden = true;
          VOStageCommitGet.insertVO(vo);
          VOStageCommitGet.commit();
          setStateThen();
      }
    },
    itemBuilder: (context) => <PopupMenuEntry<PlayListCRUD>>[
      const PopupMenuItem<PlayListCRUD>(
        child: Text(
          "재생목록 삭제",
          style: TextStyle(color: Colors.red),
        ),
        value: PlayListCRUD.delete,
      ),
      const PopupMenuItem<PlayListCRUD>(child: Text("재생목록 제목 수정"), value: PlayListCRUD.updateTitle),
      const PopupMenuItem<PlayListCRUD>(child: Text("재생목록 음악 변경"), value: PlayListCRUD.updateChildren),
      const PopupMenuItem<PlayListCRUD>(child: Text("재생목록 숨기기"), value: PlayListCRUD.hide),
    ],
  );
}

enum MusicCRUD { delete, hide }

/// warning : musicChildIndex is NOT the music's key from DB, it is just position(or target) from playListVO.childrenList!
Widget popupMenuMusicCRUD(PlayListVO playListVO, int musicChildIndex, BuildContext context, void Function() setStateThen) {
  return PopupMenuButton<MusicCRUD>(
      onSelected: (MusicCRUD selected) {
        switch (selected) {
          case MusicCRUD.delete:
            playListVO.childrenIndex.removeAt(musicChildIndex);
            VOStageCommitGet.insertVO(playListVO);
            VOStageCommitGet.commit();
            setStateThen();
          default:
            if (!playListVO.childrenHiddenIndex.contains(musicChildIndex)) {
              playListVO.childrenHiddenIndex.add(musicChildIndex);
              playListVO.childrenHiddenIndex.sort();
              VOStageCommitGet.insertVO(playListVO);
              VOStageCommitGet.commit();
              setStateThen();
            }
        }
      },
      itemBuilder: (context) => <PopupMenuEntry<MusicCRUD>>[
            const PopupMenuItem<MusicCRUD>(
              child: Text(
                "재생목록에서 음악 삭제",
                style: TextStyle(color: Colors.red),
              ),
              value: MusicCRUD.delete,
            ),
            const PopupMenuItem<MusicCRUD>(child: Text("음악 숨기기"), value: MusicCRUD.hide),
          ]);
}

Widget playListVOtoListViewItem(BuildContext context, PlayListVO vo,
    {void Function()? onTapInstead,
    bool isDropDownMenu = true,
    void Function()? setStateThen,
    bool isLikeButton = true,
    Widget? insteadThumbnail}) {
  // get the first element of the playlist
  String? thumbnail_url;
  final firstIndexMusic = vo.childrenIndex.isEmpty ? null : vo.childrenIndex.first;
  if (firstIndexMusic != null) {
    thumbnail_url = MusicJsonReader.getVOFromIndex(firstIndexMusic)?.thumbnail_url;
  }

  final Widget thumbnailWidget;
  if (insteadThumbnail != null) {
    thumbnailWidget = insteadThumbnail;
  } else if (thumbnail_url == null) {
    thumbnailWidget = const Icon(
      Icons.warning,
      size: 100,
    );
  } else {
    thumbnailWidget = Image.network(thumbnail_url, width: 100, height: 100, fit: BoxFit.cover);
  }

  final img = Container(
      margin: const EdgeInsets.all(10), child: ClipRRect(borderRadius: BorderRadius.circular(30), child: thumbnailWidget));

  final itemDescription = Padding(
    padding: const EdgeInsets.all(3.0),
    child: Text(
      vo.name,
      style: Theme.of(context).textTheme.bodySmall,
    ),
  );
  final likeButton = LikeButton(
    isLiked: vo.likeOrder < 0 ? false : true,
    onTap: (isLiked) async {
      if (!isLiked) {
        vo.likeOrder = 1; // make vo.likeorder positive
      } else {
        vo.likeOrder = -1; // make vo.likeorder negative
      }
      VOStageCommitGet.insertVO(vo);
      return _changeIsLiked(isLiked);
    },
  );

  final mixedChildren = [
    Expanded(flex: 4, child: img),
    Flexible(flex: 4, child: itemDescription),
  ];

  // debugConsole([isDropDownMenu, setStateThen]);

  // dropdown selection.
  if (isDropDownMenu == true && setStateThen != null) {
    mixedChildren.add(Flexible(child: popupMenuPlayListCRUD(vo, context, setStateThen)));
  } else if (isDropDownMenu == true && setStateThen == null) {
    throw Exception("isDropDownMenu is true, then setStateThen must be not null");
  }

  // likebutton selction.
  if (isLikeButton) {
    mixedChildren.add(Flexible(flex: 1, child: likeButton));
  }

  return GestureDetector(
    onTap: () {
      if (onTapInstead == null) {
        debugConsole([PlayListDetail.routeName, vo.name, "route pushed"]);
        VOStageCommitGet.commit();
        Navigator.pushNamed(context, PlayListDetail.routeName, arguments: PlayListDetailArguments(vo));
      } else {
        onTapInstead();
      }
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(children: mixedChildren),
      ),
    ),
  );
}

Widget musicVOtoListViewItem(BuildContext context, MusicVO? vo, void Function()? setStateThen,
    {PlayListVO? playListVO, int? musicChildIndex}) {
  // get musicVO from the playListVO if exists
  if (playListVO != null && musicChildIndex != null && vo == null) {
    vo = MusicJsonReader.getVOFromIndex(playListVO.childrenIndex[musicChildIndex]);
  } else if (vo == null) {
    throw Exception("vo is not null except playListVO, musicChildIndex provided.");
  }

  // get the first element of the playlist
  final img = Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(vo!.thumbnail_url, width: 100, height: 35, fit: BoxFit.cover),
      ));

  final itemDescription = Padding(
    padding: const EdgeInsets.all(3.0),
    child: Text(
      vo.name,
      style: Theme.of(context).textTheme.bodySmall,
    ),
  );

  final mixedChildren = [Expanded(child: img), Flexible(child: itemDescription)];

  if (setStateThen != null && playListVO != null && musicChildIndex != null) {
    mixedChildren.add(Flexible(child: popupMenuMusicCRUD(playListVO, musicChildIndex, context, setStateThen)));
  }

  return GestureDetector(
    onTap: () {
      debugConsole([MusicDetail.routeName, vo?.name, "route pushed"]);
      Navigator.pushNamed(context, MusicDetail.routeName, arguments: MusicDetailArguments(vo!));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: mixedChildren,
          // children: [img, itemDescription],
        ),
      ),
    ),
  );
}
