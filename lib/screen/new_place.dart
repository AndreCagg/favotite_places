import "dart:convert";
import "dart:io";

import "package:favorite_places/model/place.dart";
import "package:favorite_places/provider/place_provider.dart";
import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import "package:favorite_places/model/custom_location.dart";

class NewPlace extends StatefulWidget {
  const NewPlace({super.key});

  @override
  State<NewPlace> createState() {
    return _NewPlaceState();
  }
}

class _NewPlaceState extends State<NewPlace> {
  var _formKey = GlobalKey<FormState>();
  File? img_to_show;
  late String _place;
  String? latitudine;
  String? longitudine;

  void salvaLuogo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (latitudine != null && longitudine != null && img_to_show != null) {
        Place p = Place(
          _place,
          img_to_show!,
          CustomLocation(latitudine!, longitudine!),
        );
        //Provider.of<PlaceProvider>(context, listen: false).addPlace(p);

        /*Directory appDir = await pp.getApplicationDocumentsDirectory();
        String filename = path.basename(img_to_show!.path);
        File newFile = await img_to_show!.copy("${appDir.path}/$filename");

        // invio al server
        http.post(
          Uri.https(
            "place-937c1-default-rtdb.firebaseio.com",
            "places/${p.id}.json",
          ),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "id": p.id,
            "place": _place,
            "file": newFile.path,
            "location": {"latitudine": latitudine, "longitudine": longitudine},
          }),
        );*/
        Provider.of<PlaceProvider>(context, listen: false).savePlace(p, true);

        Navigator.of(context).pop();
      } else {
        print("lat lon file non validi");
      }
    }
  }

  void takeImage() async {
    File? selected;

    final ImagePicker picker = ImagePicker();
    XFile? img = await picker.pickImage(source: ImageSource.camera);

    if (img == null) {
      print("nessuna immagine selezionata");
    } else {
      selected = File(img.path);

      setState(() {
        img_to_show = selected;
      });
    }
  }

  void takeLocation() async {
    Location location = Location();

    LocationData position = await location.getLocation();

    setState(() {
      latitudine = position.latitude.toString();
      longitudine = position.longitude.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Nuovo luogo")),
      body: Padding(
        padding: EdgeInsetsGeometry.only(left: 20, right: 20, top: 30),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Il luogo non può essere vuoto";
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text("Nome del luogo"),
                      ),
                      onSaved: (newValue) {
                        if (newValue != null) {
                          _place = newValue;
                        }
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: takeImage,
                    icon: Icon(Icons.image),
                  ), //foto btn
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: takeLocation,
                    icon: Icon(Icons.map),
                  ), //gps btn
                ],
              ),
              SizedBox(height: 20),
              Expanded(
                // gps coord
                flex: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.gps_fixed),
                    latitudine != null
                        ? Text(" " + latitudine! + " " + longitudine!)
                        : Text(""),
                  ],
                ),
              ),
              img_to_show != null
                  ? Expanded(
                      flex: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                img_to_show = null;
                              });
                            },
                            icon: Icon(Icons.cancel),
                          ),
                          Image.file(img_to_show!),
                        ],
                      ),
                    )
                  : Text("Nessuna immagine selezionata"),
              SizedBox(height: 20),
              FilledButton.tonal(
                onPressed: salvaLuogo,
                child: const Text("Inserisci"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
