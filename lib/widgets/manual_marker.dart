import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) => state.displayManualMarker ? const _ManualMarkerBody() : const SizedBox()
    );
  }
}

class _ManualMarkerBody extends StatelessWidget {
  const _ManualMarkerBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [

          const Positioned(
            top: 70,
            left: 20,
            child: _BtnBack(),
          ),

          Center(
            child: Transform.translate(
              offset: const Offset(0,-22),
              child: BounceInDown(
                from: 100,
                child: const Icon(
                  Icons.location_on_sharp, size: 50, color: Colors.red
                )
              ),
            ),
          ),
          // Boton de confrimar
          Positioned(
            bottom: 70,
            left: 40,
            child: FadeInUp(
              duration: const Duration(milliseconds: 500),
              child: MaterialButton(
                minWidth: size.width -120,
                color: Colors.black,
                elevation: 1,
                height:50,
                shape: const StadiumBorder(),
                child: const Text('Confirmar destino', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w300),),
                onPressed: (){
                  //TODO: confirmar ubicacion
                }
              ),
            )
          ),

        ]
      ),
    );
  }
}

class _BtnBack extends StatelessWidget {
  const _BtnBack({Key? key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return FadeInLeft(
      duration: const Duration(milliseconds: 500),
      child: CircleAvatar(
        maxRadius: 30,
        backgroundColor: Colors.white,
        child: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
          onPressed: (){
            BlocProvider.of<SearchBloc>(context).add(OnDeactivateManualMarkerEvent());
          }, 
        ),
      ),
    );
  }
}