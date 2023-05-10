import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapas_app/blocs/blocs.dart';
import 'package:mapas_app/models/models.dart';

class SearchDestinationDelegate extends SearchDelegate<SearchResult> {
  
  
  SearchDestinationDelegate() : super(
    searchFieldLabel: 'Buscar..'
  );

  @override
  List<Widget>? buildActions(Object context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Colors.black87),
        onPressed: () => query = '',
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_rounded, color: Colors.black87),
      onPressed: () {
        final result = SearchResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {

    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity = BlocProvider.of<LocationBloc>(context).state.lastKnownLocation!;
    
    searchBloc.getPlacesByQuery(proximity, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;
        return ListView.separated(
          itemCount: places.length,
          separatorBuilder: (context, i)=> const Divider(), 
          itemBuilder: (context, i){
            final place = places[i];
            return ListTile(
              title: Text(place.text),
              subtitle: Text(place.placeName),
              leading: const Icon(Icons.place_outlined, color: Colors.black,),
              onTap: () {

                final result = SearchResult(
                  cancel: false, 
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName
                );

                
                
                searchBloc.add(OnAddToHistoryEvent(place));

                print(searchBloc.state.history);

                close(context, result);
                
              },
            );
          }
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // referencia al searchBloc.state.history;
    final history = BlocProvider.of<SearchBloc>(context).state.history;
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black87),
          title: const Text('Colocar la ubicación manualmente', style: TextStyle(color: Colors.black87),),
          onTap: () { 
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        ),
        //  todo: Construir la lista de elementos ListTile
        if(history.isNotEmpty)
        ...history.map(
          (place) => ListTile(
            title: Text(place.text),
            subtitle: Text(place.placeName),
            leading: const Icon(Icons.history),
            onTap: (){
              final result = SearchResult(
                  cancel: false, 
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName
                );


                close(context, result);
            },
          )
        )
        
      ],
    );
  }
}
