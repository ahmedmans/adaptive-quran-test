import 'package:adaptive_app/src/adaptive_playlist.dart';
import 'package:adaptive_app/src/app_state.dart';
import 'package:adaptive_app/src/playlist_details.dart';
import 'package:adaptive_app/src/playlists.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'dart:io' show Platform, exit;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

const flutterDevAccountId = 'UCgTbQmrJvMTE8Ro3VHPlBEQ';
const youTubeApiKey = 'AIzaSyDjcIZQlEeGa3lp2cX-DfSQ6h4FCl3WksQ';

final _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const AdaptivePlayList();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'playlist/:id',
          builder: (context, state) {
            final title = state.queryParams['title']!;
            final id = state.params['id']!;
            return PlayListDetails(
              playListId: id,
              playListName: title,
            );
          },
        )
      ],
    ),
  ],
);

void main() {
  if (youTubeApiKey == 'AIzaNotAnApiKey') {
    print('youTubeApiKey has not been configured.');
    exit(1);
  }

  runApp(
    ChangeNotifierProvider(
      create: (context) => FlutterDevPlayList(
        flutterDevAccountId: flutterDevAccountId,
        youTubeApiKey: youTubeApiKey,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Adaptive App',
      debugShowCheckedModeBanner: false,
      theme: FlexColorScheme.light(scheme: FlexScheme.red).toTheme,
      darkTheme: FlexColorScheme.dark(scheme: FlexScheme.red).toTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _router,
    );
  }
}

class ResizeablePage extends StatelessWidget {
  const ResizeablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final themePlatform = Theme.of(context).platform;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Window properties',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 350,
              child: Table(
                textBaseline: TextBaseline.alphabetic,
                children: [
                  _fillTableRow(
                    context: context,
                    property: 'Window Size',
                    value: '${mediaQuery.size.width.toStringAsFixed(1)} x '
                        '${mediaQuery.size.height.toStringAsFixed(1)}',
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Device Pixel Ratio',
                    value: mediaQuery.devicePixelRatio.toStringAsFixed(2),
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Platform.isXXX',
                    value: platformDescription(),
                  ),
                  _fillTableRow(
                    context: context,
                    property: 'Theme.of(ctx).platform',
                    value: themePlatform.toString(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _fillTableRow(
      {required BuildContext context,
      required String property,
      required String value}) {
    return TableRow(
      children: [
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.baseline,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(property),
          ),
        ),
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.baseline,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(value),
          ),
        ),
      ],
    );
  }

  String platformDescription() {
    if (kIsWeb) {
      return 'Web';
    } else if (Platform.isAndroid) {
      return 'Android';
    } else if (Platform.isIOS) {
      return 'IOS';
    } else if (Platform.isWindows) {
      return 'Windows';
    } else if (Platform.isMacOS) {
      return 'Mac OS';
    } else if (Platform.isLinux) {
      return 'Linux';
    } else if (Platform.isFuchsia) {
      return 'Fuchsia';
    } else {
      return 'UnKnown';
    }
  }
}
