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
    result = await getImages(result);
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }

  getImages(result) async {
    for (var i = 0; i < result.length; i++) {
      // print('---------------------------------');
      // print(result[i]['_links']['wp:featuredmedia'][0]['href']);
      try {
        var urlImg =
            result[i]['_links']['wp:featuredmedia'][0]['href'].split('/');
        var number = urlImg[urlImg.length - 1];
        urlImg = '/media/$number';
        // print(urlImg);
        var dataImg = await _api.get(urlImg);
        // result[i]['url_img'] = dataImg['guid']['rendered'];
        // result[i]['url_img'] = dataImg['media_details']['sizes']['medium']['source_url'];
        result[i]['url_img'] = dataImg['media_details']['sizes']['et-builder-post-main-image']['source_url'];
      } catch (Exception) {
        result[i]['url_img'] = '';
        print(Exception);
      }
      // print(result[i]['url_img']);
    }
    return result;
  }

  Future<List<Notice>> loadNewsRecent() async {
    var result = await _api.get("/posts?per_page=5");
    result = await getImages(result);
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }

  Future<List<Notice>> loadSearch(String query) async {
    // print("/posts?search=$query&per_page=25");
    var result = await _api.get("/posts?search=$query&per_page=25");
    result = await getImages(result);
    return result.map<Notice>((notice) => new Notice.fromMap(notice)).toList();
  }
}
