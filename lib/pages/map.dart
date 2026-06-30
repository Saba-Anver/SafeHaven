import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng pinCoordinates = LatLng(24.860966, 66.990501);
  bool isLoading = false;
  List<Map<String, dynamic>> suggestions = [];
  Timer? debouncingTimer;
  TextEditingController searchController = TextEditingController();
  MapController mapController = MapController();

  @override
  Widget build(BuildContext context) {
    print('build called');
    return Scaffold(
      appBar: AppBar(title: Text("Map Screen")),
      body: Stack(
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: LatLng(24.860966, 66.990501),
              initialZoom: 7,
            ),
            children: [
              TileLayer(
                subdomains: ['a', 'b', 'c', 'd'],
                urlTemplate:
                    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: pinCoordinates,
                    child: Icon(Icons.location_pin, color: Colors.red),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 16,
            left: 13,
            right: 13,
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                debouncingTimer?.cancel();
                debouncingTimer = Timer(Duration(milliseconds: 500), () async {
                  var response = await http.get(
                    Uri.parse(
                      "https://api.geoapify.com/v1/geocode/autocomplete?text=$value&apiKey=${dotenv.env["GEOAPIFY_KEY"]}",
                    ),
                  );
                  setState(() {
                    suggestions.clear();
                    for (var suggestion in jsonDecode(
                      response.body,
                    )['features']) {
                      if (suggestion['properties']['country'] == 'Pakistan') {
                        suggestions.add({
                          'address': suggestion['properties']['formatted'],
                          'lat': suggestion['properties']['lat'],
                          'lon': suggestion['properties']['lon'],
                        });
                      }
                    }
                  });
                });
              },
              decoration: InputDecoration(
                hintText: "Search",
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.yellow),
                ),
                fillColor: Colors.white,
                filled: true,

                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.search),
                ),
              ),
            ),
          ),
          if (suggestions.isNotEmpty)
            Positioned(
              top: 70,
              left: 13,
              right: 13,
              bottom: 200,
              child: ListView.separated(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  return Material(
                    color: Colors.white,
                    child: ListTile(
                      title: Text(suggestions[index]['address'].toString()),
                      onTap: () {
                        setState(() {
                          pinCoordinates = LatLng(
                            suggestions[index]['lat'],
                            suggestions[index]['lon'],
                          );
                        });
                        mapController.move(pinCoordinates, 16);
                        suggestions.clear();
                        searchController.clear();
                      },
                    ),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(height: 4),
              ),
            )
          else
            SizedBox.shrink(),
        ],
      ),
    );
  }
}
