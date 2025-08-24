import 'dart:io';

import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_keslassi_parent/pages/eleves/frais/frais.dart';
import 'package:smart_keslassi_parent/pages/eleves/profile/profil.dart';

class DetailEleves extends StatelessWidget {
  //
  Map eleve;
  //
  String anneescolaire;
  //
  final List<Map<String, dynamic>> adminMenu = [
    {
      'title': 'Bulletin',
      'icon': "HugeiconsTextFirstlineLeft",
      'route': '/dashboard',
    },
    {
      'title': 'Cours & Points',
      'icon': "HugeiconsNote03",
      'route': '/students',
    },
    {'title': 'Frais', 'icon': "HugeiconsEstimate01", 'route': '/courses'},
    {'title': 'Parcours', 'icon': "HugeiconsChartUp", 'route': '/classes'},
    {'title': 'Conduite', 'icon': "HugeiconsProfile02", 'route': '/streams'},
    // {'title': 'Notes', 'icon': "HugeiconsNotebook02", 'route': '/streams'},
    {'title': 'Profile', 'icon': "HugeiconsUser02", 'route': '/streams'},
    // {'title': 'Paramètres', 'icon': Icons.settings, 'route': '/settings'},
    // {'title': 'Déconnexion', 'icon': Icons.logout, 'route': '/logout'},
  ];
  DetailEleves(this.eleve, this.anneescolaire) {
    //
  }
  //
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          InkWell(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.only(right: 10),
              child: CircleAvatar(
                //backgroundImage: NetworkImage(eleve['url']),
                //child: EleveWidgets.loadImage(eleve['numeroIdentifiant']),
                backgroundImage: NetworkImage(
                  'https://randomuser.me/api/portraits/women/20.jpg',
                ),
              ),
            ),
          ),
        ],
        title: RichText(
          text: TextSpan(
            text:
                "${eleve['nom']} ${eleve['postnom']} ${eleve['prenom']}"
                    .toUpperCase(),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            eleve['classe'],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.blue,
            ),
          ),
          Text(
            anneescolaire,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Expanded(
            flex: 9,
            child: Center(
              child: Container(
                height: 500,
                width: 500,
                child: GridView.count(
                  crossAxisCount: 3,
                  children: List.generate(adminMenu.length, (e) {
                    //
                    Map menu = adminMenu[e];

                    return Card(
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: InkWell(
                        onTap: () async {
                          //

                          if (e == 0) {
                            //
                          }

                          if (e == 1) {}

                          if (e == 2) {
                            Get.to(Frais(eleve, anneescolaire));
                          }

                          if (e == 3) {}

                          if (e == 4) {}

                          // if (e == 5) {
                          //   eleve['option'] = adminMenu[e]['title'];
                          //   Get.to(Notes(eleve, classe));
                          // }

                          //

                          if (e == 5) {
                            //
                            Get.to(Profil(eleve));
                          }

                          //Get.to(ProfilEleve("20${e + 24}-20${e + 25}"));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //Icon(menu['icon'], color: Colors.blue),
                              SvgPicture.asset(
                                "assets/${menu['icon']}.svg",
                                width: 35,
                                colorFilter: const ColorFilter.mode(
                                  Colors.blue,
                                  BlendMode.srcIn,
                                ),
                                semanticsLabel: 'Red dash paths',
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${menu['title']}",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "${menu['title']}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  //
  Future<List<Map<String, dynamic>>> getAllDomaine(List cours) async {
    //
    //print('Bultin; $bultin');
    //
    // Regroupement par description -> domaine -> cours
    Map<String, Map<String, dynamic>> descriptionMap = {};

    for (var item in cours) {
      String desc = item['description'] ?? "";
      String dom = item['domaine'] ?? "";

      if (!descriptionMap.containsKey(desc)) {
        descriptionMap[desc] = {"description": desc, "domaines": {}};
      }

      var domaines = descriptionMap[desc]!["domaines"] as Map<dynamic, dynamic>;
      if (!domaines.containsKey(dom)) {
        domaines[dom] = {"domaine": dom, "cours": []};
      }

      (domaines[dom]["cours"] as List).add({
        "nom": item['nom'] ?? "",
        "penseration": item['penderation']?.toString() ?? "",
        "cle": item['cle']?.toString() ?? "",
      });
    }

    // Conversion en liste avec sous-listes
    List<Map<String, dynamic>> result =
        descriptionMap.values.map((descEntry) {
          var domainesList =
              (descEntry["domaines"] as Map<dynamic, dynamic>).values.toList();
          return {
            "description": descEntry["description"],
            "domaines": domainesList,
          };
        }).toList();

    // Affichage formaté
    //print(JsonEncoder.withIndent("  ").convert(result));
    //
    return result;
  }

  //
}
