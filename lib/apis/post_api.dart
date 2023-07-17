import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/core/typedefs.dart';
import 'package:instant_gram/models/models.dart';

final postApiProvider = Provider((ref) => PostApi(ref.read(databaseProvider)));

class PostApi {
  final Databases _database;

  PostApi(this._database);

  FutureEither<void> createPost(Post post) async {
    try {
      await _database.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionId,
        documentId: post.postId,
        data: post.toMap(),
      );
      return const Right(null);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    } catch (e, stacktrace) {
      return Left(Failure(e.toString(), stacktrace));
    }
  }

  FutureEither<DocumentList> getAllPosts() async {
    try {
      final allPosts = await _database.listDocuments(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionId,
      );
      return Right(allPosts);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    }
  }
}
