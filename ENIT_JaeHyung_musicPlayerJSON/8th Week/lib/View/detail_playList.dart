import 'package:flutter/material.dart';
import 'package:music_player/Model/PlayList_MusicList_Model.dart';
import 'package:music_player/Control/DetailControl.dart';

class DetailPlaylistWidget extends StatefulWidget {
  final String playlistName;

  DetailPlaylistWidget({required this.playlistName});

  @override
  DetailPlaylistWidgetState createState() => DetailPlaylistWidgetState();
}

class DetailPlaylistWidgetState extends State<DetailPlaylistWidget> {
  late PlayList playlist;
  List<String> addMusicIdList = []; // 선택한 음원의 id 목록을 저장

  @override
  void initState() {
    super.initState();
    playlist = Data().findPlaylistByName(widget.playlistName);
    print('Playlist Name: ${playlist.playlistName}');

    if (playlist.musicIds.isNotEmpty) {
      print('Music IDs:');
      for (String musicId in playlist.musicIds) {
        print('- $musicId');
      }
    } else {
      print('Playlist is empty.');
    }
  }

  // 함수: 음원 추가 팝업
  void _showAddMusicPopup() {
    List<bool> isCheckedList = List.filled(Data.musicList.length, false);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Scaffold(
              appBar: AppBar(
                title: Text('음원 추가'),
              ),
              body: ListView.builder(
                itemCount: Data.musicList.length,
                itemBuilder: (context, index) {
                  Music music = Data.musicList[index];

                  return ListTile(
                    leading: Image.network(music.image),
                    title: Text(music.tittle),
                    subtitle: Text(music.name),
                    trailing: Checkbox(
                      value: isCheckedList[index],
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedList[index] = value ?? false;

                          if (isCheckedList[index]) {
                            addMusicIdList.add(music.id);
                          } else {
                            addMusicIdList.remove(music.id);
                          }

                          print(addMusicIdList);
                        });
                      },
                    ),
                  );
                },
              ),
              bottomNavigationBar: BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          PlayList playlist =
                              Data().findPlaylistByName(widget.playlistName);

                          playlist.musicIds.addAll(addMusicIdList);
                        });
                        addMusicIdList.clear();
                        isCheckedList =
                            List.filled(Data.musicList.length, false);

                        // Navigator.pop 이후에도 DetailPlaylistWidget의 상태를 갱신
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPlaylistWidget(
                              playlistName: widget.playlistName,
                            ),
                          ),
                        );
                      },
                      child: Text('완료'),
                    ),
                    TextButton(
                      onPressed: () {
                        addMusicIdList.clear();
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEditMusicNamePopup(var musicId) async {
    String? newMusicName = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String musicName = ''; // 초기값 설정

        return AlertDialog(
          title: Text('음원 이름 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '새 음원 이름'),
                onChanged: (value) {
                  musicName = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop(null);
              },
            ),
            TextButton(
              child: Text('저장'),
              onPressed: () {
                Navigator.of(context).pop(musicName);
              },
            ),
          ],
        );
      },
    );

    if (newMusicName != null && newMusicName.isNotEmpty) {
      // 사용자가 새 음원 이름을 입력하고 저장한 경우에만 실행
      setState(() {
        DetailViewControler().editMusicTitle(musicId, newMusicName);
      });
    }
  }

  // 함수: 음원 삭제

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.playlistName),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showAddMusicPopup();
            },
          ),
        ],
      ),
      body: playlist.musicIds.isNotEmpty
          ? ListView.builder(
              itemCount: playlist.musicIds.length,
              itemBuilder: (context, index) {
                String musicId = playlist.musicIds[index];
                Music music =
                    Data.musicList.firstWhere((music) => music.id == musicId);

                return ListTile(
                  leading: Container(
                    width: 48, // 예시로 48픽셀로 크기 지정
                    height: 48,
                    child: Image.network(music.image),
                  ),
                  title: Text(music.tittle),
                  subtitle: Text(music.name),
                  trailing: PopupMenuButton(
                    onSelected: (value) {
                      setState(() {
                        if (value == 'remove') {
                          DetailViewControler().removeMusic(playlist, music.id);
                        } else if (value == 'edit') {
                          _showEditMusicNamePopup(music.id);
                        }
                      });
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'remove',
                          child: Text('플레이 리스트에서 삭제'),
                        ),
                        PopupMenuItem(
                          value: 'edit',
                          child: Text('음원 이름 수정하기'),
                        ),
                      ];
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('음원이 없습니다. 추가 버튼을 눌러 음원을 추가하세요.'),
            ),
    );
  }
}
