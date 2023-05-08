import 'package:flutter/material.dart';
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
    return const Text('buildResults');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on_outlined, color: Colors.black87),
          title: const Text('Colocar la ubicación manualmente', style: TextStyle(color: Colors.black87),),
          onTap: () { 
            //TODO: regresar algo
            final result = SearchResult(cancel: false, manual: true);
            close(context, result);
          },
        )
      ],
    );
  }
}
