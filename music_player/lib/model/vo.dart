enum VOType { music, playList }

abstract class VO {
  late VOType whichVO; // indicate the type of vo
  late String name; // unique string tag amoung the VO group.

  VO(this.name);

  VO.fromMap(Map<String, dynamic> map);

  Map<String, dynamic> toMap() {
    return {"whichVO": whichVO, "name": name};
  }
}

class MusicVO extends VO {
  late String music_id;
  late String thumbnail_url;
  late String music_path;
  late String author;
  late String length;

  MusicVO(String name, this.thumbnail_url, this.author, this.length, this.music_id, this.music_path) : super(name) {
    whichVO = VOType.music;
    this.name = name;
  }

  @override
  MusicVO.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    whichVO = VOType.music;
    name = map["title"];
    thumbnail_url = map["image"];
    author = map["name"];
    length = map["length"];
    music_id = map["id"];
    music_path = map["path"];
  }

  @override
  Map<String, dynamic> toMap() {
    final basicMap = super.toMap();
    basicMap["image"] = thumbnail_url;
    basicMap["name"] = author;
    basicMap["title"] = name;
    basicMap["length"] = length;
    basicMap["id"] = music_id;
    basicMap["path"] = music_path;

    return basicMap;
  }

  // @override
  // String toString() {
  //   return "$whichVO, $likeOrder, $url, $dateTime, $thumbnailURL, $imageURL, $name";
  // }
}

class PlayListVO extends VO {
  int likeOrder = -1;
  final List<int> childrenIndex = [];

  PlayListVO(String name, List<int> childrenIndex) : super(name) {
    this.name = name;
    whichVO = VOType.playList;
    this.childrenIndex.addAll(childrenIndex);
  }

  @override
  PlayListVO.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    name = map["name"];
    whichVO = VOType.playList;
    likeOrder = map["likeOrder"];
    childrenIndex.clear();
    childrenIndex.addAll(map["childrenIndex"]);
  }

  @override
  Map<String, dynamic> toMap() {
    final basicMap = super.toMap();
    basicMap["likeOrder"] = likeOrder;
    basicMap["childrenIndex"] = childrenIndex;

    return basicMap;
  }

  // @override
  // String toString() {
  //   return "$whichVO, $likeOrder, $url, $dateTime, $title, $contents";
  // }
}
