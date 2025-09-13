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
import 'package:smart_keslassi_parent/utils/requete.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            // Slider des promotions
            SizedBox(
              height: 270,
              child: PageView.builder(
                controller: _promoController,
                itemCount: promotions.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPromoIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPromoCard(promotions[index]);
                },
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                promotions.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPromoIndex == index
                            ? Colors.blue
                            : Colors.grey[300],
                  ),
                ),
              ),
            ),

            // Boutons principaux
            Expanded(
              child: Obx(
                () => ListView(
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
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          //Get.to(QRViewExample());
          //
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
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
          //
        },
        child: Icon(Icons.person_add_alt),
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
        "${Requete.urlSt}/eleve/details/$code",
      ); // <-- Change avec ton serveur
      final response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
        //body: jsonEncode({"qr_code": code}),
      );

      if (response.statusCode == 200) {
        Get.back();
        final data = jsonDecode(response.body);
        print('data: $data');
        //
        List els = box.read("eleves") ?? [];
        els.add(data);
        //
        box.write("eleves", els);
        //
        eleves.value = els;
        //
        Get.snackbar(
          "Succès",
          "Enregistrement éffectué: ${response.statusCode}",
        );
      } else {
        Get.back();
        Get.snackbar("Erreur", "Erreur: ${response.statusCode}");
      }
    } catch (e) {
      Get.back();
      Get.snackbar("Erreur", "Erreur: $e");
    }
  }
}
