import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/image/get_upload_url_usecase.dart';
import 'package:grimity/domain/usecase/image/upload_image_usecase.dart';

final getImageUploadUrlUseCase = getIt<GetImageUploadUrlUseCase>();
final getImageUploadUrlsUseCase = getIt<GetImageUploadUrlsUseCase>();

final uploadImageUseCase = getIt<UploadImageUseCase>();
final uploadImagesUseCase = getIt<UploadImagesUseCase>();
