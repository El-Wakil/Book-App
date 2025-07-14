import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../screens/book_detail_screen.dart';
import '../theme/app_colors.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final double width;
  final double height;
  final bool showDetails;

  const BookCard({
    super.key,
    required this.book,
    this.width = 120,
    this.height = 180,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BookDetailScreen(book: book)),
        );
      },
      child: Container(
        width: width,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Glassmorphism Book Cover
            Expanded(
              flex: showDetails
                  ? 3
                  : 1, // Reduced from 4 to 3 to give more space for text
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: AppColors.glassGradient,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.2),
                      blurRadius: 30,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    children: [
                      // Book cover image
                      if (book.coverUrl.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: book.coverUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                          placeholder: (context, url) => Container(
                            decoration: AppColors.glassContainer,
                            child: Center(
                              child: CircularProgressIndicator(
                                color: AppColors.accent,
                                strokeWidth: 3,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            decoration: AppColors.glassContainer,
                            child: const Icon(
                              Icons.auto_stories,
                              size: 40,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      else
                        Container(
                          decoration: AppColors.glassContainer,
                          child: const Icon(
                            Icons.auto_stories,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                        ),

                      // Glassmorphism overlay with gradient
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            if (showDetails) ...[
              Expanded(
                flex:
                    2, // Increased flex from 1 to 2 to give more space for text
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, left: 4, right: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Book Title - removed glassmorphism container for better text display
                      Expanded(
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            fontSize: 13, // Slightly increased from 12
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                            height:
                                1.3, // Added line height for better readability
                          ),
                          maxLines: 3, // Increased from 2 to 3 lines
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Author
                      Text(
                        book.author,
                        style: const TextStyle(
                          fontSize: 11, // Slightly increased from 10
                          color: AppColors.textSecondary,
                          height: 1.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
