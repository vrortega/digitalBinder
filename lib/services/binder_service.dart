class BinderService {
  int calculateCardCount(List<List<String?>> pages) {
    return pages
        .expand((page) => page)
        .where((e) => e != null)
        .length;
  }

  String? getPreview(List<List<String?>> pages) {
    for (var page in pages) {
      for (var item in page) {
        if (item != null) return item;
      }
    }
    return null;
  }
}