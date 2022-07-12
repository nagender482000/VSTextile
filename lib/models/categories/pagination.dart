class Pagination {
  Pagination({
    required this.nextPage,
    required this.currentCount,
    required this.totalCount,
  });
  late final bool nextPage;
  late final int currentCount;
  late final String totalCount;

  Pagination.fromJson(Map<String, dynamic> json){
    nextPage = json['next_page'];
    currentCount = json['current_count'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['next_page'] = nextPage;
    _data['current_count'] = currentCount;
    _data['total_count'] = totalCount;
    return _data;
  }
}