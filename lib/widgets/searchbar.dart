import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapas_app/blocs/blocs.dart';
import 'package:mapas_app/delegates/delegates.dart';
import 'package:mapas_app/helpers/helpers.dart';
import 'package:mapas_app/models/models.dart';

class MyCustomSearchBar extends StatelessWidget {
  const MyCustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        if(state.displayManualMarker){
          return Container();
        }else{
          return FadeInDown(duration: const Duration(milliseconds: 300),child: const _SearchBarBody());
        }
      },
    );
  }
}

class _SearchBarBody extends StatelessWidget {
  const _SearchBarBody({Key? key}) : super (key: key);

  void onSearchResults(BuildContext context, SearchResult result) async{
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final locationBloc = BlocProvider.of<LocationBloc>(context);
    final mapBloc = BlocProvider.of<MapBloc>(context);

    if(result.manual == true ){
      searchBloc.add(OnActivateManualMarkerEvent());
      return;
    }

    if( result.position!=null && locationBloc.state.lastKnownLocation!=null ){
      final navigator = Navigator.of(context);

      final start = locationBloc.state.lastKnownLocation!;
      final end = result.position!;

      showLoadingMessage(context);

      final destination = await searchBloc.getCoorsStartToEnd(start, end);
      await mapBloc.drawRoutePolyline(destination);

      navigator.pop();
    }

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        //color: Colors.red,
        width: double.infinity,
        //height: 50,
        child: GestureDetector(
          onTap: () async{
            final result = await showSearch(context: context, delegate: SearchDestinationDelegate());            
            if(result == null) return;
            // ignore: use_build_context_synchronously
            onSearchResults(context, result);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: Offset(0, 5)
                )
              ]
            ),
            child: const Text('¿Dónde quieres ir?', style: TextStyle(color: Colors.black87),),
          ),
        ),
      ),
    );
  }
}