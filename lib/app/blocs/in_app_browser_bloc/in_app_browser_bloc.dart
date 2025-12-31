import 'dart:math';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:uuid/uuid.dart';
part 'in_app_browser_event.dart';
part 'in_app_browser_state.dart';

class InAppBrowserBloc extends HydratedBloc<InAppBrowserEvent, InAppBrowserState> {
  InAppBrowserBloc() : super(InAppBrowserState(tabs: [], currentTabId: null)) {
    on<AddTabEvent>(_onAddTab);
    on<SwitchTabEvent>(_onSwitchTab);
    on<UpdateTabUrlEvent>(_onUpdateUrl);
    on<CloseTabEvent>(_onCloseTab);
  }

  void _onAddTab(AddTabEvent event, Emitter<InAppBrowserState> emit) {
    final id = const Uuid().v4();
    final newTab = BrowserTab(id: id, url: event.url);
    emit(state.copyWith(
      tabs: [...state.tabs, newTab],
      currentTabId: id,
    ));
  }

  void _onSwitchTab(SwitchTabEvent event, Emitter<InAppBrowserState> emit) {
    emit(state.copyWith(currentTabId: event.tabId));
  }

  void _onUpdateUrl(UpdateTabUrlEvent event, Emitter<InAppBrowserState> emit) {
    final updatedTabs = state.tabs.map((tab) {
      if (tab.id == event.tabId) {
        return tab.copyWith(url: event.url);
      }
      return tab;
    }).toList();
    emit(state.copyWith(tabs: updatedTabs));
  }

  void _onCloseTab(CloseTabEvent event, Emitter<InAppBrowserState> emit) {
    final updatedTabs = state.tabs.where((t) => t.id != event.tabId).toList();
    final newCurrentId = updatedTabs.isEmpty
        ? null
        : (state.currentTabId == event.tabId ? updatedTabs.last.id : state.currentTabId);
    emit(state.copyWith(tabs: updatedTabs, currentTabId: newCurrentId));
  }

  @override
  InAppBrowserState? fromJson(Map<String, dynamic> json) {
    return InAppBrowserState.fromMap(json);
  }

  @override
  Map<String, dynamic>? toJson(InAppBrowserState state) {
    return state.toMap();
  }
}
