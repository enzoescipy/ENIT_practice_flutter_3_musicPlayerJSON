import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:music_player/model/vo.dart';

//...
Future<List> parseJsonFromAssets(String assetsPath) async {
  return rootBundle.loadString(assetsPath).then((jsonStr) => jsonDecode(jsonStr));
}

class MusicJsonReader {
  static List<MusicVO> musicVOList = [];
  static Future<void> InitializeReader() async {
    List musicJson = await parseJsonFromAssets('asset/music_list.json');
    musicVOList = musicJson.map((map) => MusicVO.fromMap(map)).toList();
  }

  static MusicVO? getVOFromIndex(int index) {
    if (musicVOList.length < index) {
      return null;
    } else if (index < 0) {
      throw Exception("인덱스 똑버러");
    }
    return musicVOList[index];
  }

  static List<MusicVO> getAll() {
    return musicVOList;
  }
}