import 'package:music_player/Control/HomeControl.dart';

import '../Model/PlayList_MusicList_Model.dart';

class DetailViewControler {
  void removeMusic(PlayList playlist, String musicId) {
    playlist.musicIds.remove(musicId);
  }

  //음원 이름 수정하기
// 음원 이름 수정하기
  void editMusicTitle(String musicId, String editMusicName) {
    // Data.musicList에서 musicId와 일치하는 음원을 찾음
    for (int i = 0; i < Data.musicList.length; i++) {
      if (Data.musicList[i].id == musicId) {
        Data.musicList[i].tittle = editMusicName;
        print(Data.musicList[i].tittle);
        return; // 찾은 음원을 수정하고 나면 함수를 종료합니다.
      }
    }

    // 찾은 음원이 없는 경우
    print('Error: 음원을 찾을 수 없음');
  }
}
