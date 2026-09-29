part of "type_def.dart";

sealed class Option<T> {
  const Option();

  bool get isSome => this is Some<T>;

  bool get isNone => this is None<T>;

  T? get valueOrNull {
    final option = this;

    if (option is Some<T>) {
      return option.value;
    }

    return null;
  }

  R fold<R>({required Callback1<R, T> onSome, required Callback<R> onNone}) {
    final option = this;

    if (option is Some<T>) {
      return onSome(option.value);
    }

    return onNone();
  }

  Option<R> map<R>(Callback1<R, T> transform) {
    final option = this;

    if (option is Some<T>) {
      return Some(transform(option.value));
    }

    return const None();
  }

  T getOrElse(Callback<T> fallback) {
    final option = this;

    if (option is Some<T>) {
      return option.value;
    }

    return fallback();
  }
}

final class Some<T> extends Option<T> {
  final T value;

  const Some(this.value);
}

final class None<T> extends Option<T> {
  const None();
}

// ============================================================
// EXAMPLES
// ============================================================

// ------------------------------------------------------------
// Some
// ------------------------------------------------------------
//
// Option<String> name = Some('John');
//
// print(name.isSome);       // true
// print(name.isNone);       // false
// print(name.valueOrNull);  // John

// ------------------------------------------------------------
// None
// ------------------------------------------------------------
//
// Option<String> name = const None();
//
// print(name.isSome);       // false
// print(name.isNone);       // true
// print(name.valueOrNull);  // null

// ------------------------------------------------------------
// Find value
// ------------------------------------------------------------
//
// Option<User> findUser(int id) {
//   final user = users[id];
//
//   if (user == null) {
//     return const None();
//   }
//
//   return Some(user);
// }

// ------------------------------------------------------------
// Switch
// ------------------------------------------------------------
//
// final result = findUser(1);
//
// switch (result) {
//   case Some(:final value):
//     print(value.name);
//
//   case None():
//     print('User not found');
// }

// ------------------------------------------------------------
// Fold
// ------------------------------------------------------------
//
// final result = findUser(1);
//
// final message = result.fold(
//   onSome: (user) => 'User: ${user.name}',
//   onNone: () => 'User not found',
// );
//
// print(message);

// ------------------------------------------------------------
// Map
// ------------------------------------------------------------
//
// final user = findUser(1);
//
// final name = user.map((user) => user.name);
//
// print(name.valueOrNull);

// ------------------------------------------------------------
// Map chain
// ------------------------------------------------------------
//
// final name = findUser(1)
//     .map((user) => user.name)
//     .map((name) => name.toUpperCase());
//
// print(name.valueOrNull);

// ------------------------------------------------------------
// Get or else
// ------------------------------------------------------------
//
// final name = findUser(100)
//     .map((user) => user.name)
//     .getOrElse(() => 'Unknown');
//
// print(name); // Unknown
