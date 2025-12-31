import 'package:flutter/material.dart';
import '../blocs/in_app_browser_bloc/in_app_browser_bloc.dart';

class TopTabBar extends StatelessWidget {
  final InAppBrowserState state;
  final Function(String tabId) onTabSelect;
  final VoidCallback onAddTab;
  final Function(String tabId) onCloseTab;

  const TopTabBar({
    super.key,
    required this.state,
    required this.onTabSelect,
    required this.onAddTab,
    required this.onCloseTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Colors.grey.shade200,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ...state.tabs.map((tab) {
            final isActive = tab.id == state.currentTabId;

            return GestureDetector(
              onTap: () => onTabSelect(tab.id),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isActive ? Colors.white : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                  border: isActive
                      ? Border.all(color: Colors.blue, width: 2)
                      : null,
                ),
                child: Row(
                  children: [
                    Text(
                      tab.url.replaceFirst(RegExp(r'https?://'), ''),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 6),
                    GestureDetector(
                      onTap: () => onCloseTab(tab.id),
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ],
                ),
              ),
            );
          }),

          /// ➕ ADD TAB
          GestureDetector(
            onTap: onAddTab,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
