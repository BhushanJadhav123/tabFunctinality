// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:open_file/open_file.dart';
//
// import '../blocs/in_app_browser_bloc/in_app_browser_bloc.dart';
// import 'tab_switcher.dart';
//
// class InAppBrowserScreen extends StatefulWidget {
//   const InAppBrowserScreen({super.key});
//
//   @override
//   State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
// }
//
// class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
//   final Map<String, InAppWebViewController> _controllers = {};
//   final TextEditingController _urlController = TextEditingController();
//
//   String normalizeUrl(String url) {
//     if (!url.startsWith("http")) return "https://$url";
//     return url;
//   }
//
//   Future<void> downloadFile(String url) async {
//     final status = await Permission.storage.request();
//     if (!status.isGranted) return;
//
//     final dir = await getApplicationDocumentsDirectory();
//     final fileName = url.split("/").last;
//     final file = File("${dir.path}/$fileName");
//
//     final request = await HttpClient().getUrl(Uri.parse(url));
//     final response = await request.close();
//     final bytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));
//
//     await file.writeAsBytes(bytes);
//
//     // Show SnackBar without relying on WebView context
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text("Download Complete: $fileName"),
//         duration: const Duration(seconds: 3),
//       ),
//     );
//
//     // Show a temporary overlay button to open file
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text("Download Complete"),
//         content: Text(fileName),
//         actions: [
//           TextButton(
//             onPressed: () {
//               OpenFile.open(file.path);
//               Navigator.of(context).pop();
//             },
//             child: const Text("Open"),
//           ),
//           TextButton(
//             onPressed: () => Navigator.of(context).pop(),
//             child: const Text("Close"),
//           ),
//         ],
//       ),
//     );
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<InAppBrowserBloc, InAppBrowserState>(
//       builder: (context, state) {
//         if (state.currentTabId == null || state.tabs.isEmpty) {
//           return Scaffold(
//             appBar: AppBar(title: const Text("Browser")),
//             body: Center(
//               child: ElevatedButton(
//                 onPressed: () {
//                   context
//                       .read<InAppBrowserBloc>()
//                       .add(AddTabEvent("https://flutter.dev"));
//                 },
//                 child: const Text("Open Browser"),
//               ),
//             ),
//           );
//         }
//
//         final currentTab =
//         state.tabs.firstWhere((tab) => tab.id == state.currentTabId);
//
//         _urlController.text = currentTab.url;
//
//         return Scaffold(
//           appBar: AppBar(
//             titleSpacing: 0,
//             title: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8),
//               child: TextField(
//                 controller: _urlController,
//                 textInputAction: TextInputAction.go,
//                 decoration: const InputDecoration(
//                   hintText: "Enter URL",
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(borderSide: BorderSide.none),
//                 ),
//                 onSubmitted: (value) {
//                   final url = normalizeUrl(value);
//                   _controllers[currentTab.id]?.loadUrl(
//                     urlRequest: URLRequest(url: WebUri(url)),
//                   );
//                   context.read<InAppBrowserBloc>().add(
//                       UpdateTabUrlEvent(tabId: currentTab.id, url: url));
//                 },
//               ),
//             ),
//             actions: [
//               IconButton(
//                   icon: const Icon(Icons.add),
//                   onPressed: () {
//                     context
//                         .read<InAppBrowserBloc>()
//                         .add(AddTabEvent("https://google.com"));
//                   }),
//               IconButton(
//                   icon: const Icon(Icons.refresh),
//                   onPressed: () => _controllers[currentTab.id]?.reload()),
//               IconButton(
//                   icon: const Icon(Icons.arrow_back),
//                   onPressed: () async {
//                     if (await _controllers[currentTab.id]?.canGoBack() ?? false) {
//                       _controllers[currentTab.id]?.goBack();
//                     }
//                   }),
//               IconButton(
//                   icon: const Icon(Icons.arrow_forward),
//                   onPressed: () async {
//                     if (await _controllers[currentTab.id]?.canGoForward() ??
//                         false) {
//                       _controllers[currentTab.id]?.goForward();
//                     }
//                   }),
//               IconButton(
//                 icon: const Icon(Icons.download),
//                 onPressed: () async {
//                   // User manually enter kare direct file URL
//                   final url = _urlController.text.trim();
//                   if (url.endsWith(".pdf") || url.endsWith(".docx")) {
//                     await downloadFile(url);
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Download Complete")),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("Enter direct PDF/DOCX URL")),
//                     );
//                   }
//                 },
//               ),
//
//             ],
//           ),
//           body: Column(
//             children: [
//               // 🔥 TOP TABS
//               TopTabBar(
//                 state: state,
//                 onAddTab: () {
//                   context
//                       .read<InAppBrowserBloc>()
//                       .add(AddTabEvent("https://google.com"));
//                 },
//                 onTabSelect: (id) {
//                   context.read<InAppBrowserBloc>().add(SwitchTabEvent(id));
//                 },
//                 onCloseTab: (id) {
//                   context.read<InAppBrowserBloc>().add(CloseTabEvent(id));
//                 },
//               ),
//
//               // 🔥 WEBVIEW
//               Expanded(
//                 child: InAppWebView(
//                   key: ValueKey(currentTab.id),
//                   initialUrlRequest: URLRequest(url: WebUri(currentTab.url)),
//                   onWebViewCreated: (controller) {
//                     _controllers[currentTab.id] = controller;
//                   },
//                   onLoadStop: (controller, url) {
//                     if (url != null) {
//                       context.read<InAppBrowserBloc>().add(
//                           UpdateTabUrlEvent(tabId: currentTab.id, url: url.toString()));
//                     }
//                   },
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

import '../blocs/in_app_browser_bloc/in_app_browser_bloc.dart';
import 'tab_switcher.dart';

class InAppBrowserScreen extends StatefulWidget {
  const InAppBrowserScreen({super.key});

  @override
  State<InAppBrowserScreen> createState() => _InAppBrowserScreenState();
}

class _InAppBrowserScreenState extends State<InAppBrowserScreen> {
  final Map<String, InAppWebViewController> _controllers = {};
  final TextEditingController _urlController = TextEditingController();

  String normalizeUrl(String url) {
    if (!url.startsWith("http")) return "https://$url";
    return url;
  }

  Future<void> downloadFile(String url) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return;

    final dir = await getApplicationDocumentsDirectory();
    final fileName = url.split("/").last;
    final file = File("${dir.path}/$fileName");

    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await response.fold<List<int>>([], (a, b) => a..addAll(b));

    await file.writeAsBytes(bytes);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Download Complete"),
        content: Text(fileName),
        actions: [
          TextButton(
            onPressed: () {
              OpenFile.open(file.path);
              Navigator.of(context).pop();
            },
            child: const Text("Open"),
          ),
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text("Close")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InAppBrowserBloc, InAppBrowserState>(
      builder: (context, state) {
        if (state.currentTabId == null || state.tabs.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text("Browser")),
            body: Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<InAppBrowserBloc>().add(AddTabEvent("https://flutter.dev"));
                },
                child: const Text("Open Browser"),
              ),
            ),
          );
        }

        final currentTab = state.tabs.firstWhere((tab) => tab.id == state.currentTabId);
        _urlController.text = currentTab.url;

        return Scaffold(
          appBar: AppBar(
            titleSpacing: 0,
            title: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _urlController,
                textInputAction: TextInputAction.go,
                decoration: const InputDecoration(
                  hintText: "Enter URL",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                ),
                onSubmitted: (value) {
                  final url = normalizeUrl(value);
                  _controllers[currentTab.id]?.loadUrl(urlRequest: URLRequest(url: WebUri(url)));
                  context.read<InAppBrowserBloc>().add(UpdateTabUrlEvent(tabId: currentTab.id, url: url));
                },
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  context.read<InAppBrowserBloc>().add(AddTabEvent("https://google.com"));
                },
              ),
              IconButton(icon: const Icon(Icons.refresh), onPressed: () => _controllers[currentTab.id]?.reload()),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () async {
                  if (await _controllers[currentTab.id]?.canGoBack() ?? false) {
                    _controllers[currentTab.id]?.goBack();
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () async {
                  if (await _controllers[currentTab.id]?.canGoForward() ?? false) {
                    _controllers[currentTab.id]?.goForward();
                  }
                },
              ),
              // IconButton(
              //   icon: const Icon(Icons.download),
              //   onPressed: () async {
              //     final url = _urlController.text.trim();
              //     if (url.endsWith(".pdf") || url.endsWith(".docx")) {
              //       await downloadFile(url);
              //     } else {
              //       ScaffoldMessenger.of(context).showSnackBar(
              //         const SnackBar(
              //             content: Text("Enter direct PDF/DOCX URL")),
              //       );
              //     }
              //   },
              // ),
            ],
          ),
          body: Column(
            children: [
              // TOP TABS
              topTabBar(state),

              // WEBVIEW STACK
              webViewStack(state)
            ],
          ),
        );
      },
    );
  }
  Widget topTabBar(InAppBrowserState state){
    return  TopTabBar(
      state: state,
      onAddTab: () {
        context.read<InAppBrowserBloc>().add(AddTabEvent("https://google.com"));
      },
      onTabSelect: (id) {
        context.read<InAppBrowserBloc>().add(SwitchTabEvent(id));
        final tab = state.tabs.firstWhere((t) => t.id == id, orElse: () => state.tabs.first);
        final controller = _controllers[tab.id];
        controller?.loadUrl(urlRequest: URLRequest(url: WebUri(tab.url)));
      },
      onCloseTab: (id) {
        context.read<InAppBrowserBloc>().add(CloseTabEvent(id));
      },
    );
  }

  Widget webViewStack(InAppBrowserState state){
    return   Expanded(
      child: IndexedStack(
        index: state.tabs.indexWhere((t) => t.id == state.currentTabId),
        children: state.tabs.map((tab) {
          return InAppWebView(
            key: ValueKey(tab.id),
            initialUrlRequest: URLRequest(url: WebUri(tab.url)),
            onWebViewCreated: (controller) {
              _controllers[tab.id] = controller;
              if (tab.id == state.currentTabId) {
                controller.loadUrl(urlRequest: URLRequest(url: WebUri(tab.url)));
              }
            },
            onLoadStop: (controller, url) {
              if (url != null) {
                context.read<InAppBrowserBloc>().add(UpdateTabUrlEvent(tabId: tab.id, url: url.toString()));
              }
            },
          );
        }).toList(),
      ),
    );
  }
}
