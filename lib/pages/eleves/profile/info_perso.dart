import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class InfoPerso extends StatelessWidget {
  //
  Requete requete = Requete();
  //
  Map eleve;
  //
  var box = GetStorage();
  //
  InfoPerso(this.eleve);
  //
  @override
  Widget build(BuildContext context) {
    //
    //Map user = box.read("eleve${eleve['cle']}") ?? {};
    //
    //
    return Scaffold(
      appBar: AppBar(title: Text("Information de l'élève"), centerTitle: true),
      body: FutureBuilder(
        future: getInfosPerso(eleve['cle']),
        builder: (c, t) {
          if (t.hasData) {
            //
            Map enseignant = t.data as Map;
            //
            return ListView.separated(
              padding: EdgeInsets.all(16),
              itemCount: enseignant.length,
              separatorBuilder: (context, index) => Divider(),
              itemBuilder: (context, index) {
                String key = enseignant.keys.elementAt(index);
                var value = enseignant[key];
                if (key == "id" ||
                    key == "cle" ||
                    key == "synced" ||
                    key == "updatedAt") {
                  return Container();
                } else {
                  return ListTile(
                    title: Text(
                      key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.teal[700],
                      ),
                    ),
                    subtitle: Text(
                      value.toString(),
                      style: TextStyle(fontSize: 15),
                    ),
                  );
                }
              },
            );
          } else if (t.hasError) {
            return Center(child: Text("Erreur: ${t.error}"));
          }
          return Center(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  //
  Future<Map> getInfosPerso(String cle) async {
    //
    Map cours = {};
    //
    Response response = await requete.getE("eleve/details/$cle");
    //
    if (response.isOk) {
      //
      print('Succès: ${response.statusCode}');
      print('Succès: ${response.body}');
      //
      //box.write("cours", response.body);
      //
      cours = response.body ?? {};
    } else {
      print('Erreur: ${response.statusCode}');
      print('Erreur: ${response.body}');
    }

    //
    Map cs = box.read("eleve$cle") ?? {};
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('eleve$cle', cs);
    return cs;
  }
}
