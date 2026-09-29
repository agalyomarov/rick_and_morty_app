import 'dart:developer';

part 'result.dart';
part 'option.dart';

// ============================================================
// JSON
// ============================================================

typedef Json = Map<String, dynamic>;

typedef JsonOf<T> = Map<String, T>;

// ============================================================
// LIST
// ============================================================

typedef ListInt = List<int>;

typedef ListString = List<String>;

typedef ListJson = List<Json>;

typedef ListJsonOf<T> = List<JsonOf<T>>;

typedef ListDynamic = List<dynamic>;

// ============================================================
// MAP
// ============================================================

typedef JsonString = Map<String, String>;

typedef JsonInt = Map<String, int>;

typedef JsonBool = Map<String, bool>;

typedef JsonDouble = Map<String, double>;

// ============================================================
// FUTURE
// ============================================================

typedef FutureVoid = Future<void>;

typedef FutureString = Future<String>;

typedef FutureInt = Future<int>;

typedef FutureBool = Future<bool>;

typedef FutureList<T> = Future<List<T>>;

typedef FutureMap<T> = Future<Map<String, T>>;

typedef FutureJson = Future<Json>;

typedef FutureJsonOf<T> = Future<JsonOf<T>>;

// ============================================================
// STREAM
// ============================================================

typedef StreamList<T> = Stream<List<T>>;

typedef StreamMap<T> = Stream<Map<String, T>>;

typedef StreamJson = Stream<Json>;

// ============================================================
// CALLBACK VOID
// ============================================================

typedef CallbackVoid = void Function();

typedef CallbackVoid1<P> = void Function(P val);

typedef CallbackVoid2<P1, P2> = void Function(P1 val1, P2 val2);

typedef CallbackVoid3<P1, P2, P3> = void Function(P1 val1, P2 val2, P3 val3);

// ============================================================
// FUTURE CALLBACK VOID
// ============================================================

typedef FutureCallbackVoid = Future<void> Function();

typedef FutureCallbackVoid1<P> = Future<void> Function(P val);

typedef FutureCallbackVoid2<P1, P2> = Future<void> Function(P1 val1, P2 val2);

typedef FutureCallbackVoid3<P1, P2, P3> = Future<void> Function(P1 val1, P2 val2, P3 val3);

// ============================================================
// CALLBACK<R>
// ============================================================

typedef Callback<R> = R Function();

typedef Callback1<R, P1> = R Function(P1 val);

typedef Callback2<R, P1, P2> = R Function(P1 val1, P2 val2);

typedef Callback3<R, P1, P2, P3> = R Function(P1 val1, P2 val2, P3 val3);

// ============================================================
// FUTURE CALLBACK<R>
// ============================================================

typedef FutureCallback<R> = Future<R> Function();

typedef FutureCallback1<R, P1> = Future<R> Function(P1 val);

typedef FutureCallback2<R, P1, P2> = Future<R> Function(P1 val1, P2 val2);

typedef FutureCallback3<R, P1, P2, P3> = Future<R> Function(P1 val1, P2 val2, P3 val3);

// Примеры использования

// Callback без параметров:
// ignore: unused_element
CallbackVoid _onPressed = () {
  log('Pressed');
};

// Callback с параметром:
// ignore: unused_element
CallbackVoid1<String> _onNameChanged = (name) {
  log(name);
};

// Callback с двумя параметрами:
// ignore: unused_element
CallbackVoid2<String, int> _onUserChanged = (name, age) {
  log('$name: $age');
};

// Callback с возвращаемым значением:
// ignore: unused_element
Callback<String> _getName = () {
  return 'John';
};

// Callback с параметром и возвращаемым значением:
// ignore: unused_element
Callback1<String, int> _getUserName = (id) {
  return 'User $id';
};
// Здесь:
// Callback1<String, int>
// означает:
// R = String
// P1 = int
// то есть:
// String Function(int)

// Callback с двумя параметрами:
// ignore: unused_element
Callback2<bool, String, int> checkUser = (name, age) {
  return age >= 18;
};

// Это:
// bool Function(String, int)

// Future callback:
// ignore: unused_element
FutureCallback1<String, int> _loadApp = (id) async {
  return "Hello World";
};

// Это:
// Future<User> Function(int)
// Future<void> callback:
// ignore: unused_element
FutureCallbackVoid1<int> _deleteRecord = (id) async {
  //
};

// Несколько параметров + Future:
// ignore: unused_element
FutureCallback2<bool, String, int> loadUser = (name, age) async {
  return true;
};
// Это:
// Future<bool> Function(String, int)
