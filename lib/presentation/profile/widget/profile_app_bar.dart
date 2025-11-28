import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:grimity/app/config/app_theme.dart';
import 'package:grimity/app/config/app_typeface.dart';
import 'package:grimity/presentation/common/widget/button/grimity_action_button.dart';
import 'package:grimity/presentation/profile/enum/profile_view_type_enum.dart';

class ProfileAppBar extends StatelessWidget {
  const ProfileAppBar({super.key, required this.userName, required this.nameOpacity, required this.viewType});

  final String userName;
  final double nameOpacity;
  final ProfileViewType viewType;

  @override
  Widget build(BuildContext context) {
    return _ProfileAppBarDelegate(name: userName, nameOpacity: nameOpacity, viewType: viewType);
  }
}

class _ProfileAppBarDelegate extends StatelessWidget {
  const _ProfileAppBarDelegate({required this.name, required this.nameOpacity, required this.viewType});

  final String name;
  final double nameOpacity;
  final ProfileViewType viewType;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppTheme.kToolbarHeight.height,
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: Icon(Icons.arrow_back_ios_new_outlined, size: 24),
          ),
          Gap(4),
          Expanded(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 100),
              opacity: nameOpacity,
              child: Text(name, style: AppTypeface.subTitle2, overflow: TextOverflow.ellipsis),
            ),
          ),
          const Spacer(),
          if (viewType == ProfileViewType.mine) ...[
            GrimityActionButton.search(context),
            Gap(20),
            GrimityActionButton.storage(context),
            Gap(20),
            GrimityActionButton.setting(context),
            Gap(16),
          ] else ...[
            GrimityActionButton.search(context),
            Gap(20),
            GrimityActionButton.user(context),
            Gap(20),
          ],
        ],
      ),
    );
  }
}
