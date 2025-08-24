import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Parent extends StatelessWidget {
  //
  Requete requete = Requete();
  //
  var box = GetStorage();
  //
  Map eleve;
  //
  Parent(this.eleve);
  //
  @override
  Widget build(BuildContext context) {
    //
    //Map user = box.read("user") ?? {};
    //List Liste = List<String>.from(jsonDecode(user['cours']));
    //print('Liste: $Liste');
    //
    return Scaffold(
      appBar: AppBar(title: Text("Cours"), centerTitle: true),
      body: FutureBuilder(
        future: getInfosPerso(eleve['numeroIdentifiant']),
        builder: (c, t) {
          if (t.hasData) {
            //
            Map<String, dynamic> diplomes = t.data as Map<String, dynamic>;
            //
            return buildDiplomeCard(diplomes);
            //
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: diplomes.length,
              itemBuilder: (context, index) {
                return buildDiplomeCard(diplomes[index]);
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

  Widget buildDiplomeCard(Map<String, dynamic> diplome) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              diplome.entries.map((entry) {
                if (entry.key == "id" ||
                    entry.key == "cle" ||
                    entry.key == "synced" ||
                    entry.key == "updatedAt") {
                  return Container();
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            entry.key,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal[700],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            entry.value?.toString() ?? "—",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  );
                }
              }).toList(),
        ),
      ),
    );
  }

  //
  Future<Map> getInfosPerso(String cle) async {
    //
    Map cours = {};
    //
    Response response = await requete.getE("responsable/details/$cle");
    //
    if (response.isOk) {
      //
      print('Succès: ${response.statusCode}');
      print('Succès: ${response.body}');
      //
      //box.write("cours", response.body);
      //
      cours = response.body;
    } else {
      print('Erreur: ${response.statusCode}');
      print('Erreur: ${response.body}');
    }

    //
    Map cs = box.read("parent$cle") ?? {};
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('parent$cle', cs);
    return cs;
  }
}
