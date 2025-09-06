import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/item.dart';


final itemProvider = StateNotifierProvider<itemNotifier, List<Item>>((ref) {
  return itemNotifier();
});

class itemNotifier extends StateNotifier<List<Item>> {
  itemNotifier() : super([]);
  int _id = 0;

  void addItem(String title) {
    final item = Item(title: title, id: _id);
    // ... old list(state), item(newitem)
    state = [...state, item];
    _id++;
  }

  void removeItem(int index) {
    final newlist = [...state]..removeAt(index);
    state = newlist;
  }

  void editItem(int index, String newTitle) {
    final newList = [...state];
    final oldItem = newList[index];
    newList[index] = Item(id: oldItem.id, title: newTitle);
    state = newList;
  }
}

final themechange = StateProvider<bool>((ref) => false);
