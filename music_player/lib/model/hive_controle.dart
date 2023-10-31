import 'package:hive_flutter/hive_flutter.dart';
import 'vo.dart';

/// RULE : DO NOT USE the box.put() for insertion.
/// only use the box.add() for insertion. (however update or override, put() can be used.)
/// from that rule, the key will be set auto-increase by hive.

class HIVEController {
  static Box<Map>? box;
  static const mainBoxName = "main";

  static int likeOrder = -1;

  /// this asynchronous function must be called and returned before calling other function.
  static Future<void> initializeHive() async {
    box = await Hive.openBox<Map>(mainBoxName);
  }

  static Future<void> clearHive() async {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }
    await box?.clear();
  }

  static Map? getSingleVO(dynamic key) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    return box!.get(key);
  }

  /// get the all of vo from the box.
  /// if param is true or false,
  ///   - true : get only for image VO.
  ///   - false : get only for web VO.
  static List<Map> getAll(VOType? whichVO) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    if (whichVO == null) {
      return box!.values.toList();
    } else {
      return box!.values.where((map) => map["whichVO"] == whichVO).toList();
    }
  }

  /// find and return VO Key by its name and whichVO.
  /// Return:
  ///   unsigned int : object found.
  ///   null : object not found.
  static int? findVOKeybyName(String name, VOType whichVO) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }
    var boxKeyList = box!.keys.toList();

    for (int i = 0; i < box!.keys.length; i++) {
      final key = boxKeyList[i];
      final voMap = box!.get(key);
      if (voMap == null) {
        continue;
      }
      if (voMap["name"] == name && voMap["whichVO"] == whichVO) {
        return key;
      }
    }
    return null;
  }

  /// insert, or update the ImageVO in the hive box.
  /// in this case, likeOrder of vo is defined automatically by controller.
  /// (inserting vo will reguarded as being liked)
  /// and, likeOrder will be always >= 0.
  static void insertVO(VO vo) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    // search if there are already vo inside the hive box.
    final key = findVOKeybyName(vo.name, vo.whichVO);
    // Auto increase the like order
    likeOrder++;
    // turn VO into the compatible Map object.
    final voMap = vo.toMap();
    
    // put voMap in the box
    // if vo already exists, override that.
    if (key != null) {
      box!.put(key, voMap);
      return;
    }
    box!.add(voMap);
  }

  static void deleteVO(VO vo) {
    // if box not initialized, throw.
    if (box == null) {
      throw Exception("box has not initialized before. please call initializeHive() and check if returned ");
    }

    // search if there are already vo inside the hive box.
    final key = findVOKeybyName(vo.name, vo.whichVO);
    if (key != null) {
      box!.delete(key);
    }
  }
}
