import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grimity/presentation/search/hook/search_hooks.dart';

class SearchAppBar extends ConsumerStatefulWidget {
  const SearchAppBar({super.key});

  @override
  ConsumerState<SearchAppBar> createState() => _SearchAppBarState();
}

class _SearchAppBarState extends ConsumerState<SearchAppBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              _controller.clear();
              DrawingHooks.useSetSearchQuery(ref, '');
              FocusScope.of(context).unfocus();
            },
            child: Icon(Icons.arrow_back_ios, size: 20, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: TextField(
              controller: _controller,
              autofocus: false,
              decoration: InputDecoration(
                hintText: '검색어를 입력해주세요',
                hintStyle: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 16,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.grey[300]!),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.black),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search, color: Colors.grey[600]),
                  onPressed: () {
                    DrawingHooks.useSetSearchQuery(ref, _controller.text);
                  },
                ),
              ),
              onChanged: (value) {
                DrawingHooks.useSetSearchQuery(ref, value);
              },
              onSubmitted: (value) {
                DrawingHooks.useSetSearchQuery(ref, value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
