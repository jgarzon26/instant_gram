import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/core/typedefs.dart';
import 'package:instant_gram/models/models.dart';

final postApiProvider = Provider((ref) =>
    PostApi(ref.read(databaseProvider), ref.read(postsRealTimeProvider)));

class PostApi {
  final Databases _database;
  final Realtime _realTime;

  PostApi(this._database, this._realTime);

  FutureEither<Document> createPost(Post post) async {
    try {
      final document = await _database.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.collectionId,
        documentId: post.postId,
        data: post.toMap(),
      );
      return Right(document);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    } catch (e, stacktrace) {
      return Left(Failure(e.toString(), stacktrace));
    }
  }

  Future<List<Document>> getPosts() async {
    final documents = await _database.listDocuments(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.collectionId,
    );
    return documents.documents;
  }

  Future<List<Document>> getPostsOfCurrentUser(String uid) async {
    final documents = await _database.listDocuments(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.collectionId,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  Stream<RealtimeMessage> updateAllPosts() {
    return _realTime.subscribe([
      'databases.${Appwrite.databaseId}.collections.${Appwrite.collectionId}.documents'
    ]).stream;
  }
}
