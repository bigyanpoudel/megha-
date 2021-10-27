import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:megha/shared/services/storage.dart';

class NetworkService {
  final String baseUrl = "https://poshyak.com/api/";
  // final String baseUrl = "https://poshyak.com/api/";
  // final String baseUrl = 'http://10.0.2.2:3000/api/';

  getHeaders() async {
    var headers = {'Content-Type': 'application/json'};

    String? token = await StorageService.getToken();
    if (token != null) {
      headers['token'] = token;
    }

    return headers;
  }

  static getToken() async {
    String? token = await StorageService.getToken();
    if (token == null) return;
    print("token $token");
    return token;
  }

  Future<dynamic> post(url, body) async {
    var headers = await getHeaders();

    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response = await HTTP.post(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(body),
      );

      int status = response.statusCode;

      if (status == 400) {
        throw (response.body);
      } else if (status == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }

  Future<dynamic> ForgetPassword(url, body) async {
    var headers = await getHeaders();

    try {
      http.Response response = await http.post(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(body),
      );

      int status = response.statusCode;

      if (status == 400) {
        throw (response.body);
      } else if (status == 200) {
        return response.body;
      }
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }

  // Future<dynamic> put(url, body) async {
  //   var headers = await getHeaders();

  //   try {
  //     http.Response response = await http.put(
  //       baseUrl + url,
  //       headers: headers,
  //       body: body,
  //     );

  //     int status = response.statusCode;

  //     if (status == 400) {
  //       throw (response.body);
  //     } else if (status == 200) {
  //       return 'success';
  //     }
  //   } catch (e) {
  //     print('Something went wrong, retry later ');
  //     rethrow;
  //   }
  // }
  //

  Future<dynamic> put(url, files) async {
    var token = await getToken();
    print('thello');
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse(baseUrl + url),
      );
      request.headers['token'] = token;
      request.headers['Content-Type'] = 'application/json';
      for (var file in files) {
        log('${file['name']} ${file['filePath']} in put request');
        request.files.add(
            await http.MultipartFile.fromPath(file['name'], file['filePath']));
      }
      final res = await request.send();
      return res.reasonPhrase;
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }
  // Future<dynamic> put(url, filename) async {
  //   var token = await getToken();

  //   try {
  //     var request = http.MultipartRequest(
  //       'PUT',
  //       Uri.parse(baseUrl + url),
  //     );
  //     request.headers['token'] = token;
  //     request.headers['Content-Type'] = 'application/json';

  //     request.files.add(await http.MultipartFile.fromPath('file', filename));
  //     final res = await request.send();

  //     return res.reasonPhrase;
  //   } catch (e) {
  //     print('Something went wrong, retry later');
  //     rethrow;
  //   }
  // }

  Future<dynamic> edit(url, body) async {
    var headers = await getHeaders();
    log("body $body");
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response = await HTTP.put(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(body),
      );
      int status = response.statusCode;
      if (status == 400) {
        throw (response.body);
      } else if (status == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }

  Future<dynamic> deleteWithBody(url, body) async {
    var headers = await getHeaders();
    log("body $body");
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response = await HTTP.delete(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(body),
      );
      int status = response.statusCode;
      if (status == 400) {
        throw (response.body);
      } else if (status == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }

  Future<dynamic> patch(url, body) async {
    var headers = await getHeaders();

    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response = await HTTP.patch(
        Uri.parse(baseUrl + url),
        headers: headers,
        body: jsonEncode(body),
      );

      int status = response.statusCode;
      if (status == 400) {
        throw (response.body);
      } else if (status == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      print('Something went wrong, retry later');
      rethrow;
    }
  }

  Future get(String url) async {
    var headers = await getHeaders();
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response =
          await HTTP.get(Uri.parse(baseUrl + url), headers: headers);

      // String responseBody = response.body;
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        var data = jsonDecode(response.body);

        throw new NetworkException(
          code: response.statusCode,
          message: data['message'],
          details: data['details'],
        );
      }
    } catch (e) {
      rethrow;
//      _showErrorSnack('Something went wrong, retry later');
    }
  }

  Future delete(String url) async {
    var headers = await getHeaders();
    print("headers $headers");
    try {
      final ioc = new HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final HTTP = new IOClient(ioc);
      http.Response response =
          await HTTP.delete(Uri.parse(baseUrl + url), headers: headers);

      // String responseBody = response.body;
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        return data;
      } else {
        var data = jsonDecode(response.body);

        throw new NetworkException(
          code: response.statusCode,
          message: data['message'],
          details: data['details'],
        );
      }
    } catch (e) {
      rethrow;
//      _showErrorSnack('Something went wrong, retry later');
    }
  }
}

class NetworkException implements Exception {
  int? code;
  String? message;
  String? details;

  NetworkException({this.code, this.message, this.details});
}
