import 'package:mobx/mobx.dart';
import 'package:unpaprd/api/book.dart';
import 'package:unpaprd/models/audiobook_full.dart';

part 'playerState.g.dart';

class PlayerStore = _PlayerStore with _$PlayerStore;

abstract class _PlayerStore with Store {
  @observable
  int id = 0;

  @observable
  int idx = 0;

  @observable
  AudiobookFull book;

  @observable
  bool loading = false;

  @action
  Future<void> play(int i) async {
    id = i;
    loading = true;
    book = await fetchBook(i);
    loading = false;
  }
}
