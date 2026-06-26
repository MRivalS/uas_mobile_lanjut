import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../database/isar_service.dart';
import '../../features/home/data/repositories/api_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  // 1. Core Network (Dio) - Cukup Daftarkan 1 Kali
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  // 2. Core Local Database (IsarService) - Daftarkan 1 Kali
  locator.registerLazySingleton<IsarService>(() => IsarService());

  // 3. Repositories - Suntikkan Dio dan IsarService secara bersamaan
  locator.registerLazySingleton<ApiRepository>(
    () => ApiRepository(locator<Dio>(), locator<IsarService>()),
  );

  // 4. Cubit / BLoC - Menggunakan registerFactory agar state selalu segar tiap halaman dibuka
  locator.registerFactory<HomeCubit>(() => HomeCubit(locator<ApiRepository>()));
}
