A Chrome-like in-app browser built using Flutter with multi-tab support, session persistence, and manual URL navigation.


✨ Features

✅ Multiple Tabs (TopTabBar)
Tabs are displayed at the top (Chrome-style)
Add, close, and switch tabs dynamically

✅ Session Persistence (HydratedBloc)
All open tabs are restored automatically after app restart or kill
Current active tab is also restored

✅ Manual URL Entry
User can enter URLs manually via the address bar
Automatically normalizes URLs (https:// added if missing)

✅ Browser Controls
Back
Forward
Reload

✅ Per-Tab WebView State
Each tab maintains its own browsing state
WebView is recreated correctly on tab switch



🛠 Tech Stack
Flutter
flutter_inappwebview
flutter_bloc
hydrated_bloc
path_provider