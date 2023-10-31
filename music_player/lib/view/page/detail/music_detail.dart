import 'package:flutter/material.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/controller/temporary_music_json_reader.dart';
import 'package:music_player/view/widget/page_component.dart' as Component;

class MusicDetailArguments {
  final MusicVO musicVO;
  MusicDetailArguments(this.musicVO);
}


class MusicDetail extends StatefulWidget {
  const MusicDetail({super.key});
  static const routeName = '/MusicDetail';

  @override
  State<MusicDetail> createState() => _MusicDetailState();
}

class _MusicDetailState extends State<MusicDetail> {
  @override
  Widget build(BuildContext context) {
    final MusicVO musicVO = (ModalRoute.of(context)!.settings.arguments as MusicDetailArguments).musicVO;
    final img = Container(
      padding: const EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height * 0.6,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.network(
            musicVO.thumbnail_url,
            fit: BoxFit.cover,
          )),
    );

    final body = Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              musicVO.name,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Text(
              "${musicVO.author}\n${musicVO.length}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );

    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          Component.appBar(context, title: "음악 상세", isbackButton: true),
          img,
          body,
        ],
      ),
    );
  }
}