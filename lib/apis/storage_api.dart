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

  Future<String> uploadMedia(File media, String postId) async {
    final uploadedMedia = await _storage.createFile(
      bucketId: Appwrite.imagesAndVideosBucketId,
      fileId: postId,
      file: InputFile.fromPath(path: media.path),
    );

    return uploadedMedia.$id;
  }

  Future deleteMedia(String postId) async {
    return await _storage.deleteFile(
      fileId: postId,
      bucketId: Appwrite.imagesAndVideosBucketId,
    );
  }

  Future<String> uploadThumbnail(String path, String postId) async {
    final uploadedThumbnail = await _storage.createFile(
      bucketId: Appwrite.imagesAndVideosBucketId,
      fileId: postId,
      file: InputFile.fromPath(
        path: path,
        filename: 'thumbnail${ID.unique().substring(0, 4)}',
      ),
    );

    return uploadedThumbnail.$id;
  }

  Future deleteThumbnail(String postId) async {
    return await _storage.deleteFile(
      fileId: postId,
      bucketId: Appwrite.imagesAndVideosBucketId,
    );
  }
}
