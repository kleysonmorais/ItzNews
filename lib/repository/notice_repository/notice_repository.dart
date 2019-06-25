import 'package:FlutterNews/repository/notice_repository/model/notice.dart';
import 'package:FlutterNews/support/conection/api.dart';

abstract class NoticeRepository {
  Future<List<Notice>> loadNews(int category, int page);
  Future<List<Notice>> loadNewsRecent();
  Future<List<Notice>> loadSearch(String query);
}

class NoticeRepositoryImpl implements NoticeRepository {
  final Api _api;

  NoticeRepositoryImpl(this._api);

  Future<List<Notice>> loadNews(int category, int page) async {
    String url = category == 0
        ? '/posts?page=$page'
        : '/posts?categories=$category&page=$page';
    var result = await _api.get(url);
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }

  Future<List<Notice>> loadNewsRecent() async {
    var result = await _api.get("/posts?per_page=5");
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }

  Future<List<Notice>> loadSearch(String query) async {
    var result = await _api.get("/posts?search=$query&per_page=15");
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }
}
