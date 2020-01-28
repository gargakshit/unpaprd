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

  final _$idxAtom = Atom(name: '_PlayerStore.idx');

  @override
  int get idx {
    _$idxAtom.context.enforceReadPolicy(_$idxAtom);
    _$idxAtom.reportObserved();
    return super.idx;
  }

  @override
  set idx(int value) {
    _$idxAtom.context.conditionallyRunInAction(() {
      super.idx = value;
      _$idxAtom.reportChanged();
    }, _$idxAtom, name: '${_$idxAtom.name}_set');
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

  final _$bgColorAtom = Atom(name: '_PlayerStore.bgColor');

  @override
  Color get bgColor {
    _$bgColorAtom.context.enforceReadPolicy(_$bgColorAtom);
    _$bgColorAtom.reportObserved();
    return super.bgColor;
  }

  @override
  set bgColor(Color value) {
    _$bgColorAtom.context.conditionallyRunInAction(() {
      super.bgColor = value;
      _$bgColorAtom.reportChanged();
    }, _$bgColorAtom, name: '${_$bgColorAtom.name}_set');
  }

  final _$accentColorAtom = Atom(name: '_PlayerStore.accentColor');

  @override
  Color get accentColor {
    _$accentColorAtom.context.enforceReadPolicy(_$accentColorAtom);
    _$accentColorAtom.reportObserved();
    return super.accentColor;
  }

  @override
  set accentColor(Color value) {
    _$accentColorAtom.context.conditionallyRunInAction(() {
      super.accentColor = value;
      _$accentColorAtom.reportChanged();
    }, _$accentColorAtom, name: '${_$accentColorAtom.name}_set');
  }

  final _$seekTimeAtom = Atom(name: '_PlayerStore.seekTime');

  @override
  int get seekTime {
    _$seekTimeAtom.context.enforceReadPolicy(_$seekTimeAtom);
    _$seekTimeAtom.reportObserved();
    return super.seekTime;
  }

  @override
  set seekTime(int value) {
    _$seekTimeAtom.context.conditionallyRunInAction(() {
      super.seekTime = value;
      _$seekTimeAtom.reportChanged();
    }, _$seekTimeAtom, name: '${_$seekTimeAtom.name}_set');
  }

  final _$persistColorsAsyncAction = AsyncAction('persistColors');

  @override
  Future<void> persistColors() {
    return _$persistColorsAsyncAction.run(() => super.persistColors());
  }

  final _$playAsyncAction = AsyncAction('play');

  @override
  Future<void> play(int i) {
    return _$playAsyncAction.run(() => super.play(i));
  }

  final _$persistSeekTimeAsyncAction = AsyncAction('persistSeekTime');

  @override
  Future<void> persistSeekTime() {
    return _$persistSeekTimeAsyncAction.run(() => super.persistSeekTime());
  }

  final _$_PlayerStoreActionController = ActionController(name: '_PlayerStore');

  @override
  void loadColors() {
    final _$actionInfo = _$_PlayerStoreActionController.startAction();
    try {
      return super.loadColors();
    } finally {
      _$_PlayerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void loadSeekTime() {
    final _$actionInfo = _$_PlayerStoreActionController.startAction();
    try {
      return super.loadSeekTime();
    } finally {
      _$_PlayerStoreActionController.endAction(_$actionInfo);
    }
  }
}
