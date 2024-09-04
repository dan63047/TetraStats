import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserAgentClient extends http.BaseClient {
  final String userAgent;
  final http.Client _inner;

  UserAgentClient(this.userAgent, this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['user-agent'] = userAgent;
    if (!kIsWeb) request.headers['X-Session-ID'] = "${Random().nextInt(1<<32)}";
    return _inner.send(request);
  }
}