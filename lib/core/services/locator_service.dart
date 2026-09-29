import 'package:get_it/get_it.dart';
import 'package:rick_and_morty_app/services/characters_service.dart';

final sl = GetIt.instance;

void init() {
  // singleton
  sl.registerLazySingleton(() => CharactersService());

  sl.registerSingleton<Param1>(Param1(0));

  // factory
  sl.registerFactory(() => SlFactory1(sl()));
  sl.registerFactory(() => SlFactory2(sl()));

  // lazy singleton
  sl.registerLazySingleton(() => SlLazySingleton1(sl()));
  sl.registerLazySingleton(() => SlLazySingleton2(sl()));

  sl.registerLazySingleton<SlLazySingleton3>(() => SlLazySingleton3Impl(sl()));
}

class Param1 {
  int counter;
  Param1(this.counter);
}

class SlFactory1 {
  final Param1 param1;
  SlFactory1(this.param1);
}

class SlFactory2 {
  final Param1 param1;
  SlFactory2(this.param1);
}

class SlLazySingleton1 {
  final String param1;
  SlLazySingleton1(this.param1);
}

class SlLazySingleton2 {
  final String param1;
  SlLazySingleton2(this.param1);
}

abstract class SlLazySingleton3 {
  final Param1 param1;
  SlLazySingleton3(this.param1);
}

class SlLazySingleton3Impl extends SlLazySingleton3 {
  SlLazySingleton3Impl(super.param1);
}
