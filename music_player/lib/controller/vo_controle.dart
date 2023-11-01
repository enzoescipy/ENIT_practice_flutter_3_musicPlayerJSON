import 'package:flutter/material.dart';
import 'package:music_player/package/debugConsole.dart';
import 'package:music_player/model/vo.dart';
import 'package:music_player/model/hive_controle.dart';

// int _debugCount = 9;

// /// make the debug-only meaningless VO object.
// dynamic getDebugVO(bool whichVO, {bool isLiked = false}) {
//   _debugCount++;
//   if (_debugCount > 100) {
//     throw Exception("no over 90 debug Obj not allowed");
//   }
//   if (whichVO) {
//     final imageVO = ImageVO(
//         "$_debugCount url",
//         "20${_debugCount.toString()}-11-22",
//         "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSu_lrik6ff2CC0Og2xVh6iwQHo-S-JTFHGvw&usqp=CAU",
//         "https://i1.sndcdn.com/artworks-8hUNunJfPf7jLpzY-jYmGvg-t500x500.jpg",
//         "test $_debugCount");
//     if (isLiked == true) {
//       imageVO.likeOrder = _debugCount;
//     }

//     return imageVO;
//   } else {
//     final webVO = WebVO("$_debugCount url", "20${_debugCount.toString()}-11-22", "$_debugCount title",
//         "$_debugCount contents is very Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.");
//     if (isLiked == true) {
//       webVO.likeOrder = _debugCount;
//     }

//     return webVO;
//   }
// }

enum StagedType { insert, delete }

class VOStageCommitGet {
  /// this field's children are:
  /// [enum StagedType, VO vo]
  /// for the which vo to stage, and which action to perform.
  static List<List> stagedList = [];
  static int likeOrder = -1;

  static void insertVO(VO vo) {
    // check if vo is imageVO or WebVO
    // currently, only the PlayListVO is the DB-store needed VO.
    // so, vo is the PlayListVO.

    if (vo is! PlayListVO) {
      throw Exception("vo must be the PlayListVO");
    }

    // Auto increase the like order and change vo's likeorder
    if (vo.likeOrder >= 0) {
      likeOrder++;
      vo.likeOrder = likeOrder;
    }

    // search if there are some VO already inserted/deleted before.
    bool isAlreadyVOStaged = false;
    for (int i = 0; i < stagedList.length; i++) {
      var stage = stagedList[i];
      final StagedType stageType = stage[0];
      final VO stagedVO = stage[1];

      if (stagedVO.name == vo.name && stagedVO.whichVO == vo.whichVO) {
        // this means there already staged action for this vo.
        isAlreadyVOStaged = true;
        if (stageType == StagedType.delete) {
          stagedList.removeAt(i);
          i--;
        }
        break;
      }
    }

    // debugConsole([vo.name, (vo as PlayListVO).isHidden]);
    if (isAlreadyVOStaged == false) {
      stagedList.add([StagedType.insert, vo]);
    }
  }

  static void deleteVO(dynamic vo) {
    // check if vo is imageVO or WebVO
    // currently, only the PlayListVO is the DB-store needed VO.
    // so, vo is the PlayListVO.
    if (vo is! PlayListVO) {
      throw Exception("vo must be the PlayListVO");
    }

    // search if there are some VO already inserted/deleted before.
    bool isAlreadyVOStaged = false;
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stagedVO.name == vo.name && stagedVO.whichVO == vo.whichVO) {
        // this means there already staged action for this vo.
        isAlreadyVOStaged = true;
        if (stageType == StagedType.insert) {
          stagedList.removeAt(i);
          i--;
        }
        break;
      }
    }
    if (isAlreadyVOStaged == false) {
      // this means vo is new for stagedList.
      stagedList.add([StagedType.delete, vo]);
    }
  }

  static void commit() {
    // debugConsole(stagedList);
    for (int i = 0; i < stagedList.length; i++) {
      final VO stagedVO = stagedList[i][1];
      final StagedType stageType = stagedList[i][0];
      if (stageType == StagedType.insert) {
        // debugConsole([stagedVO.name, (stagedVO as PlayListVO).isHidden, (stagedVO as PlayListVO).childrenHiddenIndex]);
        HIVEController.insertVO(stagedVO);
      } else {
        HIVEController.deleteVO(stagedVO);
      }
    }
    stagedList.clear();
  }

  /// get the all of VO , by decending order of likeOrder.
  static List<PlayListVO> getAll() {
    // VOType? specificType) {
    // debugConsole("getAll called");
    // get and convert
    final mapListAll = HIVEController.getAll(null);
    List<PlayListVO> voListAll = [];
    mapListAll.forEach((map) {
      // var newVO = PlayListVO(map["name"], map["childrenIndex"]);
      // newVO.likeOrder = map["likeOrder"];
      var newVO = PlayListVO.fromMap(map);
      voListAll.add(newVO);
    });

    voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
    return voListAll;
  }

  /// get only liked vo.
  static List<PlayListVO> getLiked() {
    final mapListAll = HIVEController.getAll(null);
    List<PlayListVO> voListAll = [];
    mapListAll.forEach((map) {
      // var newVO = PlayListVO(map["name"], map["childrenIndex"]);
      // newVO.likeOrder = map["likeOrder"];
      var newVO = PlayListVO.fromMap(map);
      if (newVO.likeOrder >= 0) {
        voListAll.add(newVO);
      }
    });

    voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
    // debugConsole(voListAll.map((e) => e.likeOrder).toList());
    return voListAll;
  }

  // static List getImageVoAll() {
  //   // get and convert
  //   final mapListAll = HIVEController.getAll(true);
  //   var voListAll = [];
  //   mapListAll.forEach((map) {
  //     if (map["whichVO"] == true) {
  //       var newVO = ImageVO(map["doc_url"]!, map["datetime"]!, map["thumbnail_url"]!, map["image_url"]!, map["name"]!);
  //       voListAll.add(newVO);
  //     }
  //   });

  //   voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
  //   return voListAll;
  // }

  // static List getWebVoAll() {
  //   // get and convert
  //   final mapListAll = HIVEController.getAll(false);
  //   var voListAll = [];
  //   mapListAll.forEach((map) {
  //     if (map["whichVO"] == false) {
  //       var newVO = WebVO(map["url"]!, map["datetime"]!, map["title"]!, map["contents"]!);
  //       voListAll.add(newVO);
  //     }
  //   });

  //   voListAll.sort((a, b) => a.likeOrder.compareTo(b.likeOrder));
  //   return voListAll;
  // }
}
