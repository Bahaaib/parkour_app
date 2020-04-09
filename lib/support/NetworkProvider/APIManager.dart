import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' show Response;
import 'package:http_middleware/http_middleware.dart';
import 'package:http_logger/http_logger.dart';

class APIManager {
  HttpClientWithMiddleware _client;
  String _encodedBody;

  Map<String, String> map = {
    HttpHeaders.contentTypeHeader: "application/json",
    HttpHeaders.acceptHeader: "application/json"
  };

  void _setMiddleWares() {
    if (_client == null) {
      _client = HttpClientWithMiddleware.build(middlewares: [
        HttpLogger(logLevel: LogLevel.BODY),
      ]);
    }
  }

  void setHeaders(
      {bool hasExpectHeader = false,
      bool isTokenRequired = false,
      String token}) {
    if (hasExpectHeader) {
      map.putIfAbsent(HttpHeaders.expectHeader, () => '100-Continue');
    }

    if (isTokenRequired) {
      map.putIfAbsent(HttpHeaders.authorizationHeader, () => 'auth $token');
      print('');
    }
  }

  void setEncodedBodyFromMap({@required Map<String, dynamic> map}) {
    _encodedBody = jsonEncode(map);
  }

  Future<Response> post(String apiPath) async {
    try {
      _setMiddleWares();
      Uri uri = Uri.parse(apiPath);
      if (uri.scheme == "https") {
        uri = Uri.https(uri.authority, uri.path);
      } else {
        uri = Uri.http(uri.authority, uri.path);
      }
      final response =
          await _client.post(uri, body: _encodedBody, headers: map);
      return response;
    } catch (e) {
      print("post req Failed $e");
      return null;
    }
  }

  Future<Response> get(String apiPath) async {
    try {
      _setMiddleWares();
      Uri uri = Uri.parse(apiPath);
      if (uri.scheme == "https") {
        uri = Uri.https(uri.authority, uri.path);
      } else {
        uri = Uri.http(uri.authority, uri.path);
      }
      final response =
          await _client.post(uri, body: _encodedBody, headers: map);
      return response;
    } catch (e) {
      print("post req Failed $e");
      return null;
    }
  }
}
