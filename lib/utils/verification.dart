import 'package:get/get_connect/connect.dart';
import 'package:smart_keslassi_parent/utils/requete.dart';

class Verification {
  //
  Requete requete = Requete();
  //
  Future<bool> checkAbonnement(String codeEleve, String anneeScolaire) async {
    //
    print("codeEleve: $codeEleve || anneeScolaire: $anneeScolaire");
    //
    Response response = await requete.getEe(
      "abonnements/$codeEleve/$anneeScolaire",
    );
    //
    if (response.isOk) {
      print("Data: ${response.statusCode}");
      print("Data: ${response.body}");
      //
      return true;
    } else {
      print("Data: ${response.statusCode}");
      print("Data: ${response.body}");
      //
      return false;
    }
    //
  }

  //
  Future<bool> enregistreAbonnement(Map e) async {
    //
    Response response = await requete.postEe("abonnements/", e);
    //
    if (response.isOk) {
      print("Data 1: ${response.statusCode}");
      print("Data 1: ${response.body}");
      //
      return true;
    } else {
      print("Data 1: ${response.statusCode}");
      print("Data 1: ${response.body}");
      //
      return false;
    }
  }
}
