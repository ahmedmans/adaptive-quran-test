import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdaptiveImage extends StatelessWidget {
  late final String _url;
  AdaptiveImage.netWork(String url, {super.key}) {
    if (kIsWeb) {
      _url = Uri.parse(url)
          .replace(host: 'localhost', port: 8080, scheme: 'http')
          .toString();
    } else {
      _url = url;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(_url);
  }
}
