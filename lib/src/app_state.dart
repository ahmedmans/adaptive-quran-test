import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:googleapis/youtube/v3.dart';
import 'package:http/http.dart' as http;

class FlutterDevPlayList extends ChangeNotifier {
  FlutterDevPlayList({
    required String flutterDevAccountId,
    required String youTubeApiKey,
  }) : _flutterDevAccountId = flutterDevAccountId {
    _api = YouTubeApi(
      _ApiKeyClient(
        key: youTubeApiKey,
        client: http.Client(),
      ),
    );
    _loadPlayLists();
  }

  final String _flutterDevAccountId;
  late final YouTubeApi _api;

  final List<Playlist> _playLists = [];

  List<Playlist> get playLists => UnmodifiableListView(_playLists);
  final Map<String, List<PlaylistItem>> _playListItems = {};

  List<PlaylistItem> playListItems({required String playListId}) {
    if (!_playListItems.containsKey(playListId)) {
      _playListItems[playListId] = [];
      _retrivePlayList(playListId);
    }
    return UnmodifiableListView(_playListItems[playListId]!);
  }

  Future<void> _retrivePlayList(String playListId) async {
    String? nextPageToken;
    do {
      var response = await _api.playlistItems.list(
        ['snippet', 'contentDetails'],
        playlistId: playListId,
        maxResults: 25,
        pageToken: nextPageToken,
      );
      var items = response.items;
      if (items != null) {
        _playListItems[playListId]!.addAll(items);
      }
      notifyListeners();
      nextPageToken = response.nextPageToken;
    } while (nextPageToken != null);
  }

  Future<void> _loadPlayLists() async {
    String? nextPageToken;
    _playLists.clear();

    do {
      final respons = await _api.playlists.list(
        ['snippet', 'contentDetails', 'id'],
        channelId: _flutterDevAccountId,
        maxResults: 50,
        pageToken: nextPageToken,
      );
      _playLists.addAll(respons.items!);
      _playLists.sort(
        (a, b) => a.snippet!.title!.toLowerCase().compareTo(
              b.snippet!.title!.toLowerCase(),
            ),
      );
      notifyListeners();
    } while (nextPageToken != null);
  }
}

class _ApiKeyClient extends http.BaseClient {
  final String key;
  final http.Client client;

  _ApiKeyClient({required this.key, required this.client});

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final url = request.url.replace(queryParameters: <String, List<String>>{
      ...request.url.queryParametersAll,
      'key': [key]
    });
    return client.send(http.Request(request.method, url));
  }
}
