import 'package:bloc/bloc.dart';
import 'package:scooter_app/model/scooter_model.dart';
import 'package:scooter_app/presentation/cubits/scooter_state.dart';
import 'package:scooter_app/repository/scooter_repository.dart';

class ScooterCubit extends Cubit<ScooterState> {
  final ScooterRepository scooterRepository;

  ScooterCubit({required this.scooterRepository}) : super(ScooterInitial());

  // create
  Future<void> saveScooter(ScooterModel scooter) async {
    try {
      emit(ScooterLoading());
      await scooterRepository.saveScooter(scooter);
      emit(ScooterSuccess(await scooterRepository.getScooters()));
    } catch (e) {
      emit(ScooterError('$e'));
    }
  }

  // read
  Future<void> getScooters() async {
    try {
      emit(ScooterLoading());
      final scooters = await scooterRepository.getScooters();
      emit(ScooterSuccess(scooters));
    } catch (e) {
      emit(ScooterError('$e'));
    }
  }

  // update
  Future<void> updateScooter(ScooterModel scooter) async {
    try {
      emit(ScooterLoading());
      await scooterRepository.updateScooter(scooter);
      emit(ScooterSuccess(await scooterRepository.getScooters()));
    } catch (e) {
      emit(ScooterError('$e'));
    }
  }

  // delete
  Future<void> deleteScooter(int id) async {
    try {
      emit(ScooterLoading());
      await scooterRepository.deleteScooter(id);
      emit(ScooterSuccess(await scooterRepository.getScooters()));
    } catch (e) {
      emit(ScooterError('$e'));
    }
  }
}