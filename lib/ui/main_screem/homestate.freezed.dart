// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'homestate.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Homestate {
  int get selectedIndex => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HomestateCopyWith<Homestate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomestateCopyWith<$Res> {
  factory $HomestateCopyWith(Homestate value, $Res Function(Homestate) then) =
      _$HomestateCopyWithImpl<$Res, Homestate>;
  @useResult
  $Res call({int selectedIndex});
}

/// @nodoc
class _$HomestateCopyWithImpl<$Res, $Val extends Homestate>
    implements $HomestateCopyWith<$Res> {
  _$HomestateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIndex = null,
  }) {
    return _then(_value.copyWith(
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomestateImplCopyWith<$Res>
    implements $HomestateCopyWith<$Res> {
  factory _$$HomestateImplCopyWith(
          _$HomestateImpl value, $Res Function(_$HomestateImpl) then) =
      __$$HomestateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int selectedIndex});
}

/// @nodoc
class __$$HomestateImplCopyWithImpl<$Res>
    extends _$HomestateCopyWithImpl<$Res, _$HomestateImpl>
    implements _$$HomestateImplCopyWith<$Res> {
  __$$HomestateImplCopyWithImpl(
      _$HomestateImpl _value, $Res Function(_$HomestateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedIndex = null,
  }) {
    return _then(_$HomestateImpl(
      selectedIndex: null == selectedIndex
          ? _value.selectedIndex
          : selectedIndex // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$HomestateImpl implements _Homestate {
  const _$HomestateImpl({this.selectedIndex = 1});

  @override
  @JsonKey()
  final int selectedIndex;

  @override
  String toString() {
    return 'Homestate(selectedIndex: $selectedIndex)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomestateImpl &&
            (identical(other.selectedIndex, selectedIndex) ||
                other.selectedIndex == selectedIndex));
  }

  @override
  int get hashCode => Object.hash(runtimeType, selectedIndex);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HomestateImplCopyWith<_$HomestateImpl> get copyWith =>
      __$$HomestateImplCopyWithImpl<_$HomestateImpl>(this, _$identity);
}

abstract class _Homestate implements Homestate {
  const factory _Homestate({final int selectedIndex}) = _$HomestateImpl;

  @override
  int get selectedIndex;
  @override
  @JsonKey(ignore: true)
  _$$HomestateImplCopyWith<_$HomestateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
