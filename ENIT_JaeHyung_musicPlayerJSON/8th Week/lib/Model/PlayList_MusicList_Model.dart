import 'MusicListRepo.dart';

class Music {
  final String id;
  final String image;
  final String path;
  final String name;
  late String tittle;
  final String length;

  Music({
    required this.id,
    required this.image,
    required this.path,
    required this.name,
    required this.tittle,
    required this.length,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      id: json['id'],
      image: json['image'],
      path: json['path'],
      name: json['name'],
      tittle: json['title'],
      length: json['length'],
    );
  }
}

class PlayList {
  String playlistName;
  late List<String> musicIds;
  late bool heart;

  PlayList({
    required this.playlistName,
    required this.musicIds,
    required this.heart,
  });

  get image => null;
}

class Data {
  init() async {
    musicList = await MusicListRepository.getmusicList() as List<Music>;
    // 초기 플레이리스트 목록을 설정
    if (Data.playList.isEmpty) {
      // 플레이리스트가 비어있으면 새로운 플레이리스트 생성
      PlayList newPlaylist = PlayList(
        playlistName: '기본 플레이리스트',
        musicIds: [],
        heart: false,
      );

      // 뮤직 리스트의 아이디 값을 플레이리스트에 담기
      for (Music music in musicList) {
        newPlaylist.musicIds.add(music.id);
      }

      Data.playList.add(newPlaylist);
    }
  }

  static List<PlayList> playList = [];
  static List<PlayList> hidingList = [];
  static List<Music> musicList = [];

  PlayList findPlaylistByName(String name) {
    return playList.firstWhere((playlist) => playlist.playlistName == name);
  }
}
