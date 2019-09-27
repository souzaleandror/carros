import 'package:carros/pages/carros/carro.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapaPage extends StatelessWidget {
  final Carro carro;

  const MapaPage({Key key, this.carro}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(carro.nome),
        centerTitle: true,
      ),
      body: _body(),
    );
  }

  _body() {
    return Container(
      child: GoogleMap(
        //mapType: MapType.satellite,
        mapType: MapType.normal,
        zoomGesturesEnabled: true,
        initialCameraPosition: CameraPosition(target: latLng(), zoom: 17),
        markers: Set.of(_getMarkers()),
      ),
    );
  }

  latLng() {
    //return LatLng(-22.951911, -43.2126759);
    return carro.latlng;
  }

  List<Marker> _getMarkers() {
    return [
      Marker(
          markerId: MarkerId("1"),
          position: carro.latlng,
          infoWindow: InfoWindow(
              title: carro.nome,
              snippet: "Fabrica da ${carro.nome}",
              onTap: () {
                print("Clico na janela");
              }),
          onTap: () {
            print("clico no Marcador");
          }),
    ];
  }
}
