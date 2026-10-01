// import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rick_and_morty_app/bloc/character_bloc/character_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_bloc.dart';
import 'package:rick_and_morty_app/bloc/character_detail_bloc/character_detail_event.dart';
import 'package:rick_and_morty_app/bloc/search_bloc/search_bloc.dart';
import 'package:rick_and_morty_app/core/services/locator_service.dart';
import 'package:rick_and_morty_app/pages/home_page.dart';
import 'package:rick_and_morty_app/pages/search_page.dart';
import 'package:rick_and_morty_app/pages/character_page.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    minimumSize: Size(800, 600),
    size: Size(800, 600),
    center: true,
    // backgroundColor: Colors.transparent,
    // skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
    windowButtonVisibility: true,
  );

  init();
  runApp(MyApp());

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  /*   print(sl<SlFactory1>().param1.counter++);
  print(sl<SlFactory1>().param1.counter++);
  print(sl<SlFactory2>().param1.counter++);
  print(sl.getAll()); */
  // testCallback(sl());
}

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: "/",
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
      routes: <RouteBase>[
        GoRoute(
          path: "/character/:id",
          builder: (BuildContext context, GoRouterState state) {
            final id = state.pathParameters['id']!;
            return BlocProvider(
              create: (_) => CharacterDetailBloc()..add(CharacterDetailLoadEvent(id: id)),
              child: CharacterPage(id: id),
            );
          },
        ),
        GoRoute(
          path: "/search",
          builder: (BuildContext context, GoRouterState state) {
            return BlocProvider(create: (_) => SearchBloc(), child: SearchPage());
          },
        ),
      ],
    ),
  ],
);

// void testCallback(SlLazySingleton3 test) {
//   // print(test);
// }

class MyApp extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider<CharacterBloc>(create: (context) => CharacterBloc())],
      child: MaterialApp.router(
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
        title: "The Rick and Morty app",
      ),
    );
  }
}
