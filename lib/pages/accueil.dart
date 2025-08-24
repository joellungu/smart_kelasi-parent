import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:smart_keslassi_parent/pages/eleves/anneescolaire.dart';

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
              child: ListView(
                padding: const EdgeInsets.all(25.0),
                children: [
                  ListTile(
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
                      /*
                      eleve['categorie'] = ""; // widget.categorie;
                      eleve['annee_scolaire'] = widget.annee_scolaire;
                      //
                      Map e = {
                        "url":
                        "https://randomuser.me/api/portraits/women/2${index + 1}.jpg",
                        "categorie": widget.categorie,
                        "annee_scolaire": widget.annee_scolaire,
                        "nom":
                        "${eleve['nom']} ${eleve['postnom']} ${eleve['prenom']}",
                        "classe": eleve['classe'],
                      };
                      */
                      Get.to(Anneescolaire(eleve));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //
          Get.dialog(
            Center(
              child: Card(
                child: Container(
                  padding: EdgeInsets.all(20),
                  height: Get.height / 3.5,
                  width: 270,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Code de l'élève",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextField(
                        textAlign: TextAlign.center,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: "Code de l'élève",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          //
                          Get.back();
                          //
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Valider",
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
}
