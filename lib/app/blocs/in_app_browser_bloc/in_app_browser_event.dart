part of 'in_app_browser_bloc.dart';

abstract class InAppBrowserEvent {}

class AddTabEvent extends InAppBrowserEvent {
  final String url;
  AddTabEvent(this.url);
}

class CloseTabEvent extends InAppBrowserEvent {
  final String tabId;
  CloseTabEvent(this.tabId);
}

class SwitchTabEvent extends InAppBrowserEvent {
  final String tabId;
  SwitchTabEvent(this.tabId);
}

class UpdateTabUrlEvent extends InAppBrowserEvent {
  final String tabId;
  final String url;
  UpdateTabUrlEvent({required this.tabId, required this.url});
}
