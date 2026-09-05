import 'package:flutter/widgets.dart';
import 'package:gds/gds.dart';

class SignUpAppBar extends StatelessWidget {
  const SignUpAppBar({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return GdsTopNavigation.iconButton(
      title: '',
      onBack: onBack,
      icons: [],
      onIconTap: [],
      showTitle: false,
      showIcons: false,
    );
  }
}
