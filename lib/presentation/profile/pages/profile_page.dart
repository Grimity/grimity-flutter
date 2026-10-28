import 'package:flutter/widgets.dart';
import 'package:gds_flutter/gds_flutter.dart';
import 'package:grimity/api/api.dart';
import 'package:pervice/pervice.dart';

///
class ProfilePage extends StatelessWidget {
  const new({
    super.key,
    required this.handle,
  });

  /// 사용자의 프로필 주소에 쓰는 고유 식별자.
  final String handle;

  @override
  Widget build(BuildContext context) {
    final service = context.serviceOf(
      () => GetUsersProfileByUrl(url: handle),
      key: ValueKey(handle),
    );

    return service.page(
      loaded: (data) {
        return const Placeholder();
      },
    );
  }
}
