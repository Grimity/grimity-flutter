import 'package:grimity/app/base/result.dart';
import 'package:grimity/app/base/use_case.dart';
import 'package:grimity/domain/dto/aws_request_params.dart';
import 'package:grimity/domain/entity/presigned_url.dart';
import 'package:grimity/domain/repository/aws_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetPresignedUrlsUseCase extends UseCase<List<GetPresignedUrlRequest>, Result<List<PresignedUrl>>> {
  GetPresignedUrlsUseCase(this._awsRepository);

  final AWSRepository _awsRepository;
  @override
  Future<Result<List<PresignedUrl>>> execute(List<GetPresignedUrlRequest> requests) async {
    return await _awsRepository.getPresignedUrls(requests);
  }
}
