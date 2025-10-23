import 'package:main_sony/views/export_views.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wordpress_client/wordpress_client.dart';
import 'export_controller.dart';

class CommentController extends ApiProvider {
  final RxBool isSubmitting = false.obs;

  Future<void> submitComment(
    BuildContext ctx, {
    required int postId,
    required String content,
    required String authorName,
    required String authorEmail,
    String? authorUrl,
  }) async {
    isSubmitting.value = true;
    try {
      final request = CreateCommentRequest(
        post: postId,
        content: content,
        authorDisplayName: authorName,
        authorEmail: authorEmail,
        authorUrl: authorUrl ?? '',
        date: DateTime.now(),
      );
      final response = await cnx.comments.create(request);

      response.map(
        onSuccess: (res) {
          showTopSnackBar(
            Overlay.of(ctx),
            CustomSnackBar.success(message: 'Comment submitted for review.'),
          );
        },
        onFailure: (err) {
          showTopSnackBar(
            Overlay.of(ctx),
            CustomSnackBar.error(
              message: err.error?.message ?? 'Failed to submit comment',
            ),
          );
        },
      );
    } catch (e) {
      if (ctx.mounted) {
        showTopSnackBar(
          Overlay.of(ctx),
          CustomSnackBar.error(message: e.toString()),
        );
      }
    } finally {
      isSubmitting.value = false;
    }
  }
}
