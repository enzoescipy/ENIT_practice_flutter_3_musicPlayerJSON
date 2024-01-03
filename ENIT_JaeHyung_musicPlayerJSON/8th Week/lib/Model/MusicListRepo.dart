import 'dart:convert';
import 'package:flutter/services.dart';
import '../Model/PlayList_MusicList_Model.dart';

class MusicListRepository {
  static Future<List<Music>> getmusicList() async {
    try {
      String jsonString = await rootBundle.loadString('lib/assets/music.json');
      List<dynamic> jsonResponse = json.decode(jsonString);

      // 데이터가 없거나 잘못된 형식의 경우 예외를 발생시킵니다.
      if (jsonResponse == null || !(jsonResponse is List)) {
        throw FormatException("Invalid JSON format");
      }

      // 정상적인 경우 Music 객체로 변환하여 리스트를 반환합니다.
      return jsonResponse.map((json) => Music.fromJson(json)).toList();
    } catch (e) {
      // 예외 처리
      print("Error loading music list: $e");
      return []; // 에러 발생 시 빈 리스트 반환
    }
  }
}
