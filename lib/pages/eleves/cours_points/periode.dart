import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/pages/eleves/cours_points/cours_points.dart';
import 'package:smart_keslassi_parent/utils/periode.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Periode extends StatelessWidget {
  //
  Map eleve;
  //
  String anneescolaire;
  //
  Requete requete = Requete();
  //
  Periode(this.eleve, this.anneescolaire);
  //
  var box = GetStorage();
  //
  @override
  Widget build(BuildContext context) {
    //
    Map user = box.read("user") ?? {};
    //List Liste = List<String>.from(jsonDecode(user['cours']));
    //print('Liste: $Liste');
    //niveau, cycle, section, lettre, annee_scolaire
    return Scaffold(
      appBar: AppBar(title: Text("Période(s)"), centerTitle: true),
      body: FutureBuilder(
        future: getAllCours(eleve['classe'], anneescolaire),
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
                  onTap: () async {
                    //
                    //
                    List<CourseResult> courseResults = [];
                    //
                    //iCl.value = index;
                    //
                    //nomPeriode = periode['nom'];
                    //
                    //print('truc; ${crs}');

                    Map data = await getCoursParCat2(
                      periode['niveau'],
                      periode['cycle'],
                      periode['section'],
                      periode['lettre'],
                      eleve['cle'],
                      periode['cle'],
                      anneescolaire,
                    );
                    //
                    print(
                      'Note(s); $data / ${periode['id']} / ${eleve['id']} // ${periode['niveau']} : ${periode['cycle']} : ${periode['section']} : ${periode['lettre']} : ',
                    );
                    //
                    // List notes = json.decode(
                    //   "${periode['notes'] ?? []}",
                    // );
                    //
                    double total = 0;
                    double points = 0;
                    //
                    List notes = data['notes'] ?? [];
                    //
                    for (Map c in notes) {
                      //
                      total = total + double.parse("${c['total']}");
                      points = points + double.parse("${c['point']}");
                      //
                      courseResults.add(
                        CourseResult(
                          c['cours'],
                          double.parse("${c['point']}"),
                          double.parse("${c['total']}"),
                        ),
                      );
                    }
                    //
                    print('Points: $points / Total: $total /  ');
                    //
                    Period period = Period(
                      periode['nom'],
                      points,
                      total,
                      DateTime(2023, 10, 16),
                      DateTime(2023, 12, 1),
                      courseResults,
                    );
                    //Get.back();
                    String pl = data['place'];
                    //
                    int place = pl.contains("-") ? 0 : int.parse(data['place']);
                    //
                    Get.to(CoursPoints(period, place));
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
  Future<List> getAllCours(String classe, anneescolaire) async {
    //niveau, cycle, section, lettre, annee_scolaire
    List cours = [];
    //print('Classe: $cle');
    //
    Response response = await requete.getE(
      "periodeservice/$classe/$anneescolaire",
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
    //
    List cs = box.read("periode$classe") ?? [];
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    print("periodes: $cs");
    //
    //cs.addAll(cours);
    //
    box.write('periode$classe', cs);
    return cs;
  }

  Future<Map> getCoursParCat2(
    String niveau,
    cycle,
    section,
    lettre,
    idEleve,
    idPeriode,
    anneescolaire,
  ) async {
    //niveau, cycle, section, lettre, annee_scolaire
    Map cours = {};
    //print('Classe: $cle');
    //
    Response response = await requete.getE(
      "notecoursobtenue/place?niveau=$niveau&cycle=$cycle&section=$section&lettre=$lettre&idEleve=$idEleve&idPeriode=$idPeriode&anneescolaire=$anneescolaire",
    );
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
    //
    Map cs = box.read("notecoursobtenue$idPeriode$idEleve") ?? {};
    if (cours.isNotEmpty) {
      cs = cours;
    }
    //
    print("periodes: $cs");
    //
    //cs.addAll(cours);
    //
    box.write('notecoursobtenue$idPeriode$idEleve', cs);
    return cs;
  }
}
