import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:smart_keslassi_parent/pages/eleves/profile/adresse.dart';
import 'package:smart_keslassi_parent/pages/eleves/profile/parent.dart';
import 'package:smart_keslassi_parent/pages/eleves/profile/info_perso.dart';

class Profil extends StatelessWidget {
  //
  RxInt _selectedIndex = 0.obs;
  //
  Map eleve = {};
  //
  Profil(this.eleve) {
    vue = Rx(InfoPerso(eleve));
  }
  //
  Rx<Widget> vue = Rx(Container());
  //
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      body: Obx(() => vue.value),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _selectedIndex.value,
          onTap: (e) {
            //
            _selectedIndex.value = e;
            //
            if (e == 0) {
              //
              vue.value = InfoPerso(eleve);
            } else if (e == 1) {
              //
              vue.value = Parent(eleve);
            } else {
              //
              vue.value = Adresse(eleve);
            }
          },
          selectedItemColor: Colors.blue,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Infos personnel",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: "Parents",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on),
              label: "Adresse",
            ),
          ],
        ),
      ),
    );
  }

  //
}
