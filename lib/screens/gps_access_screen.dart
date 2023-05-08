import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';

class GpsAccessScreen extends StatelessWidget {
  const GpsAccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: BlocBuilder<GpsBloc, GpsState>(
        builder: (context, state) {
          return !state.isGpsEnabled
              ? const _EnableGPSMessage()
              : const _AccessButton();
        },
      )),
    );
  }
}

class _AccessButton extends StatelessWidget {
  const _AccessButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
          height: 15,
        ),
        const Text('Es necesario el acceso al GPS'),
        MaterialButton(
          onPressed: () {
            final gpsBloc = BlocProvider.of<GpsBloc>(context);
            gpsBloc.askGpsAccess();
          },
          color: Colors.black,
          shape: const StadiumBorder(),
          elevation: 0,
          splashColor: Colors.transparent,
          child: const Text('Habilitar GPS',style: TextStyle(color: Colors.white)),
        )
      ],
    );
  }
}

class _EnableGPSMessage extends StatelessWidget {
  const _EnableGPSMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text('Debe habilitar el GPS',style: TextStyle(fontSize: 25, fontWeight: FontWeight.w300),);
  }
}
