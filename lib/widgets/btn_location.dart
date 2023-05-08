import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';
import 'package:mapas_app/ui/ui.dart';

class BtnCurrentLocation extends StatelessWidget {
  const BtnCurrentLocation({super.key});

  @override
  Widget build(BuildContext context) {
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.my_location_outlined, color: Color.fromARGB(255, 15, 15, 15)),
          onPressed: () {
            final userLocation = locationBloc.state.lastKnownLocation;

            if (userLocation == null) {
              final snack = CustomSnackbar(
                message: const Text('No hay ubicación', style: TextStyle(color: Color.fromARGB(255, 15, 15, 15)))
              );
              ScaffoldMessenger.of(context).showSnackBar(snack);
              return;
            }
            //TODO: Snack
            mapBloc.moveCamera(userLocation);
          },
        ),
      ),
    );
  }
}
