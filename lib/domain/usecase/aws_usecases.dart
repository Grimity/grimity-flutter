import 'package:grimity/app/di/di_setup.dart';
import 'package:grimity/domain/usecase/aws/get_presigned_url_usecase.dart';
import 'package:grimity/domain/usecase/aws/upload_image_usecase.dart';

final getPresignedUrlUseCase = getIt<GetPresignedUrlUseCase>();
final getPresignedUrlsUseCase = getIt<GetPresignedUrlsUseCase>();

final uploadImageUseCase = getIt<UploadImageUseCase>();
final uploadImagesUseCase = getIt<UploadImagesUseCase>();
