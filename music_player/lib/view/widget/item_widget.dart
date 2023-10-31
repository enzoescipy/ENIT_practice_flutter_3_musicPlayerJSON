import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/view/static/myOrdinaryStyle.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:like_button/like_button.dart';

Future<bool> _changeIsLiked(status) async {
  return Future.value(!status);
}

Widget playListVOtoListViewItem(BuildContext context, PlayListVO vo) {
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
        child: thumbnail_url == null ? Image.network(thumbnail_url!, width: 150, height: 150, fit: BoxFit.cover) : const Icon(Icons.not_started_rounded)),
  );

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
        VOStageCommitGet.insertVO(vo);
      } else {
        VOStageCommitGet.deleteVO(vo);
      }
      return _changeIsLiked(isLiked);
    },
  );

  return GestureDetector(
    // onTap: () {
    //   Navigator.pushNamed(context, ImagePage.ImageDetail.routeName, arguments: ImagePage.ImageDetailArguments(vo));
    // },
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: RoundyDecoration.containerDecoration(WinterGreenColor.deepGrayBlue.withAlpha(20)),
        margin: const EdgeInsets.all(8.0),
        child: Row(
          children: [Expanded(flex: 4, child: img), Flexible(flex: 4, child: itemDescription), Flexible(flex: 1, child: likeButton)],
        ),
      ),
    ),
  );
}
