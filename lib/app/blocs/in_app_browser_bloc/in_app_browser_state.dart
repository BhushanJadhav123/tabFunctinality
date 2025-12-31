part of 'in_app_browser_bloc.dart';

class BrowserTab {
  final String id;
  final String url;

  BrowserTab({required this.id, required this.url});

  BrowserTab copyWith({String? url}) => BrowserTab(id: id, url: url ?? this.url);

  Map<String, dynamic> toMap() => {'id': id, 'url': url};
  factory BrowserTab.fromMap(Map<String, dynamic> map) => BrowserTab(id: map['id'], url: map['url']);
}

class InAppBrowserState {
  final List<BrowserTab> tabs;
  final String? currentTabId;

  InAppBrowserState({required this.tabs, required this.currentTabId});

  InAppBrowserState copyWith({List<BrowserTab>? tabs, String? currentTabId}) =>
      InAppBrowserState(
        tabs: tabs ?? this.tabs,
        currentTabId: currentTabId ?? this.currentTabId,
      );

  Map<String, dynamic> toMap() => {
    'tabs': tabs.map((e) => e.toMap()).toList(),
    'currentTabId': currentTabId,
  };

  factory InAppBrowserState.fromMap(Map<String, dynamic> map) => InAppBrowserState(
    tabs: List<BrowserTab>.from(map['tabs']?.map((x) => BrowserTab.fromMap(x))),
    currentTabId: map['currentTabId'],
  );
}
