import '../Model/MusicListRepo.dart';
import '../Model/PlayList_MusicList_Model.dart';

class HomeViewData {
  static var playlistCount = Data.playList.length;

  void AddPlayListName(String playlistName) {
    // 새로운 플레이리스트 이름을 사용하여 PlayList 객체를 생성
    PlayList newPlayList =
        PlayList(playlistName: playlistName, musicIds: [], heart: false);

    // 새로운 플레이리스트를 기존 플레이리스트 목록에 추가
    Data.playList.add(newPlayList);
  }

  void DeletePlayList(int index) {
    Data.playList.removeAt(index);
  }

  void HidePlayList(int index) {
    try {
      PlayList hidePlayList = Data.playList[index]; // 항목 저장
      Data.playList.removeAt(index); // 리스트에서 항목 제거
      Data.hidingList.add(hidePlayList); // hidingList에 저장된 항목 추가
    } catch (e) {
      print('숨기기 오류 발생');
    }
  }

  void ShowHidingPlayList() async {
    for (PlayList hpl in Data.hidingList) {
      PlayList addedPlayList = hpl;
      Data.hidingList.remove(hpl);
      Data.playList.add(addedPlayList);
    }
  }

  void RenamePlayList(int index, String newName) {
    if (newName != null && newName.isNotEmpty) {
      Data.playList[index].playlistName = newName;
    } else {}
  }

  void HeartButtonReaction(int index) {
    Data.playList[index].heart = !Data.playList[index].heart;
  }

  String findImagePath(PlayList playlist) {
    if (playlist.musicIds.isNotEmpty) {
      // 플레이리스트에 음악이 있는 경우 첫 번째 음악 ID를 가져옵니다.
      String firstMusicId = playlist.musicIds[0];

      // 해당 음악 ID에 해당하는 Music 객체를 찾습니다.
      Music firstMusic =
          Data.musicList.firstWhere((music) => music.id == firstMusicId);

      // 음악의 이미지 경로를 반환합니다.
      return firstMusic.image;
    } else {
      // 플레이리스트에 음악이 없는 경우 기본 이미지 경로 또는 다른 처리를 수행할 수 있습니다.
      return 'defaultImagePath';
    }
  }
}
