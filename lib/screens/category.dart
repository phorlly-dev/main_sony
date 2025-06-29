import 'package:flutter/material.dart';
import 'package:main_sony/components/nav_bar.dart';

class CategoryScreen extends StatefulWidget {
  final String title;
  final int? id;
  const CategoryScreen({super.key, required this.title, this.id});

  @override
  State<CategoryScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<CategoryScreen> {
  // final controller = Get.put(PostController());
  // final mediaController = Get.put(MediaController());

  @override
  void initState() {
    super.initState();
    // controller.getPosts;
    // mediaController.getDetails;
  }

  @override
  Widget build(BuildContext context) {
    return NavBar(
      title: widget.title,
      selectedId: widget.id,
      // child: DataView(
      //   dataSource:
      //       Future.wait([controller.getPosts, mediaController.getDetails]).then(
      //         (results) {
      //           final posts = results[0] as List<Post>;
      //           final mediaList = results[1] as List<Media>;
      //           // You might want to combine/match here or pass as a tuple/list
      //           return [posts, mediaList];
      //         },
      //       ),
      //   dataView: (context, snapshot) {
      //     final posts = snapshot.data![0] as List<Post>;
      //     final mediaList = snapshot.data![1] as List<Media>;
      //     final mediaMap = {for (var m in mediaList) m.id: m};

      //     return ListView.builder(
      //       itemCount: posts.length,
      //       itemBuilder: (context, index) {
      //         final post = posts[index];
      //         final media = mediaMap[post.featuredMedia ?? 0];
      //         log(
      //           "The items ${index + 1} of featuredMedia: ${post.featuredMedia}, mediaId: ${media?.id}, postId: ${media?.post}, mediaUrl: ${media?.sourceUrl}",
      //         );
      //         return Card(
      //           margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.stretch,
      //             children: [
      //               if (media != null &&
      //                   getResponsiveImageUrl(media).isNotEmpty)
      //                 Image.network(
      //                   getResponsiveImageUrl(media),
      //                   height: 200,
      //                   width: double.infinity,
      //                   fit: BoxFit.cover,
      //                 )
      //               else
      //                 const AspectRatio(
      //                   aspectRatio: 16 / 9,
      //                   child: Icon(Icons.broken_image, size: 48),
      //                 ),

      //               // Padding(
      //               //   padding: const EdgeInsets.all(16.0),
      //               //   child: Text(
      //               //     post.title?.rendered ?? '',
      //               //     style: TextStyle(
      //               //       // fontSize: 18,
      //               //       // fontWeight: FontWeight.bold,
      //               //     ),
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         );
      //       },
      //     );
      //   },
      // ),
    );
  }
}
