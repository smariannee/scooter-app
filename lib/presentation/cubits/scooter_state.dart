import 'package:equatable/equatable.dart';
import 'package:scooter_app/model/scooter_model.dart';

abstract class ScooterState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScooterInitial extends ScooterState {}

class ScooterLoading extends ScooterState {}

class ScooterSuccess extends ScooterState {
  final List<ScooterModel> scooters;

  ScooterSuccess(this.scooters);

  @override
  List<Object> get props => [scooters];
}

class ScooterError extends ScooterState {
  final String message;

  ScooterError(this.message);

  @override
  List<Object> get props => [message];
}