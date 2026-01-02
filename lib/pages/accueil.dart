import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:smart_keslassi_parent/main.dart';
import 'package:smart_keslassi_parent/pages/eleves/anneescolaire.dart';
import 'package:smart_keslassi_parent/pages/scanner.dart';
import 'package:smart_keslassi_parent/utils/paiement_controller.dart' as p;
import 'package:smart_keslassi_parent/utils/payement.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';
import 'package:smart_keslassi_parent/utils/verification.dart';

class Accueil extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    //
    return _Accueil();
  }

  //
}

class _Accueil extends State<Accueil> {
  //
  final PageController _promoController = PageController(viewportFraction: 0.8);
  //
  Verification verification = Verification();
  //
  p.PaieController paiementController = Get.put(p.PaieController());
  //
  int _currentPromoIndex = 0;
  //
  var box = GetStorage();
  //
  final List<Map> promotions = [
    {
      "title": "Réduction Café",
      "description": "Obtenez 20% sur votre prochain café",
      "pointsCost": 100,
      "imagePath": "assets/coffee-shop-1.png",
    },
    {
      "title": "Menu Gratuit",
      "description": "Échangez 500 points pour un menu complet",
      "pointsCost": 500,
      "imagePath": "assets/restaurant-menu-.png",
    },
    {
      "title": "Bon d'achat",
      "description": "10€ de réduction pour 1000 points",
      "pointsCost": 1000,
      "imagePath": "assets/coffee-shop-2.png",
    },
  ];

  Map eleve = {
    "id": 1,
    "cle": "2aa83f70-7f61-11f0-8b08-959d91db721f",
    "nom": "Lungu",
    "postnom": "Lungu",
    "prenom": "Joel",
    "sexe": "Masculin",
    "dateNaissance": "15-6-2005",
    "lieuNaissance": "Kinshasa",
    "numeroIdentifiant": "ELV-20250822-3158",
    "dateEnregistrement": "22-8-2025",
    "anneescolaire": "2025-2026",
    "classe": "2ème Humanités générales & techniques Technologie Ameublement A",
    "synced": 0,
    "updatedAt": "2025-08-22T15:06:15.271346",
  };
  //

