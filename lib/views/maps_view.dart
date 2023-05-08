import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapas_app/blocs/blocs.dart';

class MapsView extends StatelessWidget {

  final LatLng initialLocation;

  final Set<Polyline> polylines;

  const MapsView({
    super.key, 
    required this.initialLocation, 
    required this.polylines
  });

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    CameraPosition initialCameraPosition = CameraPosition(
      target: initialLocation,
      zoom: 15,
    );

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Listener(
        onPointerMove: (event) => mapBloc.add(OnStopFollowingUserEvent()),
        child: GoogleMap(
          initialCameraPosition: initialCameraPosition,
          compassEnabled: false,
          myLocationEnabled: true,
          zoomControlsEnabled: false,
          myLocationButtonEnabled: false,
          onMapCreated: (controller) => mapBloc.add(OnMapInitializedEvent(controller)),
          polylines: polylines,
          //TODO: Markers
          //TODO: Cuando se mueve el mapa
        ),
      ),
    );
  }
}
