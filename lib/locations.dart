
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class Locations {
  late List<Regions> regions;
  late List<Pharmacy> pharmacies;

  Locations({required this.pharmacies, required this.regions});

  //Locations.fromJson(Map<String, dynamic> json) {
  Locations.fromJson(Map<String, dynamic>  json) {


    List<dynamic> jsonList = json as List;
    pharmacies = jsonList.map((json) => Pharmacy.fromJson(json)).toList();

/*    if (json['pharmacies'] != null) {
      pharmacies = <Pharmacy>[];

      json['pharmacies'].forEach((v) {
        pharmacies.add(new Pharmacy.fromJson(v));
      });
    if (json['regions'] != null) {
      regions = <Regions>[];
      json['regions'].forEach((v) {
        regions.add(new Regions.fromJson(v));
      });
    }

    }*/
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pharmacies != null) {
      data['pharmacies'] = this.pharmacies.map((v) => v.toJson()).toList();
    }
    if (this.regions != null) {
      data['regions'] = this.regions.map((v) => v.toJson()).toList();
    }

    return data;
  }


}




Future<Locations> getPharmacyOffices() async {
  const pharmacyLocationsURL = 'https://openapi.izmir.bel.tr/api/ibb/nobetcieczaneler';
  final Uri pharmacyLocationsURI = Uri.parse(pharmacyLocationsURL);
  // Retrieve the locations of Google offices
  final response = await http.get(pharmacyLocationsURI);
  if (response.statusCode == 200) {
    return Locations.fromJson(json.decode(response.body));
  } else {
    throw HttpException(
        'Unexpected status code ${response.statusCode}:'
            ' ${response.reasonPhrase}',
        uri: Uri.parse(pharmacyLocationsURL));
  }
}

Future<List<Pharmacy>> fetchPharmacies() async {
  final response = await http.get(Uri.https('openapi.izmir.bel.tr', '/api/ibb/nobetcieczaneler'));

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    List<dynamic> jsonResponse = json.decode(response.body);
    return jsonResponse.map((pharmacy) => Pharmacy.fromJson(pharmacy)).toList();
  } else {
    // If the call to the server was unsuccessful, throw an error
    throw Exception('Failed to load pharmacies');
  }
}




class Pharmacy {
  String Tarih = '';
  double LokasyonY = 0.0;
  double LokasyonX = 0.0;
  String BolgeAciklama= '';
  String Adi= '';
  String Telefon= '';
  String Adres= '';
  int BolgeId= 0;
  String Bolge = '';
  double UzaklikMetre= 0.0;
  int EczaneId= 0;
  int IlceId= 0;

  Pharmacy({
    required this.Tarih,
    required this.LokasyonY,
    required this.LokasyonX,
    required this.BolgeAciklama,
    required this.Adi,
    required this.Adres,
    required this.BolgeId,
    required this.Bolge,
    required this.UzaklikMetre,
    required this.EczaneId,
    required this.IlceId,
    });

  Pharmacy.fromJson(Map<String, dynamic> json) {
    Tarih = json['Tarih'];
    LokasyonY = json['LokasyonY'];
    LokasyonX = json['LokasyonX'];
    BolgeAciklama = json['BolgeAciklama'];
    Adi = json['Adi'];
    Telefon = json['Telefon'];
    Adres = json['Adres'];
    BolgeId = json['BolgeId'];
    Bolge = json['Bolge'];
    UzaklikMetre = json['UzaklikMetre'];
    EczaneId = json['EczaneId'];
    IlceId = json['IlceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Tarih'] = this.Tarih;
    data['LokasyonY'] = this.LokasyonY;
    data['LokasyonX'] = this.LokasyonX;
    data['BolgeAciklama'] = this.BolgeAciklama;
    data['Adi'] = this.Adi;
    data['Telefon'] = this.Telefon;
    data['Adres'] = this.Adres;
    data['BolgeId'] = this.BolgeId;
    data['Bolge'] = this.Bolge;
    data['UzaklikMetre'] = this.UzaklikMetre;
    data['EczaneId'] = this.EczaneId;
    data['IlceId'] = this.IlceId;
    return data;
  }
}

class Regions {
  Coords coords= Coords(lat:0.0,lng:0.0);
  String id='';
  String name='';
  double zoom=0.0;

  Regions({required this.coords, required this.id, required this.name, required this.zoom});

  Regions.fromJson(Map<String, dynamic> json) {
    coords =
    (json['coords'] != null ? new Coords.fromJson(json['coords']) :Coords(lat:0.0,lng:0.0));
    id = json['id'];
    name = json['name'];
    zoom = json['zoom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.coords != null) {
      data['coords'] = this.coords.toJson();
    }
    data['id'] = this.id;
    data['name'] = this.name;
    data['zoom'] = this.zoom;
    return data;
  }
}

class Coords {
  double lat=0.0;
  double lng=0.0;

  Coords({required this.lat, required this.lng});

  Coords.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    lng = json['lng'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    return data;
  }
}