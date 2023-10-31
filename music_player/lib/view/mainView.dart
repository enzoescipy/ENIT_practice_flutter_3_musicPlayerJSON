import 'package:flutter/material.dart';
import 'static/myOrdinaryStyle.dart';

import 'page/main/playlist_page.dart';
import 'page/main/playlist_page_liked.dart';
import 'page/detail/playlist_detail.dart';
import 'page/detail/music_detail.dart';
import 'page/new_playlist/new_playlist_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: WinterGreenColor.winterGreenTheme,
        textTheme: CuteText.cuteTextTheme,
        useMaterial3: true,
      ),
      home: const NavigateHomePage(),
      routes: {
        PlayListDetail.routeName: (context) => const PlayListDetail(),
        MusicDetail.routeName: (context) => const MusicDetail(),
        NewPlayListPage.routeName: (context) => const NewPlayListPage(),
      },
    );
  }
}

class NavigateHomePage extends StatefulWidget {
  const NavigateHomePage({Key? key}) : super(key: key);

  @override
  State<NavigateHomePage> createState() => _NavigateHomePageState();
}

class _NavigateHomePageState extends State<NavigateHomePage> {
  final List<Widget> _widgetOption = const [PlayListPage(), PlayListLikedPage()];
  int _selectedIndex = 0;

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
      // VOStageCommitGet.commit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOption.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play_rounded), label: '플레이 리스트'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: '좋아요'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onTap,
      ),
    );
  }
}
