import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/page/detail/playlist_detail.dart';
import 'package:music_player/view/page/detail/music_detail.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:like_button/like_button.dart';

Future<bool> _changeIsLiked(status) async {
  return Future.value(!status);
}

enum PlayListCRUD { delete, update }

Widget popupMenuPlayListCRUD() {
  return PopupMenuButton<PlayListCRUD>(
      onSelected: (PlayListCRUD selected) {
        //TODO
        VOStageCommitGet.commit();
      },
      itemBuilder: (context) => <PopupMenuEntry<PlayListCRUD>>[
            const PopupMenuItem<PlayListCRUD>(
              child: Text("delete"),
              value: PlayListCRUD.delete,
            ),
            const PopupMenuItem<PlayListCRUD>(child: Text("update"), value: PlayListCRUD.update),
          ]);
}

enum MusicCRUD { delete, update }

Widget popupMenuMusicCRUD() {
  return PopupMenuButton<MusicCRUD>(
      onSelected: (MusicCRUD selected) {
        //TODO
        VOStageCommitGet.commit();
      },
      itemBuilder: (context) => <PopupMenuEntry<MusicCRUD>>[
            const PopupMenuItem<MusicCRUD>(
              child: Text("delete"),
              value: MusicCRUD.delete,
            ),
            const PopupMenuItem<MusicCRUD>(child: Text("update"), value: MusicCRUD.update),
          ]);
}

Widget playListVOtoListViewItem(BuildContext context, PlayListVO vo, {void Function()? onTapInstead, bool isDropDownMenu = true}) {
  // get the first element of the playlist
  String? thumbnail_url;
  final firstIndexMusic = vo.childrenIndex.isEmpty ? null : vo.childrenIndex.first;
  if (firstIndexMusic != null) {
    thumbnail_url = MusicJsonReader.getVOFromIndex(firstIndexMusic)?.thumbnail_url;
  }

  final img = Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: thumbnail_url == null
            ? const Icon(
                Icons.not_started_rounded,
                size: 100,
              )
            : Image.network(thumbnail_url, width: 100, height: 100, fit: BoxFit.cover),
      ));

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
    Flexible(flex: 1, child: likeButton),
  ];
  if (isDropDownMenu) {
    mixedChildren.add(Flexible(child: popupMenuMusicCRUD()));
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

Widget musicVOtoListViewItem(BuildContext context, MusicVO vo) {
  // get the first element of the playlist
  final img = Container(
      margin: const EdgeInsets.all(10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(vo.thumbnail_url, width: 100, height: 35, fit: BoxFit.cover),
      ));

  final itemDescription = Padding(
    padding: const EdgeInsets.all(3.0),
    child: Text(
      vo.name,
      style: Theme.of(context).textTheme.bodySmall,
    ),
  );

  return GestureDetector(
    onTap: () {
      debugConsole([MusicDetail.routeName, vo.name, "route pushed"]);
      Navigator.pushNamed(context, MusicDetail.routeName, arguments: MusicDetailArguments(vo));
    },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [Expanded(child: img), Flexible(child: itemDescription), Flexible(child: popupMenuMusicCRUD())],
          // children: [img, itemDescription],
        ),
      ),
    ),
  );
}
