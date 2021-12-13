import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CachedImageUrl {
  static final CachedImageUrl _instance = CachedImageUrl();

  static CachedImageUrl get instance => _instance;

  Map<String, String> imgWithUrl = {};

  Future<String> getUrl(firebase_storage.Reference ref) async {
    if (CachedImageUrl.instance.imgWithUrl[ref.fullPath] == null) {
      String url = await ref.getDownloadURL();
      imgWithUrl[ref.fullPath] = url;
      return url;
    } else {
      return imgWithUrl[ref.fullPath]!;
    }
  }
}
