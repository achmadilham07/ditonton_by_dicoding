import 'package:ditonton/data/datasources/db/database_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/dummy_objects.dart';
import 'database_helper_test.mocks.dart';

@GenerateMocks([
  DatabaseHelper,
])
void main() {
  late MockDatabaseHelper mockDatabaseHelper;

  setUp(() {
    mockDatabaseHelper = MockDatabaseHelper();
  });

  group("MOVIES", () {
    group('save watchlist', () {
      test('should return success message when insert to database is success',
          () async {
        // arrange
        when(mockDatabaseHelper.insertWatchlist(testMovieTable))
            .thenAnswer((_) async => 1);
        // act
        final result = await mockDatabaseHelper.insertWatchlist(testMovieTable);
        // assert
        expect(result, 1);
      });

      test('should throw DatabaseException when insert to database is failed',
          () async {
        var newTestMovieTable = testMovieTable;
        newTestMovieTable.isMovie = 3.2;
        // arrange
        when(mockDatabaseHelper.insertWatchlist(newTestMovieTable))
            .thenAnswer((_) async => 0);
        // act
        final result =
            await mockDatabaseHelper.insertWatchlist(newTestMovieTable);
        // assert
        expect(result, 0);
      });
    });
  });
}
