import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/repository/aws_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class UploadImageUseCase extends UseCase<UploadImageRequest, Result<void>> {
  UploadImageUseCase(this._awsRepository);

  final AWSRepository _awsRepository;
  @override
  Future<Result<void>> execute(UploadImageRequest request) async {
    return await _awsRepository.uploadImage(request);
  }
}
