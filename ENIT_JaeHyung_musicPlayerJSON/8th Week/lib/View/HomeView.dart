import 'package:flutter/material.dart';
import 'package:music_player/Model/PlayList_MusicList_Model.dart';
import 'package:music_player/Control/HomeControl.dart';
import 'detail_playList.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  static String newPlaylistName = '';

  void onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void showCreatePlaylistDialog() async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('새 플레이리스트 생성'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '플레이리스트 이름'),
                onChanged: (value) {
                  newPlaylistName = value;
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
                Navigator.of(context).pop(newPlaylistName);
                setState(() {
                  HomeViewData().AddPlayListName(newPlaylistName);
                });
              },
            ),
          ],
        );
      },
    );
  }

  void showRenamePlaylistDialog(int index) async {
    String? result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('플레이리스트 이름 수정'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: '플레이리스트 이름'),
                onChanged: (value) {
                  newPlaylistName = value;
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
                print(newPlaylistName);
                Navigator.of(context).pop(newPlaylistName);
                setState(() {
                  HomeViewData().RenamePlayList(index, newPlaylistName);
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    if (currentIndex == 0) {
      // 플레이 리스트 페이지
      body = Card(
        elevation: 4,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: Data.playList.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text('새로운 플레이리스트 추가'),
                      leading: Icon(Icons.add),
                      onTap: () {
                        setState(() {
                          showCreatePlaylistDialog();
                        });
                      },
                    );
                  } else {
                    final playlist = Data.playList[index - 1];
                    final image = HomeViewData().findImagePath(playlist);
                    return Column(
                      children: <Widget>[
                        ListTile(
                          contentPadding: EdgeInsets.all(16.0),
                          title: Text(playlist.playlistName),
                          leading: Container(
                            width: 100,
                            height: 100,
                            child: image != 'defaultImagePath'
                                ? Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                  )
                                : Icon(Icons.image_not_supported, size: 64),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  playlist.heart
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: playlist.heart ? Colors.red : null,
                                ),
                                onPressed: () {
                                  setState(() {
                                    HomeViewData()
                                        .HeartButtonReaction(index - 1);
                                  });
                                },
                              ),
                              PopupMenuButton(
                                icon: Icon(Icons.more_vert),
                                itemBuilder: (BuildContext context) {
                                  return <PopupMenuEntry>[
                                    PopupMenuItem(
                                      child: Text('숨기기'),
                                      value: 'hide',
                                    ),
                                    PopupMenuItem(
                                      child: Text('제목 수정하기'),
                                      value: 'edit',
                                    ),
                                    PopupMenuItem(
                                      child: Text('삭제하기'),
                                      value: 'delete',
                                    ),
                                  ];
                                },
                                onSelected: (value) {
                                  if (value == 'edit') {
                                    setState(() {
                                      showRenamePlaylistDialog(index - 1);
                                    });
                                  } else if (value == 'delete') {
                                    setState(() {
                                      HomeViewData().DeletePlayList(index);
                                    });
                                  } else if (value == 'hide') {
                                    setState(() {
                                      print(index);
                                      HomeViewData().HidePlayList(index - 1);
                                    });
                                    // 숨기기
                                  }
                                },
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPlaylistWidget(
                                  playlistName:
                                      Data.playList[index - 1].playlistName,
                                ),
                              ),
                            );
                          },
                        ),
                        Divider(),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      );
    } else {
      // 관심 목록 페이지
      body = Card(
        elevation: 4,
        child: Expanded(
          child: ListView.builder(
            itemCount: Data.playList.length,
            itemBuilder: (context, index) {
              final playlist = Data.playList[index];
              final image = HomeViewData().findImagePath(playlist);
              if (playlist.heart) {
                return Column(
                  children: <Widget>[
                    ListTile(
                      contentPadding: EdgeInsets.all(16.0),
                      title: Text(playlist.playlistName),
                      leading: Container(
                        width: 100,
                        height: 100,
                        child: image != 'defaultImagePath'
                            ? Image.network(
                                image,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.image_not_supported, size: 64),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              playlist.heart
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: playlist.heart ? Colors.red : null,
                            ),
                            onPressed: () {
                              setState(() {
                                HomeViewData().HeartButtonReaction(index);
                              });
                            },
                          ),
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert),
                            itemBuilder: (BuildContext context) {
                              return <PopupMenuEntry>[
                                PopupMenuItem(
                                  child: Text('숨기기'),
                                  value: 'hide',
                                ),
                                PopupMenuItem(
                                  child: Text('제목 수정하기'),
                                  value: 'edit',
                                ),
                                PopupMenuItem(
                                  child: Text('삭제하기'),
                                  value: 'delete',
                                ),
                              ];
                            },
                            onSelected: (value) {
                              if (value == 'edit') {
                                // 수정 기능을 여기에 구현
                              } else if (value == 'delete') {
                                // 삭제 기능을 여기에 구현
                              } else if (value == 'hide') {
                                // 숨기기
                              }
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPlaylistWidget(
                              playlistName: Data.playList[index].playlistName,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(),
                  ],
                );
              } else {
                return SizedBox.shrink(); // 비활성화된 항목 숨기기
              }
            },
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onDoubleTap: () {
            setState(() {
              // Call the method you want to execute on double-tap
              HomeViewData().ShowHidingPlayList();
            });
          },
          child: Text(currentIndex == 0 ? '플레이 리스트' : '관심 목록'),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              setState(() {
                showCreatePlaylistDialog();
              });
            },
          ),
        ],
      ),
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: '플레이 리스트',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: '관심 목록',
          ),
        ],
        onTap: onTabTapped,
      ),
    );
  }
}
