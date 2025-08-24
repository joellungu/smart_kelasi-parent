import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/pages/eleves/details_eleve.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Anneescolaire extends StatelessWidget {
  //
  Requete requete = Requete();
  //
  var box = GetStorage();
  //
  Map eleve = {};
  //
  Anneescolaire(this.eleve);
  //
  @override
  Widget build(BuildContext context) {
    //
    //Map user = box.read("user") ?? {};
    //List Liste = List<String>.from(jsonDecode(eleve['cle']));
    //print('Liste: $Liste');
    //
    return Scaffold(
      appBar: AppBar(title: Text("Annee scolaire"), centerTitle: true),
      body: FutureBuilder(
        future: getAllCours(),
        builder: (c, t) {
          if (t.hasData) {
            //
            List cours = t.data as List;
            //
            return ListView.builder(
              itemCount: cours.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                Map cour = cours[index];
                //
                final libelle =
                    '${cour['niveau']} ${cour['cycle']}'
                    '${cour['section'] != null ? ' ${cour['section']}' : ''}';
                //
                return InkWell(
                  onTap: () {
                    Get.to(DetailEleves(eleve, cour['anneescolaire']));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.white, //Colors.blue[50]
                      border: Border(
                        //bottom: BorderSide(color: Colors.grey[200]!, width: 1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[700],
                          child: Text(
                            "${index + 1}".toUpperCase(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      "${cour['anneescolaire']}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  //
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                      color:
                                          cour['status'] == 1
                                              ? Colors.green.shade900
                                              : Colors.grey,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),

                              Text(
                                cour['status'] == 1 ? "En cours" : "Complet",
                                style: TextStyle(
                                  color: Colors.blue[700],
                                  fontSize: 13,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
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
  Future<List> getAllCours() async {
    //
    List cours = [];
    //
    Response response = await requete.getE("anneescolaireservice");
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
    List cs = box.read("anneescolaire") ?? [];
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    //cs.addAll(cours);
    //
    box.write('anneescolaire', cs);
    return cs;
  }
}
