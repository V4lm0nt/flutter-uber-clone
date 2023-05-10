part of 'search_bloc.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class OnActivateManualMarkerEvent extends SearchEvent{}
class OnDeactivateManualMarkerEvent extends SearchEvent{}

class OnNewsPlacesFoundEvent extends SearchEvent{
  final List<Feature> places;
  const OnNewsPlacesFoundEvent(this.places);
}

class OnAddToHistoryEvent extends SearchEvent{
  final Feature place;
  const OnAddToHistoryEvent(this.place);
}
