import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Frais extends StatelessWidget {
  //
  Requete requete = Requete();
  //
  var box = GetStorage();
  //
  Map eleve;
  //
  String anneescolaire;
  //
  Frais(this.eleve, this.anneescolaire);
  //
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: getInfosPerso(eleve['cle'], anneescolaire),
        builder: (c, t) {
          if (t.hasData) {
            //
            List diplomes = t.data as List;
            //
            return ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: diplomes.length,
              itemBuilder: (context, index) {
                return buildDiplomeCard(diplomes[index], context);
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

  Widget buildDiplomeCard(Map<String, dynamic> diplome, BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: InkWell(
          onTap: () {
            //
            if (diplome["pieceJointe"] != null &&
                (diplome["pieceJointe"] as String).isNotEmpty) {
              try {
                Uint8List bytes = base64Decode(diplome["pieceJointe"]);
                showDialog(
                  context: context,
                  builder:
                      (ctx) => Dialog(
                        child: Container(
                          width: 500,
                          padding: const EdgeInsets.all(20),
                          child: Image.memory(
                            bytes,
                            fit: BoxFit.contain,
                            width: 200,
                            height: 200,
                            errorBuilder: (context, error, stackTrace) {
                              return const Text(
                                "Impossible d’afficher l’image",
                              );
                            },
                          ),
                        ),
                      ),
                );
              } catch (e) {
                showDialog(
                  context: context,
                  builder:
                      (ctx) => Dialog(
                        child: Container(
                          width: 500,
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            "Erreur lors du décodage de la pièce jointe",
                          ),
                        ),
                      ),
                );
              }
            } else {
              showDialog(
                context: context,
                builder:
                    (ctx) => Dialog(
                      child: Container(
                        width: 500,
                        padding: const EdgeInsets.all(20),
                        child: SizedBox.shrink(),
                      ),
                    ),
              ); // Ne rien afficher
            }
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                diplome.entries.map((entry) {
                  if (entry.key == "id" ||
                      entry.key == "cle" ||
                      entry.key == "synced" ||
                      entry.key == "pieceJointe" ||
                      entry.key == "idEnseignant" ||
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
      ),
    );
  }

  //
  Future<List> getInfosPerso(String cle, String anneescolaire) async {
    //
    List cours = [];
    //
    Response response = await requete.getE(
      "saisieservice/eleve/$cle/$anneescolaire",
    );
    //
    if (response.isOk) {
      //
      print('Succès: ${response.statusCode}');
      print('Succès: ${response.body}');
      //
      //box.write("cours", response.body);
      //
      cours.addAll(response.body);
    } else {
      print('Erreur: ${response.statusCode}');
      print('Erreur: ${response.body}');
    }

    //
    List cs = box.read("diplomes") ?? [];
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('diplomes', cs);
    return cs;
  }
}
