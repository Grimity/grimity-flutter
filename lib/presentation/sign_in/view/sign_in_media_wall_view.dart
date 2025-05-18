import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// TODO: Refactor
class SignInMediaWallView extends StatefulWidget {
  const SignInMediaWallView({super.key});

  @override
  State<SignInMediaWallView> createState() => _SignInMediaWallViewState();
}

class _SignInMediaWallViewState extends State<SignInMediaWallView> {
  late List<ImageItem> _images1;
  late List<ImageItem> _images2;
  late List<ImageItem> _images3;

  final ScrollController _controller1 = ScrollController();
  final ScrollController _controller2 = ScrollController();
  final ScrollController _controller3 = ScrollController();

  Timer? _timer1;
  Timer? _timer2;
  Timer? _timer3;

  // 스크롤 위치 관리
  double _scrollPosition1 = 0.0;
  double _scrollPosition2 = 0.0;
  double _scrollPosition3 = 0.0;

  // 스크롤 속도 설정
  final double _scrollSpeed1 = 0.6;
  final double _scrollSpeed2 = 0.8;
  final double _scrollSpeed3 = 0.5;

  @override
  void initState() {
    super.initState();

    _images1 = [
      ImageItem(path: 'assets/images/sign_up/1.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/2.png', height: 250.w),
      ImageItem(path: 'assets/images/sign_up/3.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/4.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/5.png', height: 114.w),
    ];

    _images2 = [
      ImageItem(path: 'assets/images/sign_up/6.png', height: 250.w),
      ImageItem(path: 'assets/images/sign_up/7.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/8.png', height: 114.w),
      ImageItem(path: 'assets/images/sign_up/9.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/10.png', height: 210.w),
    ];

    _images3 = [
      ImageItem(path: 'assets/images/sign_up/11.png', height: 250.w),
      ImageItem(path: 'assets/images/sign_up/12.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/13.png', height: 114.w),
      ImageItem(path: 'assets/images/sign_up/14.png', height: 210.w),
      ImageItem(path: 'assets/images/sign_up/15.png', height: 210.w),
    ];

    // 1열: 위로 스크롤
    _timer1 = Timer.periodic(const Duration(milliseconds: 70), (timer) {
      if (_controller1.hasClients) {
        _scrollPosition1 -= _scrollSpeed1;
        if (_scrollPosition1 <= _controller1.position.minScrollExtent + 500) {
          _scrollPosition1 = _controller1.position.maxScrollExtent / 2;
        }
        _controller1.jumpTo(_scrollPosition1);
      }
    });

    // 2열: 아래로 스크롤
    _timer2 = Timer.periodic(const Duration(milliseconds: 65), (timer) {
      if (_controller2.hasClients) {
        _scrollPosition2 += _scrollSpeed2;
        if (_scrollPosition2 >= _controller2.position.maxScrollExtent - 500) {
          _scrollPosition2 = _controller2.position.maxScrollExtent / 2;
        }
        _controller2.jumpTo(_scrollPosition2);
      }
    });

    // 3열: 위로 스크롤
    _timer3 = Timer.periodic(const Duration(milliseconds: 75), (timer) {
      if (_controller3.hasClients) {
        _scrollPosition3 -= _scrollSpeed3;
        if (_scrollPosition3 <= _controller3.position.minScrollExtent + 500) {
          _scrollPosition3 = _controller3.position.maxScrollExtent / 2;
        }
        _controller3.jumpTo(_scrollPosition3);
      }
    });
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    _controller3.dispose();
    _timer1?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final baseImageWidth = 150.w;
    final columnGap = 15;

    final column2X = (screenWidth - baseImageWidth) / 2;
    final column1X = column2X - baseImageWidth - columnGap;
    final column3X = column2X + baseImageWidth + columnGap;

    return Stack(
      children: [
        Positioned(
          left: column1X,
          width: 160.w,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            controller: _controller1,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 50,
            itemBuilder: (context, index) {
              final imageIndex = index % _images1.length;
              return _buildImageItem(_images1[imageIndex]);
            },
          ),
        ),
        Positioned(
          left: column2X,
          width: 160.w,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            controller: _controller2,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 50,
            itemBuilder: (context, index) {
              final imageIndex = (index + 3) % _images2.length;
              return _buildImageItem(_images2[imageIndex]);
            },
          ),
        ),
        Positioned(
          left: column3X,
          width: 160.w,
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            controller: _controller3,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 50,
            itemBuilder: (context, index) {
              final imageIndex = (index + 6) % _images3.length;
              return _buildImageItem(_images3[imageIndex]);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildImageItem(ImageItem imageItem) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: 150.w,
        height: imageItem.height,
        margin: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(image: AssetImage(imageItem.path), fit: BoxFit.cover),
        ),
      ),
    );
  }
}

class ImageItem {
  final String path;
  final double height;

  ImageItem({required this.path, required this.height});
}
