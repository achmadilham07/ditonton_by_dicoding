import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/usecases/get_tv_episode.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import '../../../helpers/test_helper.mocks.dart';

void main() {
  late GetTvEpisode usecase;
  late MockMovieRepository mockTvRepository;

  setUp(() {
    mockTvRepository = MockMovieRepository();
    usecase = GetTvEpisode(mockTvRepository);
  });

  const tId = 500;
  const tEpisode = 0;

  test('should get episode tv detail from the repository', () async {
    // arrange
    when(mockTvRepository.getTvEpisode(tId, tEpisode))
        .thenAnswer((_) async => Right(testTvEpisodeList));
    // act
    final result = await usecase.execute(tId, tEpisode);
    // assert
    expect(result, Right(testTvEpisodeList));
  });
}
