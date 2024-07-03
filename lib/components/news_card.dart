import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final String? title, image, description, publishedAt;

  const NewsCard({
    super.key,
    this.title,
    this.image,
    this.description,
    this.publishedAt,
  });

  @override
  Widget build(BuildContext context) {
    DateTime parsedDate =
        publishedAt != null ? DateTime.parse(publishedAt!) : DateTime.now();
    String formattedDate = DateFormat('dd MMMM yyyy').format(parsedDate);

    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Material(
        elevation: 3.0,
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: 140,
                  height: 120,
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: FancyShimmerImage(
                      boxFit: BoxFit.cover,
                      imageUrl: image ?? '',
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        formattedDate,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        description ?? '',
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
