import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:instant_gram/constants/appwrite.dart';
import 'package:instant_gram/core/core.dart';
import 'package:instant_gram/core/typedefs.dart';
import 'package:instant_gram/models/liked_posts.dart';
import 'package:instant_gram/models/models.dart';

final postApiProvider = Provider((ref) =>
    PostApi(ref.read(databaseProvider), ref.read(postsRealTimeProvider)));

class PostApi {
  final Databases _database;
  final Realtime _realTime;

  PostApi(this._database, this._realTime);

  //posts

  FutureEither<Document> createPost(Post post) async {
    try {
      final document = await _database.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.postDetailscollectionId,
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
      collectionId: Appwrite.postDetailscollectionId,
    );
    return documents.documents;
  }

  Future<List<Document>> getPostsOfCurrentUser(String uid) async {
    final documents = await _database.listDocuments(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.postDetailscollectionId,
      queries: [
        Query.equal('uid', uid),
      ],
    );
    return documents.documents;
  }

  Stream<RealtimeMessage> getLatestPosts() {
    return _realTime.subscribe([
      'databases.${Appwrite.databaseId}.collections.${Appwrite.postDetailscollectionId}.documents',
      'collections.${Appwrite.postDetailscollectionId}.documents',
      'documents',
    ]).stream;
  }

  FutureEither deletePost(Post post) async {
    try {
      final document = _database.deleteDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.postDetailscollectionId,
        documentId: post.postId,
      );

      return Right(document);
    } on AppwriteException catch (e, st) {
      return Left(Failure(e.message ?? 'Something went wrong', st));
    }
  }

  //comments

  Future<Document> getCommentsOfPost(Post post) async {
    final document = await _database.getDocument(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.postDetailscollectionId,
      documentId: post.postId,
      queries: [
        Query.equal('postId', post.postId),
      ],
    );

    return document;
  }

  FutureEither<Document> updateCommentsOfPost(Post newPost) async {
    try {
      final document = await _database.updateDocument(
          databaseId: Appwrite.databaseId,
          collectionId: Appwrite.postDetailscollectionId,
          documentId: newPost.postId,
          data: {
            'comments': newPost.comments.map((e) => e.toMap()).toList(),
          });

      return Right(document);
    } on AppwriteException catch (e, st) {
      return Left(Failure(e.message ?? 'Something went wrong', st));
    }
  }

  //likes

  FutureEither<Document> updateLikesOfPost(Post post) async {
    try {
      final document = await _database.updateDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.postDetailscollectionId,
        documentId: post.postId,
        data: {
          'numberOfLikes': post.numberOfLikes,
        },
      );
      return Right(document);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Cannot Update', stackTrace));
    }
  }

  // adding likes

  FutureEither<Document> addLikedPostToListOfCurrentUser(
      LikedPostsOfCurrentUser likedPosts) async {
    try {
      final document = await _database.createDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.likedPostsCollectionId,
        documentId: likedPosts.uid,
        data: likedPosts.toMap(),
      );
      return Right(document);
    } on AppwriteException catch (e, stackTrace) {
      return Left(Failure(e.message ?? 'Something went wrong', stackTrace));
    }
  }

  Future<Document> getListOfLikedPostsOfCurrentUser(String uid) async {
    final document = await _database.getDocument(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.likedPostsCollectionId,
      documentId: uid,
    );

    return document;
  }

  Future<List<Document>> getListOfLikedPostsOfAllUsers() async {
    final documents = await _database.listDocuments(
      databaseId: Appwrite.databaseId,
      collectionId: Appwrite.likedPostsCollectionId,
    );

    return documents.documents;
  }

  FutureEither<Document> updateListOfLikedPostsOfCurrentUser(
      LikedPostsOfCurrentUser likedPosts) async {
    try {
      final document = await _database.updateDocument(
        databaseId: Appwrite.databaseId,
        collectionId: Appwrite.likedPostsCollectionId,
        documentId: likedPosts.uid,
        data: {
          'posts': likedPosts.listofPostId,
        },
      );
      return Right(document);
    } on AppwriteException catch (e, st) {
      return Left(Failure(e.message ?? 'Something went wrong', st));
    }
  }
}
