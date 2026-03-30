import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:digital_binder/services/image_service.dart';
import 'package:digital_binder/viewmodels/home_viewmodel.dart';
import 'package:digital_binder/repositories/binder_repository.dart';
import '../test/binder_factory.dart';

class MockBinderRepository extends Mock implements BinderRepository {}
class MockImageService extends Mock implements ImageService {}

void main() {
  late MockBinderRepository repository;
  late MockImageService imageService;
  late HomeViewModel viewModel;

  setUp(() {
    repository = MockBinderRepository();
    imageService = MockImageService();

    when(() => repository.loadBinders())
        .thenAnswer((_) async => []);
     when(() => repository.getBinderPages(any()))
        .thenAnswer((_) async => []);

    when(() => repository.saveBinders(any()))
        .thenAnswer((_) async {});

    when(() => imageService.deleteImagesFromBinder(any()))
        .thenAnswer((_) async {});
  });

  test('should load binders successfully when repository returns data', () async {
    final binders = [createBinder()];

    when(() => repository.loadBinders())
        .thenAnswer((_) async => binders);

    viewModel = HomeViewModel(
      repository: repository,
      imageService: imageService,
    );

    await viewModel.loadBinders();

    expect(viewModel.state, ViewState.success);
    expect(viewModel.binders.length, 1);
  });


  test('should set error state when deleteBinder throws an exception', () async {
    final binder = createBinder();

    when(() => repository.loadBinders())
        .thenAnswer((_) async => [binder]);

    when(() => repository.deleteBinder('1'))
        .thenThrow(Exception());

    viewModel = HomeViewModel(
      repository: repository,
      imageService: imageService,
    );

    await viewModel.loadBinders();
    await viewModel.deleteBinder('1');

    expect(viewModel.state, ViewState.error);

    verify(() => repository.deleteBinder('1')).called(1);
  });

  test('should create a new binder and return it successfully', () async {
    final binder = createBinder(name: 'Novo Binder');

    when(() => repository.createBinder(any()))
        .thenAnswer((_) async => binder);

    viewModel = HomeViewModel(
      repository: repository,
      imageService: imageService,
    );

    final result = await viewModel.createBinder();

    expect(result.id, '1');

    verify(() => repository.createBinder(any())).called(1);
  });
}