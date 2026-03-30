import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:digital_binder/viewmodels/binder_viewmodel.dart';
import 'package:digital_binder/repositories/binder_repository.dart';
import 'package:digital_binder/services/image_service.dart';
import 'package:digital_binder/services/picker_service.dart';
import 'package:digital_binder/services/binder_service.dart';
import 'package:digital_binder/models/binder_model.dart';

class MockBinderRepository extends Mock implements BinderRepository {}
class MockImageService extends Mock implements ImageService {}
class MockPickerService extends Mock implements PickerService {}
class MockBinderService extends Mock implements BinderService {}

class FakeFile extends Fake implements File {}

void main() {
  late MockBinderRepository repository;
  late MockImageService imageService;
  late MockPickerService pickerService;
  late MockBinderService binderService;

  late BinderViewModel viewModel;

  const binderId = '1';

  BinderViewModel createViewModel() {
    return BinderViewModel(
      binderId: binderId,
      repository: repository,
      imageService: imageService,
      pickerService: pickerService,
      binderService: binderService,
    );
  }

  void mockDefaultBehaviors() {
    when(() => repository.getBinderPages(any()))
        .thenAnswer((_) async => [
              ['img1', null, null, null]
            ]);

    when(() => repository.saveBinder(any(), any()))
        .thenAnswer((_) async {});

    when(() => repository.loadBinders())
        .thenAnswer((_) async => [
              const BinderModel(
                id: binderId,
                name: 'Binder',
                cardCount: 0,
                preview: null,
              )
            ]);

    when(() => repository.saveBinders(any()))
        .thenAnswer((_) async {});

    when(() => binderService.calculateCardCount(any()))
        .thenReturn(1);

    when(() => binderService.getPreview(any()))
        .thenReturn('preview.png');
  }

  setUpAll(() {
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    repository = MockBinderRepository();
    imageService = MockImageService();
    pickerService = MockPickerService();
    binderService = MockBinderService();

    mockDefaultBehaviors();
    viewModel = createViewModel();
  });


  group('loadBinder', () {
    test('should load binder pages successfully', () async {
      await viewModel.loadBinder();

      expect(viewModel.state, ViewState.success);
      expect(viewModel.pages.length, 1);
    });
  });

  group('pickImage', () {
    test('should pick image and persist data', () async {
      final file = File('path');

      when(() => pickerService.pickImage())
          .thenAnswer((_) async => file);

      when(() => imageService.saveImage(file))
          .thenAnswer((_) async => 'saved.png');

      await viewModel.pickImage(0);

      expect(viewModel.pages[0][0], 'saved.png');

      verify(() => repository.saveBinder(any(), any())).called(1);
      verify(() => repository.saveBinders(any())).called(1);
    });
  });

  group('deleteCard', () {
    test('should delete card and persist changes', () async {
      when(() => imageService.deleteImage(any()))
          .thenAnswer((_) async {});

      await viewModel.loadBinder();

      await viewModel.deleteCard(0);

      expect(viewModel.pages[0][0], null);

      verify(() => imageService.deleteImage('img1')).called(1);
      verify(() => repository.saveBinder(any(), any())).called(1);
    });
  });

  group('reorderCards', () {
    test('should reorder cards correctly', () async {
      await viewModel.loadBinder();

      await viewModel.reorderCards(0, 1);

      verify(() => repository.saveBinder(any(), any())).called(1);
    });
  });

  group('pagination', () {
    test('should go to next page and create new page when needed', () {
      viewModel.nextPage();

      expect(viewModel.currentPage, 1);
      expect(viewModel.pages.length, 2);
    });

    test('should go to previous page when available', () {
      viewModel.nextPage();

      viewModel.previousPage();

      expect(viewModel.currentPage, 0);
    });
  });
}