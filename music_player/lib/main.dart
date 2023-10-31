import 'package:flutter/material.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/view/mainView.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:music_player/controller/vo_controle.dart';
import 'package:music_player/model/hive_controle.dart';

import 'package:music_player/controller/temporary_music_json_reader.dart';

void main() async {
  enableDebug();
  await Hive.initFlutter();
  await MusicJsonReader.InitializeReader();
  await HIVEController.initializeHive();
  // DEBUG();
  await HIVEController.clearHive();
  runApp(const MyApp());
}

void DEBUG() async {
  enableDebug();
  var parsedJson = await parseJsonFromAssets("asset/music_list.json");
  debugConsole(parsedJson.length);
  debugConsole(parsedJson);
}
