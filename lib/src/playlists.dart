// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:go_router/go_router.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';

import 'package:adaptive_app/src/app_state.dart';

import 'adaptive_image.dart';

class PlayLists extends StatelessWidget {
  const PlayLists({
    Key? key,
    required this.playlistSelected,
  }) : super(key: key);
  final PlaylistsListSelected playlistSelected;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quran Karim'),
      ),
      body: Consumer<FlutterDevPlayList>(
        builder: (context, flutterDev, child) {
          final playLists = flutterDev.playLists;
          if (playLists.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _PlayListsListView(
            items: playLists,
            playlistsListSelected: playlistSelected,
          );
        },
      ),
    );
  }
}

typedef PlaylistsListSelected = void Function(Playlist playLists);

class _PlayListsListView extends StatefulWidget {
  final List<Playlist> items;
  final PlaylistsListSelected playlistsListSelected;
  const _PlayListsListView({
    Key? key,
    required this.items,
    required this.playlistsListSelected,
  }) : super(key: key);

  @override
  State<_PlayListsListView> createState() => _PlayListsListViewState();
}

class _PlayListsListViewState extends State<_PlayListsListView> {
  late ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: widget.items.length,
      itemBuilder: (context, index) {
        var playList = widget.items[index];
        return Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: AdaptiveImage.netWork(
              playList.snippet!.thumbnails!.default_!.url!,
            ),
            title: Text(
              playList.snippet!.title!,
            ),
            subtitle: Text(playList.snippet!.description!),
            onTap: () {
              widget.playlistsListSelected(playList);
            },
          ),
        );
      },
    );
  }
}
