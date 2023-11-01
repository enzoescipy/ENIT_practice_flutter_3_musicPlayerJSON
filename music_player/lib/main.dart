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

  // await HIVEController.clearHive();
  // DEBUG();
  runApp(const MyApp());
}

void DEBUG() {
  enableDebug();
  final tempVO = [
    PlayListVO("debugName0", const []),
    PlayListVO("debugName1", const [1, 0, 2]),
    PlayListVO("debugHidden", const [2]),
    PlayListVO("debugHiddenchildren", const [2, 4]),
  ];
  tempVO[2].childrenHiddenIndex.add(0);
  tempVO[2].isHidden = true;
  tempVO[3].childrenHiddenIndex.add(0);
  tempVO[3].childrenHiddenIndex.add(1);

  VOStageCommitGet.insertVO(tempVO[0]);
  VOStageCommitGet.insertVO(tempVO[1]);
  VOStageCommitGet.insertVO(tempVO[2]);
  VOStageCommitGet.insertVO(tempVO[3]);
  VOStageCommitGet.commit();
  debugConsole(VOStageCommitGet.getAll().map((e) => e.isHidden));
}
