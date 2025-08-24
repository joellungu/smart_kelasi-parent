import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Periode extends StatelessWidget {
  //
  Map eleve;
  Map cour;
  //
  String anneescolaire;
  //
  Requete requete = Requete();
  //
  Periode(this.eleve, this.cour, this.anneescolaire);
  //
  var box = GetStorage();
  //
  @override
  Widget build(BuildContext context) {
    //
    final libelle =
        '${cour['niveau']} ${cour['cycle']}'
        '${cour['section'] != null ? ' ${cour['section']}' : ''}';
    //
    Map user = box.read("user") ?? {};
    //List Liste = List<String>.from(jsonDecode(user['cours']));
    //print('Liste: $Liste');
    //niveau, cycle, section, lettre, annee_scolaire
    return Scaffold(
      appBar: AppBar(title: Text("Période(s)"), centerTitle: true),
      body: FutureBuilder(
        future: getAllCours(
          cour['niveau'],
          cour['cycle'],
          cour['section'],
          cour['lettre'],
          anneescolaire,
        ),
        builder: (c, t) {
          if (t.hasData) {
            //
            List periodes = t.data as List;
            print("periodes: $periodes");
            //
            return ListView.builder(
              itemCount: periodes.length,
              padding: EdgeInsets.all(20),
              itemBuilder: (context, index) {
                Map periode = periodes[index];
                //
                final libelle =
                    '${periode['niveau']} ${periode['cycle']}'
                    '${periode['section'] != null ? ' ${periode['section']}' : ''}';
                //
                return ListTile(
                  onTap: () {
                    //Get.back();
                    Get.to(
                      Eleves(
                        enseignant,
                        "$libelle ${periode['lettre']}",
                        cour,
                        periode,
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    // backgroundImage: NetworkImage(
                    //   'https://randomuser.me/api/portraits/women/2${index + 1}.jpg',
                    // ),
                    child: Text(
                      periode['niveau'],
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  title: Text(
                    '${periode['niveau']} ${periode['cycle']}'
                    '${periode['section'] != null ? ' ${periode['section']}' : ''} ${periode['nom']}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  subtitle: Text(
                    periode['statut'] == "0" ? "Ouvert" : "Fermé",
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  trailing: Icon(Icons.arrow_forward_ios),
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
  Future<List> getAllCours(
    String niveau,
    cycle,
    section,
    lettre,
    anneescolaire,
  ) async {
    //niveau, cycle, section, lettre, annee_scolaire
    List cours = [];
    //print('Classe: $cle');
    //
    Response response = await requete.getE(
      "periodeservice/$niveau/$cycle/$section/$lettre/$anneescolaire",
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
    final libelle =
        '${cour['niveau']} ${cour['cycle']}'
        '${cour['section'] != null ? ' ${cour['section']}' : ''}';
    //
    List cs = box.read("periode$libelle") ?? [];
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    print("periodes: $cs");
    //
    //cs.addAll(cours);
    //
    box.write('periode$libelle', cs);
    return cs;
  }
}
