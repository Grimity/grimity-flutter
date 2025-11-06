import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:grimity/app/config/app_color.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/grimity_gesture.dart';

/// 페이지네이션 페이지 표시를 위한 위젯
///
/// 현재 페이지, 페이지 크기, 총 항목 수 기준으로
/// 최대 5개의 페이지 버튼과 이전/다음 버튼을 표시
///
/// - [currentPage] : 현재 선택된 페이지 번호
/// - [size] : 한 페이지에 보여줄 항목 수
/// - [totalCount] : 총 항목 수
/// - [onPageSelected] : 페이지 선택 시 호출되는 콜백 (선택된 페이지 번호 전달)
class GrimityPaginationWidget extends StatelessWidget {
  final int currentPage;
  final int size;
  final int totalCount;
  final ValueChanged<int> onPageSelected;

  const GrimityPaginationWidget({
    super.key,
    required this.currentPage,
    required this.size,
    required this.totalCount,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final totalPages = (totalCount / size).ceil();
    if (totalPages < 1) return SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.only(top: 30.h, bottom: 40.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 6.w,
        children: [
          if (currentPage > 1)
            IconButton(onPressed: () => onPageSelected(currentPage - 1), icon: Icon(Icons.chevron_left, size: 24.w)),
          ..._getPageNumbers(currentPage: currentPage, totalPages: totalPages).map(
            (page) => GrimityGesture(
              onTap: () {
                if (page != currentPage) {
                  onPageSelected(page);
                }
              },
              child: Container(
                width: 36.w,
                height: 36.w,
                color: page == currentPage ? AppColor.gray200 : Colors.white,
                child: Center(child: Text(page.toString(), style: AppTypeface.body1.copyWith(color: AppColor.gray700))),
              ),
            ),
          ),
          if (currentPage < totalPages)
            IconButton(onPressed: () => onPageSelected(currentPage + 1), icon: Icon(Icons.chevron_right, size: 24.w)),
        ],
      ),
    );
  }

  List<int> _getPageNumbers({required int currentPage, required int totalPages}) {
    // 기본값: 가운데 기준으로 시작과 끝 계산
    int startPage = currentPage - 2;
    int endPage = currentPage + 2;

    // 왼쪽 범위 벗어나면 오른쪽으로 밀기
    if (startPage < 1) {
      endPage += (1 - startPage);
      startPage = 1;
    }

    // 오른쪽 범위 벗어나면 왼쪽으로 당기기
    if (endPage > totalPages) {
      startPage -= (endPage - totalPages);
      endPage = totalPages;
    }

    // 범위 고정 (1 ~ totalPages)
    startPage = startPage.clamp(1, totalPages);
    endPage = endPage.clamp(1, totalPages);

    return List.generate(endPage - startPage + 1, (i) => startPage + i);
  }
}
