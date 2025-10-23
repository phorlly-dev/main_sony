import 'package:main_sony/views/export_views.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:wordpress_client/wordpress_client.dart';

void showCommentDialog(BuildContext ctx, int postId) {
  if (postId == 0) {
    showTopSnackBar(
      Overlay.of(ctx),
      CustomSnackBar.info(message: "Invid id of post.!"),
    );

    return;
  }

  showDialog<Comment>(
    context: ctx,
    barrierDismissible: false,
    builder: (_) => CommentDialog(postId: postId),
  );
}
