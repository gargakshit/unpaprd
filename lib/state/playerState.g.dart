// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'playerState.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$PlayerStore on _PlayerStore, Store {
  final _$idAtom = Atom(name: '_PlayerStore.id');

  @override
  int get id {
    _$idAtom.context.enforceReadPolicy(_$idAtom);
    _$idAtom.reportObserved();
    return super.id;
  }

  @override
  set id(int value) {
    _$idAtom.context.conditionallyRunInAction(() {
      super.id = value;
      _$idAtom.reportChanged();
    }, _$idAtom, name: '${_$idAtom.name}_set');
  }

  final _$bookAtom = Atom(name: '_PlayerStore.book');

  @override
  AudiobookFull get book {
    _$bookAtom.context.enforceReadPolicy(_$bookAtom);
    _$bookAtom.reportObserved();
    return super.book;
  }

  @override
  set book(AudiobookFull value) {
    _$bookAtom.context.conditionallyRunInAction(() {
      super.book = value;
      _$bookAtom.reportChanged();
    }, _$bookAtom, name: '${_$bookAtom.name}_set');
  }

  final _$loadingAtom = Atom(name: '_PlayerStore.loading');

  @override
  bool get loading {
    _$loadingAtom.context.enforceReadPolicy(_$loadingAtom);
    _$loadingAtom.reportObserved();
    return super.loading;
  }

  @override
  set loading(bool value) {
    _$loadingAtom.context.conditionallyRunInAction(() {
      super.loading = value;
      _$loadingAtom.reportChanged();
    }, _$loadingAtom, name: '${_$loadingAtom.name}_set');
  }

  final _$playAsyncAction = AsyncAction('play');

  @override
  Future<void> play(int i) {
    return _$playAsyncAction.run(() => super.play(i));
  }
}
