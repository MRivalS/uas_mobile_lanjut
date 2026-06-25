import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/api_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final ApiRepository _repository;

  HomeCubit(this._repository) : super(HomeInitial());

  Future<void> loadPublicApis() async {
    emit(HomeLoading());
    try {
      final entries = await _repository.fetchEntries();
      emit(HomeSuccess(entries));
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }
}
