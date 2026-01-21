import "dart:convert";

import "package:favorite_places/model/place.dart";
import "package:flutter/material.dart";
import "package:favorite_places/screen/new_place.dart";
import "package:favorite_places/provider/place_provider.dart";
import "package:provider/provider.dart";
import "package:http/http.dart" as http;
import "package:favorite_places/widget/list_item.dart";

class FavoritePlaces extends StatefulWidget {
  const FavoritePlaces({super.key});

  @override
  State<FavoritePlaces> createState() {
    return _FavoritePlacesState();
  }
}

class _FavoritePlacesState extends State<FavoritePlaces> {
  Place? lastPlace;

  void openNewPlace() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return NewPlace();
        },
      ),
    );
  }

  void downloadPlaces() async {
    final response = await http.get(
      Uri.https('place-937c1-default-rtdb.firebaseio.com', 'places.json'),
    );

    if (response.body != "null") {
      print(response.body);
      final Map<String, dynamic> data = jsonDecode(response.body);
      final Map<String, Place> loadedPlaces = {};

      if (data != "error" && data != "null") {
        data.forEach((placeId, placeData) {
          final innerMap = placeData as Map<String, dynamic>;

          innerMap.forEach((_, placeJson) {
            Place p = Place.fromJson(placeJson);
            loadedPlaces[p.id] = p;
            print(p.id);
          });
        });

        Provider.of<PlaceProvider>(
          context,
          listen: false,
        ).initState(loadedPlaces);
      }
    }
  }

  void removeItem(String id) async {
    final res = await http.delete(
      Uri.https('place-937c1-default-rtdb.firebaseio.com', 'places/$id.json'),
    );

    print(res.statusCode);
    if (res.statusCode == 200) {
      Provider.of<PlaceProvider>(context, listen: false).removePlace(id);
    }
  }

  @override
  void initState() {
    super.initState();
    downloadPlaces();
  }

  @override
  Widget build(BuildContext context) {
    //downloadPlaces();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Luoghi preferiti"),
        actions: [IconButton(onPressed: openNewPlace, icon: Icon(Icons.add))],
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(20),
        child: Consumer<PlaceProvider>(
          builder: (context, provider, child) {
            List<Place> list = provider.places.values.toList();
            return ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, idx) {
                return Dismissible(
                  key: ValueKey(list[idx].id),
                  onDismissed: (direction) {
                    lastPlace = list[idx];
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Luogo rimosso"),
                        action: SnackBarAction(
                          label: 'Annulla',
                          onPressed: () {
                            Provider.of<PlaceProvider>(
                              context,
                              listen: false,
                            ).savePlace(lastPlace!, false);
                          },
                        ),
                      ),
                    );
                    return removeItem(list[idx].id);
                  },
                  child: ListItem(
                    file: list[idx].file,
                    place: list[idx].place,
                    latitudine: list[idx].location.latitudine,
                    longitudine: list[idx].location.longitudine,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
