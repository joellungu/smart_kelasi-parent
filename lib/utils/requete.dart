import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class Requete extends GetConnect {
  String urlEPST = "https://educ-app-serveur-43d00822f87c.herokuapp.com/";
  //String url = "http://10.0.2.2:8080/";
  //static String urlSt = "http://10.0.2.2:8080/";
  // String url = "http:// 192.168.100.253:8080/"; //192.168.43.7
  // static String urlSt = "http:// 192.168.100.253:8080/";
  //192.168.100.129
  //10.176.160.134
  //192.168.11.109
  //10.29.114.23
  //192.168.11.111
  String url = "http://192.168.11.100:9090/"; //
  static String urlSt = "http://192.168.11.100:9090/";
  //
  Future<http.Response> postETicket(String path, Map e) async {
    return http
        .post(
          Uri.parse("$urlEPST$path"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(e),
        )
        .timeout(const Duration(minutes: 2));
  }

  //
  Future<Response> getE(String path) async {
    return get("$url$path");
  }

  //
  Future<Response> getEe(String path) async {
    return get("$urlEPST$path");
  }

  //
  Future<Response> postE(String path, var object) async {
    print("$url$path");
    return post("$url$path", object);
  }

  //
  Future<Response> postEe(String path, var object) async {
    print("$urlEPST$path");
    return post("$urlEPST$path", object);
  }

  //
  Future<Response> putE(String path, var object) async {
    return put("$url$path", object);
  }

  //
  Future<Response> deleteE(String path) async {
    return delete("$url$path");
  }

  //
}
