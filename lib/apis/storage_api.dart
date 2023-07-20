import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:instant_gram/core/core.dart';

final storageApiProvider = Provider(
  (ref) => StorageApi(ref.watch(storageProvider)),
);

class StorageApi {
  final Storage _storage;

  StorageApi(this._storage);

  Future<String> uploadMedia(File media) async {
    final uploadedMedia = await _storage.createFile(
      bucketId: Appwrite.imagesAndVideosBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: media.path),
    );

    return uploadedMedia.$id;
  }

  Future<String> uploadThumbnail(String path) async {
    final uploadedThumbnail = await _storage.createFile(
      bucketId: Appwrite.imagesAndVideosBucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(
        path: path,
        filename: 'thumbnail${ID.unique().substring(0, 4)}',
      ),
    );

    return uploadedThumbnail.$id;
  }
}
