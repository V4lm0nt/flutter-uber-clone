class SearchResult{
  
  final bool cancel;
  final bool manual;

  SearchResult({
    required this.cancel, 
    this.manual = false
  });

  //TODO: name, description, position (latlng)

  @override
  String toString() {
    return '{ cancel: $cancel, manual: $manual }';
  }
}