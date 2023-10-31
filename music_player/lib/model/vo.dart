enum VOType { music, playList }

abstract class VO {
  late VOType whichVO; // indicate the type of vo
  late String name; // unique string tag amoung the VO group.

  VO(this.name);

  VO.fromMap(Map<String, dynamic> map) {
    name = map["name"];
  }

  Map<String, dynamic> toMap() {
    return {"whichVO": whichVO, "name": name};
  }
}

class MusicVO extends VO {
  late String thumbnail_url;
  late String author_lyrics;
  late String author_melody;

  MusicVO(String name, this.thumbnail_url, this.author_lyrics, this.author_melody) : super(name) {
    whichVO = VOType.music;
    this.name = name;
  }

  @override
  MusicVO.fromMap(Map<String, dynamic> map) : super.fromMap(map) {
    whichVO = VOType.music;
    thumbnail_url = map["thumbnail_url"];
    author_lyrics = map["author_lyrics"];
    author_melody = map["author_melody"];
  }

  @override
  Map<String, dynamic> toMap() {
    final basicMap = super.toMap();
    basicMap["thumbnail_url"] = thumbnail_url;
    basicMap["author_lyrics"] = author_lyrics;
    basicMap["author_melody"] = author_melody;

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
