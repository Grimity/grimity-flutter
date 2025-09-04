import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/home/hook/home_searching_hooks.dart';

class SearchAppBar extends ConsumerStatefulWidget {
  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> {
  final TextEditingController _controller = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          if (_isSearching)
            GestureDetector(
              onTap: () {
                setState(() => _isSearching = false);
                _controller.clear();
                DrawingHooks.useSetSearchQuery(ref, '');
              },
              child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey[600]),
            )
          else
            Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey[600]),
          SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isSearching = true),
              child: Container(
                height: 44,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _isSearching
                    ? TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: '검색어를 입력해주세요',
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 16,
                    ),
                  ),
                  onChanged: (value) {
                    DrawingHooks.useSetSearchQuery(ref, value);
                  },
                  onSubmitted: (value) {
                    DrawingHooks.useSetSearchQuery(ref, value);
                  },
                )
                    : Text(
                  '검색어를 입력해주세요',
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 12),
          GestureDetector(
            onTap: () {
              if (_isSearching) {
                DrawingHooks.useSetSearchQuery(ref, _controller.text);
              } else {
                setState(() => _isSearching = true);
              }
            },
            child: Icon(Icons.search, size: 24, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}