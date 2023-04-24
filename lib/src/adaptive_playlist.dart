import 'package:adaptive_app/src/playlist_details.dart';
import 'package:adaptive_app/src/playlists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:split_view/split_view.dart';

class AdaptivePlayList extends StatelessWidget {
  const AdaptivePlayList({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final targetPlatform = Theme.of(context).platform;

    if (targetPlatform == TargetPlatform.android ||
        targetPlatform == TargetPlatform.iOS ||
        screenWidth <= 500) {
      return const NarrowDisplayPlayLists();
    } else {
      return const WideDisplayPlaylists();
    }
  }
}

class NarrowDisplayPlayLists extends StatelessWidget {
  const NarrowDisplayPlayLists({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Quran Karim"),
      ),
      body: PlayLists(
        playlistSelected: (playLists) {
          context.go(
            Uri(
              path: '/playlist/${playLists.id}',
              queryParameters: <String, String>{
                'title': playLists.snippet!.title!,
              },
            ).toString(),
          );
        },
      ),
    );
  }
}

class WideDisplayPlaylists extends StatefulWidget {
  const WideDisplayPlaylists({super.key});

  @override
  State<WideDisplayPlaylists> createState() => _WideDisplayPlaylistsState();
}

class _WideDisplayPlaylistsState extends State<WideDisplayPlaylists> {
  Playlist? selectedPlayList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: selectedPlayList == null
            ? const Text('Quran Karim')
            : Text(
                'Quran Karim Playlist: ${selectedPlayList!.snippet!.title!}',
              ),
      ),
      body: SplitView(
        viewMode: SplitViewMode.Horizontal,
        children: [
          PlayLists(
            playlistSelected: (playList) {
              setState(() {
                selectedPlayList = playList;
              });
            },
          ),
          if (selectedPlayList != null)
            PlayListDetails(
              playListId: selectedPlayList!.id!,
              playListName: selectedPlayList!.snippet!.title!,
            )
          else
            const Center(
              child: Text('Select a playlist'),
            ),
        ],
      ),
    );
  }
}
