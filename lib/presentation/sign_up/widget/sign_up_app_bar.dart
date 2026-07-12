import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';
import 'package:go_router/go_router.dart';

class SignUpAppBar extends StatelessWidget {
  const SignUpAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      title: '',
      onBack: context.pop,
      icons: [],
      onIconTap: [],
      showTitle: false,
      showIcons: false,
    );
  }
}
