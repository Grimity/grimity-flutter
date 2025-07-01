import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:grimity/presentation/profile_edit/provider/upload_image_provider.dart';
import 'package:grimity/presentation/profile_edit/view/profile_crop_image_view.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_crop_button.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_crop_guide.dart';
import 'package:grimity/presentation/profile_edit/widget/profile_crop_image.dart';

class ProfileCropImagePage extends HookWidget {
  const ProfileCropImagePage({super.key, required this.type});

  final UploadImageType type;

  @override
  Widget build(BuildContext context) {
    final controller = useRef(CustomImageCropController());

    useEffect(() {
      return () {
        controller.value.dispose();
      };
    }, []);

    return ProfileCropImageView(
      cropImage: ProfileCropImage(controller: controller.value, type: type),
      cropGuide: ProfileGuide(),
      cropButton: ProfileCropButton(controller: controller.value, type: type),
    );
  }
}
