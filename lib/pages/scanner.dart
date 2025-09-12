import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:smart_keslassi_parent/main.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _QRViewExampleState();
  }
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  //
  var box = GetStorage();
  //
  String? qrText;
  String? serverResponse;
  bool isLoading = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child:
                Container(), //QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
          ),
          Expanded(flex: 1, child: Center(child: Text('Scan a code'))),
        ],
      ),
    );
  }

  //
}
