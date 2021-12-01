import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_top_rated/tv_top_rated_bloc.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart' as tail;

import '../../helpers/test_helper.dart';

void main() {
  late MockTvTopRatedBloc mockTvTopRatedBloc;

  setUp(() {
    mockTvTopRatedBloc = MockTvTopRatedBloc();
  });
  group("BLOC", () {
    Widget _makeTestableWidget(Widget body) {
      return BlocProvider<TvTopRatedBloc>(
        create: (_) => mockTvTopRatedBloc,
        child: MaterialApp(
          home: body,
        ),
      );
    }

    testWidgets('Page should display center text when nothing',
        (WidgetTester tester) async {
      tail.when(() => mockTvTopRatedBloc.state).thenReturn(TvTopRatedEmpty());

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

      expect(textFinder, findsOneWidget);
    });

    testWidgets('Page should display progress bar when loading',
        (WidgetTester tester) async {
      tail.when(() => mockTvTopRatedBloc.state).thenReturn(TvTopRatedLoading());

      final progressFinder = find.byType(CircularProgressIndicator);
      final centerFinder = find.byType(Center);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

      expect(centerFinder, findsOneWidget);
      expect(progressFinder, findsOneWidget);
    });

    testWidgets('Page should display when data is loaded',
        (WidgetTester tester) async {
      tail
          .when(() => mockTvTopRatedBloc.state)
          .thenReturn(const TvTopRatedLoaded(<Tv>[]));

      final listViewFinder = find.byType(ListView);

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

      expect(listViewFinder, findsOneWidget);
    });

    testWidgets('Page should display text with message when Error',
        (WidgetTester tester) async {
      tail
          .when(() => mockTvTopRatedBloc.state)
          .thenReturn(const TvTopRatedError('Error message'));

      final textFinder = find.byKey(const Key('error_message'));

      await tester.pumpWidget(_makeTestableWidget(const TopRatedTvsPage()));

      expect(textFinder, findsOneWidget);
    });
  });
}
