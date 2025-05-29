import 'package:flutter_test/flutter_test.dart';
import 'package:green_check/domain/usecases/save_notice_use_case.dart';
import 'package:green_check/infrastructure/repositories/notice_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../mother/info_object_mother.dart';
import 'save_notice_use_case_test.mocks.dart';

@GenerateMocks([NoticeRepository])
void main() {
  late SaveNoticeUseCase saveNoticeUseCase;
  late MockNoticeRepository mockNoticeRepository;

  setUp(() {
    mockNoticeRepository = MockNoticeRepository();
    saveNoticeUseCase = SaveNoticeUseCase(mockNoticeRepository);
  });

  group('execute()', () {
    final testNotice = InfoObjectMother.createNotice();

    final savedNotice = InfoObjectMother.createNotice();

    test('should save notice and return saved version', () async {
      when(mockNoticeRepository.saveNotice(testNotice))
          .thenAnswer((_) async => savedNotice);

      final result = await saveNoticeUseCase.execute(testNotice);

      verify(mockNoticeRepository.saveNotice(testNotice));
      expect(result, equals(savedNotice));
    });

    test('should throw exception when save fails', () async {
      when(mockNoticeRepository.saveNotice(testNotice))
          .thenThrow(Exception('Database error'));

      expect(
        () async => await saveNoticeUseCase.execute(testNotice),
        throwsA(isA<Exception>()),
      );
      verify(mockNoticeRepository.saveNotice(testNotice));
    });

    test('should include original error in exception message', () async {
      const errorMessage = 'Permission denied';
      when(mockNoticeRepository.saveNotice(testNotice))
          .thenThrow(Exception(errorMessage));

      expect(
        () async => await saveNoticeUseCase.execute(testNotice),
        throwsA(predicate(
            (e) => e is Exception && e.toString().contains(errorMessage))),
      );
    });

    test('should verify repository is called exactly once', () async {
      when(mockNoticeRepository.saveNotice(testNotice))
          .thenAnswer((_) async => savedNotice);

      await saveNoticeUseCase.execute(testNotice);

      verify(mockNoticeRepository.saveNotice(testNotice)).called(1);
    });

    test('should preserve all notice properties when saving', () async {
      when(mockNoticeRepository.saveNotice(any))
          .thenAnswer((_) async => savedNotice);

      final result = await saveNoticeUseCase.execute(testNotice);

      expect(result.title, equals(testNotice.title));
      expect(result.message, equals(testNotice.message));
    });
  });
}
