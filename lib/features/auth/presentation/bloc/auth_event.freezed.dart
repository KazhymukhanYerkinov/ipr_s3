// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$AuthEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function() authCheckRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function()? authCheckRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function()? authCheckRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthCheckRequested value) authCheckRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthCheckRequested value)? authCheckRequested,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthCheckRequested value)? authCheckRequested,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthEventCopyWith<$Res> {
  factory $AuthEventCopyWith(AuthEvent value, $Res Function(AuthEvent) then) =
      _$AuthEventCopyWithImpl<$Res, AuthEvent>;
}

/// @nodoc
class _$AuthEventCopyWithImpl<$Res, $Val extends AuthEvent>
    implements $AuthEventCopyWith<$Res> {
  _$AuthEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$GoogleSignInRequestedImplCopyWith<$Res> {
  factory _$$GoogleSignInRequestedImplCopyWith(
          _$GoogleSignInRequestedImpl value,
          $Res Function(_$GoogleSignInRequestedImpl) then) =
      __$$GoogleSignInRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$GoogleSignInRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$GoogleSignInRequestedImpl>
    implements _$$GoogleSignInRequestedImplCopyWith<$Res> {
  __$$GoogleSignInRequestedImplCopyWithImpl(_$GoogleSignInRequestedImpl _value,
      $Res Function(_$GoogleSignInRequestedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$GoogleSignInRequestedImpl implements GoogleSignInRequested {
  const _$GoogleSignInRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.googleSignInRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GoogleSignInRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function() authCheckRequested,
  }) {
    return googleSignInRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function()? authCheckRequested,
  }) {
    return googleSignInRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function()? authCheckRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthCheckRequested value) authCheckRequested,
  }) {
    return googleSignInRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthCheckRequested value)? authCheckRequested,
  }) {
    return googleSignInRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthCheckRequested value)? authCheckRequested,
    required TResult orElse(),
  }) {
    if (googleSignInRequested != null) {
      return googleSignInRequested(this);
    }
    return orElse();
  }
}

abstract class GoogleSignInRequested implements AuthEvent {
  const factory GoogleSignInRequested() = _$GoogleSignInRequestedImpl;
}

/// @nodoc
abstract class _$$SignOutRequestedImplCopyWith<$Res> {
  factory _$$SignOutRequestedImplCopyWith(_$SignOutRequestedImpl value,
          $Res Function(_$SignOutRequestedImpl) then) =
      __$$SignOutRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SignOutRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$SignOutRequestedImpl>
    implements _$$SignOutRequestedImplCopyWith<$Res> {
  __$$SignOutRequestedImplCopyWithImpl(_$SignOutRequestedImpl _value,
      $Res Function(_$SignOutRequestedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$SignOutRequestedImpl implements SignOutRequested {
  const _$SignOutRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.signOutRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SignOutRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function() authCheckRequested,
  }) {
    return signOutRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function()? authCheckRequested,
  }) {
    return signOutRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function()? authCheckRequested,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthCheckRequested value) authCheckRequested,
  }) {
    return signOutRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthCheckRequested value)? authCheckRequested,
  }) {
    return signOutRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthCheckRequested value)? authCheckRequested,
    required TResult orElse(),
  }) {
    if (signOutRequested != null) {
      return signOutRequested(this);
    }
    return orElse();
  }
}

abstract class SignOutRequested implements AuthEvent {
  const factory SignOutRequested() = _$SignOutRequestedImpl;
}

/// @nodoc
abstract class _$$AuthCheckRequestedImplCopyWith<$Res> {
  factory _$$AuthCheckRequestedImplCopyWith(_$AuthCheckRequestedImpl value,
          $Res Function(_$AuthCheckRequestedImpl) then) =
      __$$AuthCheckRequestedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$AuthCheckRequestedImplCopyWithImpl<$Res>
    extends _$AuthEventCopyWithImpl<$Res, _$AuthCheckRequestedImpl>
    implements _$$AuthCheckRequestedImplCopyWith<$Res> {
  __$$AuthCheckRequestedImplCopyWithImpl(_$AuthCheckRequestedImpl _value,
      $Res Function(_$AuthCheckRequestedImpl) _then)
      : super(_value, _then);
}

/// @nodoc

class _$AuthCheckRequestedImpl implements AuthCheckRequested {
  const _$AuthCheckRequestedImpl();

  @override
  String toString() {
    return 'AuthEvent.authCheckRequested()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$AuthCheckRequestedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() googleSignInRequested,
    required TResult Function() signOutRequested,
    required TResult Function() authCheckRequested,
  }) {
    return authCheckRequested();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? googleSignInRequested,
    TResult? Function()? signOutRequested,
    TResult? Function()? authCheckRequested,
  }) {
    return authCheckRequested?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? googleSignInRequested,
    TResult Function()? signOutRequested,
    TResult Function()? authCheckRequested,
    required TResult orElse(),
  }) {
    if (authCheckRequested != null) {
      return authCheckRequested();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(GoogleSignInRequested value)
        googleSignInRequested,
    required TResult Function(SignOutRequested value) signOutRequested,
    required TResult Function(AuthCheckRequested value) authCheckRequested,
  }) {
    return authCheckRequested(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult? Function(SignOutRequested value)? signOutRequested,
    TResult? Function(AuthCheckRequested value)? authCheckRequested,
  }) {
    return authCheckRequested?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(GoogleSignInRequested value)? googleSignInRequested,
    TResult Function(SignOutRequested value)? signOutRequested,
    TResult Function(AuthCheckRequested value)? authCheckRequested,
    required TResult orElse(),
  }) {
    if (authCheckRequested != null) {
      return authCheckRequested(this);
    }
    return orElse();
  }
}

abstract class AuthCheckRequested implements AuthEvent {
  const factory AuthCheckRequested() = _$AuthCheckRequestedImpl;
}
