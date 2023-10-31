import 'package:flutter/material.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/mainView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/model/hive_controle.dart';

import 'package:music_player/controller/temporary_music_json_reader.dart';

void main() async {
  enableDebug();
  await Hive.initFlutter();
  await MusicJsonReader.InitializeReader();
  await HIVEController.initializeHive();

  await HIVEController.clearHive();
  DEBUG();
  runApp(const MyApp());
}

void DEBUG() async {
  enableDebug();
  final tempVO = [
    PlayListVO("debugName0", const []),
    PlayListVO("debugName1", const [1, 0, 2]),
  ];

  VOStageCommitGet.insertVO(tempVO[0]);
  VOStageCommitGet.insertVO(tempVO[1]);
  VOStageCommitGet.commit();
}