  @override
  void initState() {
    //
    eleves.value = box.read("eleves") ?? [];
    //
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              //
              eleves.value = [];
              //
              box.write("eleves", []);
              //
            },
            icon: Icon(Icons.exit_to_app),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Boutons principaux
            Expanded(
              child: Obx(() {
                if (eleves.isNotEmpty) {
                  return ListView(
                    padding: const EdgeInsets.all(25.0),
                    children: List.generate(eleves.length, (e) {
                      Map eleve = eleves[e];
                      //
                      return ListTile(
                        leading: CircleAvatar(
                          /*
                        child: EleveWidgets.loadImage(
                        eleve['numeroIdentifiant'],
                      ),
                      */
                          backgroundImage: NetworkImage(
                            'https://randomuser.me/api/portraits/women/20.jpg',
                          ),
                          //child: Text(eleve['nom'][0])
                        ),
                        title: Text(
                          "${eleve['nom']} ${eleve['postnom']} ${eleve['prenom']}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        subtitle: Text(
                          eleve['classe'],
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        trailing: Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          // Action sur clic
                          Get.to(Anneescolaire(eleve));
                        },
                      );
                    }),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 100,
                        width: 200,
                        decoration: BoxDecoration(
                          //color: Colors.blue,
                          //borderRadius: BorderRadius.circular(100),
                          image: const DecorationImage(
                            image: ExactAssetImage(
                              "assets/logo_min_edu_nc.png",

                              //"assets/LOGO-MINEPST-BON.png",
                            ),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsetsGeometry.all(20),
                        child: Text(
                          "Veuillez scanner ou saisir le matricule de votre élève pour suivre son évolution tout au long de sa scolarité (service payant).",
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsetsGeometry.all(10),
        child: FloatingActionButton.extended(
          onPressed: () async {
            //
            //Get.to(QRViewExample());
            Get.dialog(
              Center(
                child: Card(
                  child: Container(
                    color: Colors.grey.shade300,
                    padding: EdgeInsets.all(10),
                    height: 250,
                    width: 250,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          "Ajouter un élève par",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: Size(200, 45),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () async {
                            //
                            Get.back();
                            //
                            String barcodeScanRes =
                                await FlutterBarcodeScanner.scanBarcode(
                                  "red",
                                  "Annuler",
                                  true,
                                  ScanMode.QR,
                                );
                            //
                            Get.dialog(
                              Center(
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                            );
                            //

                            //
                            if (barcodeScanRes.isNotEmpty) {
                              _sendToServer(barcodeScanRes);
                            }
                          },
                          child: Text(
                            "QrCode",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          "Ou par",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            fixedSize: Size(200, 45),
                            textStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Get.back();
                            //
                            TextEditingController barcodeScanRes =
                                TextEditingController();
                            //
                            Get.dialog(
                              Center(
                                child: Card(
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    height: 250,
                                    width: 250,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "Saisiez le code",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        TextField(
                                          controller: barcodeScanRes,
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            fixedSize: Size(200, 45),
                                            textStyle: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          onPressed: () async {
                                            if (barcodeScanRes
                                                .text
                                                .isNotEmpty) {
                                              _sendToServer(
                                                barcodeScanRes.text,
                                              );
                                            }
                                          },
                                          child: Text("Valider"),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Text(
                            "Code",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
            //
          },
          label: Text("Ajouter un élève"),
          icon: Icon(Icons.person_add_alt),
        ),
      ),
    );
  }

  //
  Widget _buildPromoCard(Map promo) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
              child: Image.asset(
                promo['imagePath'],
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    promo['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    promo['description'],
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Icons.credit_score,
                        color: Colors.amber[700],
                        size: 20,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "${promo['pointsCost']} points",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //
  Future<void> _sendToServer(String code) async {
    try {
      final url = Uri.parse(
        "${Requete.urlSt}/eleve/numeroIdentifiant/$code",
      ); // <-- Change avec ton serveur
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
        //body: jsonEncode({"qr_code": code}),
      );

      if (response.statusCode == 200) {
        Get.back();
        final data = jsonDecode(response.body);
        print('response.statusCode: ${response.statusCode}');
        //
        Map eleve = data;
        //
        bool v = await verification.checkAbonnement(
          eleve['numeroIdentifiant'],
          eleve['anneescolaire'],
        );
        //
        if (v) {
          //
          List els = box.read("eleves") ?? [];
          els.add(data);
          //
          box.write("eleves", els);
          //
          eleves.value = els;
          //
          setState(() {});
          //
          Get.snackbar(
            "Succès",
            "Enregistrement éffectué: ${response.statusCode}",
          );
        } else {
          /**
           * public String codeEleve;
    public String anneeScolaire;
    public boolean status;
           */
          Map ab = {
            "codeEleve": eleve['numeroIdentifiant'],
            "anneeScolaire": eleve['anneescolaire'],
            "status": true,
          };
          //
          showDialog(
            context: context,
            builder: (c) {
              return Material(
                color: Colors.transparent,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 300,
                    width: 270,
                    child: PayementMethode(
                      ab,
                      1,
                      () {
                        //
                        print("Salut bro");
                        //
                        List els = box.read("eleves") ?? [];
                        els.add(data);
                        //
                        box.write("eleves", els);
                        //
                        eleves.value = els;
                        //
                        setState(() {});
                        //
                        Get.snackbar(
                          "Succès",
                          "Enregistrement éffectué: ${response.statusCode}",
                        );
                        //
                        verification.enregistreAbonnement(ab);
                      },
                      "Abonnement",
                      "Abonnement",
                    ),
                  ),
                ),
              );
            },
          );
        }
      } else {
        //
        print('response.statusCode: ${response.statusCode}');
        //
        Get.back();
        //
        //
        Get.snackbar("Erreur", "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      Get.back();
      //
      Get.snackbar("Erreur", "Erreur: $e");
    }
  }
}
