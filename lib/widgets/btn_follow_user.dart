import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';

class BtnFollowUser extends StatelessWidget {
  const BtnFollowUser({super.key});

  @override
  Widget build(BuildContext context) {

    final mapBloc = BlocProvider.of<MapBloc>(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: CircleAvatar(
        maxRadius: 25,
        backgroundColor: Colors.white,
        child: BlocBuilder<MapBloc, MapState>(
          builder: (context, state) {
            return IconButton(
              icon: Icon( 
                state.isFollowingUser 
                  ? Icons.directions_run_rounded 
                  : Icons.hail_rounded, 
                  color: const Color.fromARGB(255, 15, 15, 15)),
              onPressed: () => mapBloc.add(OnStartFollowingUserEvent()),
            );
          },
        ),
      ),
    );
  }
}
