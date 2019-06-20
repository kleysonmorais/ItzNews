import 'package:FlutterNews/repository/notice_repository/notice_repository.dart';
import 'package:FlutterNews/support/conection/api.dart';
import 'package:bsev/bsev.dart';
import 'package:bsev/flavors.dart';

injectRepository(Injector injector) {
  injector.registerSingleton((i) {
    Api _api;
    switch (Flavors().getFlavor()) {
      case Flavor.PROD:
        _api = Api("https://imperatriznoticias.ufma.br/wp-json/wp/v2");
        break;
      case Flavor.HOMOLOG:
        _api = Api("");
        break;
      case Flavor.DEBUG:
        _api = Api("");
        break;
    }
    return _api;
  });

  injector.registerDependency<NoticeRepository>(
      (i) => NoticeRepositoryImpl(i.getDependency()));
}
