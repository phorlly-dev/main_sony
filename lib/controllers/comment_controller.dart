import 'package:get/get.dart';
import 'export_controller.dart';

class CommentController extends ApiProvider {
  final RxBool isSubmitting = false.obs;

  Future<bool> submitComment({
    required int postId,
    required String content,
    required String authorName,
    required String authorEmail,
    String? authorUrl,
  }) async {
    isSubmitting.value = true;
    try {
      final request = CreateCommentRequest(
        post: postId.toString(),
        content: content,
        authorDisplayName: authorName,
        authorEmail: authorEmail,
        authorUrl: authorUrl ?? '',
      );
      final response = await connx.comments.create(request);
      bool success = false;

      response.map(
        onSuccess: (res) {
          Get.snackbar(
            'Success',
            'Comment submitted for review.',
            snackPosition: SnackPosition.BOTTOM,
          );
          success = true;
        },
        onFailure: (err) {
          Get.snackbar(
            'Has Error Happen!',
            err.error?.message ?? 'Failed to submit comment',
            snackPosition: SnackPosition.BOTTOM,
          );
        },
      );

      return success;
    } catch (e) {
      Get.snackbar(
        'Somthing Wrong!',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }
}
