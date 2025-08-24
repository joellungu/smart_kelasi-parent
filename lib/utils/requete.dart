import 'package:get/get.dart';

class Requete extends GetConnect {
  //String url = "https://cricket-server-267e4fff2ea9.herokuapp.com/";
  //String url = "http://10.0.2.2:8080/";
  //static String urlSt = "http://10.0.2.2:8080/";
  // String url = "http:// 192.168.100.253:8080/"; //192.168.43.7
  // static String urlSt = "http:// 192.168.100.253:8080/";
  //192.168.100.129
  //10.176.160.134
  //192.168.11.109
  String url = "http://192.168.11.101:8080/"; //
  static String urlSt = "http://192.168.11.101:8080/";
  //
  Future<Response> getE(String path) async {
    return get("$url$path");
  }

  //
  Future<Response> postE(String path, var object) async {
    print("$url$path");
    return post("$url$path", object);
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
