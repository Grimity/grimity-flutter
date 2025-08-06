import 'package:dio/dio.dart' hide Headers;
import 'package:grimity/data/model/tag/popular_tag_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'tag_api.g.dart';

@injectable
@RestApi()
abstract class TagAPI {
  @factoryMethod
  factory TagAPI(Dio dio, {@Named('baseUrl') String baseUrl}) = _TagAPI;

  @GET('/tags/popular')
  Future<List<PopularTagResponse>> getPopularTags();
}
