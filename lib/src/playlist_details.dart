// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:provider/provider.dart';

import 'package:url_launcher/link.dart';
import 'adaptive_image.dart';
import 'adaptive_text.dart';
import 'app_state.dart';

class PlayListDetails extends StatelessWidget {
  const PlayListDetails({
    Key? key,
    required this.playListId,
    required this.playListName,
  }) : super(key: key);
  final String playListId;
  final String playListName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(playListName),
      ),
      body: Consumer<FlutterDevPlayList>(
        builder: (context, playLists, child) {
          final playListItems = playLists.playListItems(playListId: playListId);
          if (playListItems.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return _PlayListDetailsListView(playListItems: playListItems);
        },
      ),
    );
  }
}

class _PlayListDetailsListView extends StatefulWidget {
  const _PlayListDetailsListView({
    Key? key,
    required this.playListItems,
  }) : super(key: key);
  final List<PlaylistItem> playListItems;

  @override
  State<_PlayListDetailsListView> createState() =>
      _PlayListDetailsListViewState();
}

class _PlayListDetailsListViewState extends State<_PlayListDetailsListView> {
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
      itemCount: widget.playListItems.length,
      itemBuilder: (context, index) {
        final playListItem = widget.playListItems[index];

        return Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (playListItem.snippet!.thumbnails!.high != null)
                  AdaptiveImage.netWork(
                      playListItem.snippet!.thumbnails!.high!.url!),
                _buildGradient(context),
                _buildTitleAndSubtitle(context, playListItem),
                _buildPlayButton(context, playListItem),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradient(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Theme.of(context).colorScheme.background,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.5, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleAndSubtitle(
      BuildContext context, PlaylistItem playListItem) {
    return Positioned(
      left: 20,
      right: 0,
      bottom: 20,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AdaptiveText(
            playListItem.snippet!.title!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
          ),
          if (playListItem.snippet!.videoOwnerChannelTitle != null)
            AdaptiveText(
              playListItem.snippet!.videoOwnerChannelTitle!,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontSize: 12,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayButton(BuildContext context, PlaylistItem playListItem) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(21),
            ),
          ),
        ),
        Link(
          uri: Uri.parse(
              'https://www.youtube.com/watch?v=${playListItem.snippet!.resourceId!.videoId}'),
          builder: (context, followLink) => IconButton(
            onPressed: followLink,
            icon: const Icon(
              Icons.play_circle_fill,
            ),
            iconSize: 45,
            color: Colors.red,
          ),
        ),
      ],
    );
  }
}
