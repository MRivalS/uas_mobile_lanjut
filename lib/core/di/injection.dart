import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import '../config/env_config.dart';
import '../../features/home/data/repositories/api_repository.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<Dio>(() {
    final dio = Dio(BaseOptions(baseUrl: EnvConfig.baseUrl));
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });

  locator.registerLazySingleton<ApiRepository>(
    () => ApiRepository(locator<Dio>()),
  );

  locator.registerFactory<HomeCubit>(() => HomeCubit(locator<ApiRepository>()));
}
