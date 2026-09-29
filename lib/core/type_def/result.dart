part of "type_def.dart";

sealed class Result<T, E> {
  const Result();

  bool get isOk => this is Ok<T, E>;

  bool get isErr => this is Err<T, E>;

  T? get valueOrNull {
    final result = this;

    if (result is Ok<T, E>) {
      return result.value;
    }

    return null;
  }

  E? get errorOrNull {
    final result = this;

    if (result is Err<T, E>) {
      return result.error;
    }

    return null;
  }

  // ----------------------------------------------------------
  // FOLD
  // ----------------------------------------------------------

  R fold<R>({required Callback1<R, T> onOk, required Callback1<R, E> onErr}) {
    final result = this;

    if (result is Ok<T, E>) {
      return onOk(result.value);
    }

    if (result is Err<T, E>) {
      return onErr(result.error);
    }

    throw StateError('Unknown Result type');
  }
}

// ============================================================
// OK
// ============================================================

final class Ok<T, E> extends Result<T, E> {
  final T value;

  const Ok(this.value);
}

// ============================================================
// ERR
// ============================================================

final class Err<T, E> extends Result<T, E> {
  final E error;

  final StackTrace? stackTrace;

  const Err(this.error, {this.stackTrace});
}

// ============================================================
// EXAMPLES
// ============================================================

// ------------------------------------------------------------
// Ok
// ------------------------------------------------------------
//
// Result<int, String> result = const Ok(100);
//
// print(result.isOk);        // true
// print(result.isErr);       // false
// print(result.valueOrNull); // 100
// print(result.errorOrNull); // null

// ------------------------------------------------------------
// Err
// ------------------------------------------------------------
//
// Result<int, String> result = const Err('Something went wrong');
//
// print(result.isOk);        // false
// print(result.isErr);       // true
// print(result.valueOrNull); // null
// print(result.errorOrNull); // Something went wrong

// ------------------------------------------------------------
// Explicit generic types
// ------------------------------------------------------------
//
// final Result<int, String> result = Ok<int, String>(100);
//
// final Result<int, String> result = Err<int, String>(
//   'Something went wrong',
// );

// ------------------------------------------------------------
// Switch
// ------------------------------------------------------------
//
// final Result<int, String> result = const Ok(100);
//
// switch (result) {
//   case Ok(:final value):
//     print('Success: $value');
//
//   case Err(:final error):
//     print('Error: $error');
// }

// ------------------------------------------------------------
// Fold
// ------------------------------------------------------------
//
// final Result<int, String> result = const Ok(100);
//
// final message = result.fold(
//   onOk: (value) => 'Value: $value',
//   onErr: (error) => 'Error: $error',
// );
//
// print(message); // Value: 100

// ------------------------------------------------------------
// Fold with different return type
// ------------------------------------------------------------
//
// final Result<User, ApiException> result = getUser();
//
// final name = result.fold(
//   onOk: (user) => user.name,
//   onErr: (error) => 'Unknown',
// );
//
// print(name);

// ------------------------------------------------------------
// API example
// ------------------------------------------------------------
//
// Future<Result<User, ApiException>> getUser() async {
//   try {
//     final user = await repository.getUser();
//
//     return Ok(user);
//   } catch (e, stackTrace) {
//     return Err(
//       ApiException(e.toString()),
//       stackTrace: stackTrace,
//     );
//   }
// }

// ------------------------------------------------------------
// Using API result
// ------------------------------------------------------------
//
// final result = await getUser();
//
// switch (result) {
//   case Ok(:final value):
//     print('User: ${value.name}');
//
//   case Err(:final error):
//     print('Error: $error');
// }

// ------------------------------------------------------------
// Check result
// ------------------------------------------------------------
//
// final result = await getUser();
//
// if (result.isOk) {
//   print(result.valueOrNull);
// }
//
// if (result.isErr) {
//   print(result.errorOrNull);
// }

// ------------------------------------------------------------
// StackTrace
// ------------------------------------------------------------
//
// final result = Err<String, Exception>(
//   Exception('Request failed'),
//   stackTrace: StackTrace.current,
// );
//
// print(result.errorOrNull);
// print(result.stackTrace);
// ```
