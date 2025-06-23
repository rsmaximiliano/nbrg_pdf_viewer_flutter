class ViewerParams {
  final bool enableSwipe;
  final bool swipeHorizontal;
  final bool enableDoubletap;
  final int spacing;
  final int defaultPage;

  const ViewerParams({
    this.enableSwipe = true,
    this.swipeHorizontal = false,
    this.enableDoubletap = true,
    this.spacing = 10,
    this.defaultPage = 0,
  });

  Map<String, dynamic> toMap(Map<String, dynamic> map) {
    map['enableDoubletap'] = enableDoubletap;
    map['swipeHorizontal'] = swipeHorizontal;
    map['enableSwipe'] = enableSwipe;
    map['spacing'] = spacing;
    map['defaultPage'] = defaultPage;
    return map;
  }
}
