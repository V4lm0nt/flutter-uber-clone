import 'dart:convert';
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:mapas_app/blocs/blocs.dart';
import 'package:mapas_app/models/models.dart';
import 'package:mapas_app/themes/themes.dart';

import '../../helpers/helpers.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final LocationBloc locationBloc;

  StreamSubscription<LocationState>? locationStateSubscription;

  GoogleMapController? _mapController;
  LatLng? mapCenter;

  MapBloc({required this.locationBloc}) : super(const MapState()) {

    on<OnMapInitializedEvent>(_onInitMap);

    on<OnStartFollowingUserEvent>(_onStartFollowingUser);

    on<OnStopFollowingUserEvent>((event, emit) => emit(state.copyWith(isFollowingUser: false)));

    on<UpdateUserPolylineEvent>(_onPolylineNewPoint);

    on<OnToggleUserRoute>((event, emit) => emit(state.copyWith(showMyRoute: !state.showMyRoute)));

    on<DisplayPolylinesEvent>((event, emit) => emit(state.copyWith(polylines: event.polylines, markers: event.markers)));

    
    locationStateSubscription = locationBloc.stream.listen((locationState) {
      if (locationState.lastKnownLocation != null) {
        add(UpdateUserPolylineEvent(locationState.myLocationHistory));
      }

      if (!state.isFollowingUser) return;
      if (locationState.lastKnownLocation == null) return;

      moveCamera(locationState.lastKnownLocation!);
    });
  }

  void _onStartFollowingUser(
      OnStartFollowingUserEvent event, Emitter<MapState> emit) {
    emit(state.copyWith(isFollowingUser: true));
    if (locationBloc.state.lastKnownLocation == null) return;
    moveCamera(locationBloc.state.lastKnownLocation!);
  }

  void _onPolylineNewPoint(UpdateUserPolylineEvent event, Emitter<MapState> emit) {
    final myRoute = Polyline(
        polylineId: const PolylineId('myRoute'),
        color: const Color.fromARGB(90, 0, 132, 255),
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        points: event.userLocations);

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['myRoute'] = myRoute;
    emit(state.copyWith(polylines: currentPolylines));
  }

  Future drawRoutePolyline( RouteDestination destination ) async {

    final myRoute = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.white54,
      points: destination.points,
      width: 5,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );

    final currentPolylines = Map<String, Polyline>.from(state.polylines);
    currentPolylines['route'] = myRoute;

    double kms = destination.distance / 1000;
      kms= (kms * 100).floorToDouble();
      kms /= 100;
      
    int tripDuration = (destination.duration / 60).floor();

    //Custom Markers
    //final startMarkers = await getAssetImageMarker();
    //final endMarkers = await getNetworkImageMarker();
    final customStartMarkers = await getStartCustomMarker(tripDuration, 'Mi Ubicacion');
    final customEndMarkers = await getEndCustomMarker(kms.toInt(), destination.endPlace.text);

    final startMarker = Marker(
      markerId: const MarkerId('start'),
      position: destination.points.first,
      icon: customStartMarkers,
      anchor: const Offset(0.1, 1)
      //infoWindow: InfoWindow(
      //  title: 'Inicio',
      //  snippet: 'Distancia: $kms Km. - Duracion: $tripDuration Min.'
      //)         
    );

    final endMarker = Marker(
      markerId: const MarkerId('end'),
      position: destination.points.last,
      icon: customEndMarkers,
      //infoWindow:  InfoWindow(
      //  title: destination.endPlace.text,
      //  snippet: destination.endPlace.placeName
      //),
             
    );

    final currentMarkers = Map<String, Marker>.from(state.markers);
    currentMarkers['start'] = startMarker;
    currentMarkers['end'] = endMarker;
    
    
    add(DisplayPolylinesEvent(currentPolylines, currentMarkers));

  //  await Future.delayed(const Duration(milliseconds: 500));
  //  _mapController?.showMarkerInfoWindow(const MarkerId('start'));

  }

  void _onInitMap(OnMapInitializedEvent event, Emitter<MapState> emit) {
    _mapController = event.controller;
    _mapController!.setMapStyle(jsonEncode(mapTheme));
    emit(state.copyWith(isMapInitialized: true));
  }

  void moveCamera(LatLng newLocation) {
    final cameraUpdate = CameraUpdate.newLatLng(newLocation);
    _mapController?.moveCamera(cameraUpdate);
  }

  @override
  Future<void> close() {
    locationStateSubscription?.cancel();
    return super.close();
  }
}
