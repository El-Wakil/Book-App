import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/book_cubit.dart';
import '../cubits/book_state.dart';
import '../widgets/book_card.dart';
import '../widgets/search_bar.dart' as custom_search;
import '../widgets/category_chip.dart';
import '../theme/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    context.read<BookCubit>().loadBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: BlocBuilder<BookCubit, BookState>(
            builder: (context, state) {
              return CustomScrollView(
                slivers: [
                  // Glassmorphism App Bar
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 25,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: AppColors.accent.withOpacity(0.3),
                            blurRadius: 40,
                            offset: const Offset(0, 0),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 10),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, AppColors.accent],
                              ).createShader(bounds),
                              child: const Text(
                                'Discover',
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 2,
                                  shadows: [
                                    Shadow(color: Colors.black, blurRadius: 10),
                                  ],
                                ),
                              ),
                            ),
                            const Text(
                              'Find your next great read',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 20),
                            custom_search.SearchBar(
                              onSearch: (query) {
                                context.read<BookCubit>().searchBooks(query);
                              },
                              onClear: () {
                                context.read<BookCubit>().resetToHome();
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Content based on state
                  if (state is BookLoading) ...[
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ] else if (state is BookError) ...[
                    SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Oops! Something went wrong',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              state.message,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[500],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () {
                                context.read<BookCubit>().loadBooks();
                              },
                              child: const Text('Try Again'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else if (state is BookSearchLoaded) ...[
                    _buildSearchResults(state),
                  ] else if (state is BookCategoryLoaded) ...[
                    _buildCategoryResults(state),
                  ] else if (state is BookLoaded) ...[
                    _buildHomeContent(state),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHomeContent(BookLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        // Most Viewed Books Section
        if (state.mostViewedBooks.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(20),
            decoration: AppColors.glassContainer,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.primaryGradient.createShader(bounds),
                  child: const Text(
                    'Most Viewed',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 220,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.mostViewedBooks.length,
              itemBuilder: (context, index) {
                return BookCard(book: state.mostViewedBooks[index]);
              },
            ),
          ),
          const SizedBox(height: 32),
        ],

        // Categories Section
        if (state.categories.isNotEmpty) ...[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(20),
            decoration: AppColors.glassContainer,
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: const BoxDecoration(
                    gradient: AppColors.accentGradient,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
                const SizedBox(width: 12),
                ShaderMask(
                  shaderCallback: (bounds) =>
                      AppColors.accentGradient.createShader(bounds),
                  child: const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return CategoryChip(
                  category: category,
                  isSelected: selectedCategory == category,
                  onTap: () {
                    setState(() {
                      selectedCategory = category;
                    });
                    context.read<BookCubit>().loadBooksByCategory(category);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 32),
        ],

        // All Books Section
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.all(20),
          decoration: AppColors.glassContainer,
          child: Row(
            children: [
              Container(
                width: 4,
                height: 24,
                decoration: const BoxDecoration(
                  gradient: AppColors.secondaryGradient,
                  borderRadius: BorderRadius.all(Radius.circular(2)),
                ),
              ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) =>
                    AppColors.secondaryGradient.createShader(bounds),
                child: const Text(
                  'All Books',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio:
                  0.7, // Increased from 0.65 to 0.7 to accommodate better text display
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: state.books.length,
            itemBuilder: (context, index) {
              return BookCard(
                book: state.books[index],
                width: double.infinity,
                height: 280,
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _buildSearchResults(BookSearchLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Search Results for "${state.query}"',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${state.searchResults.length} books found',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        if (state.searchResults.isEmpty)
          const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No books found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.7, // Updated from 0.65 for better text display
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.searchResults.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: state.searchResults[index],
                  width: double.infinity,
                  height: 280,
                );
              },
            ),
          ),
        const SizedBox(height: 20),
      ]),
    );
  }

  Widget _buildCategoryResults(BookCategoryLoaded state) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    selectedCategory = null;
                  });
                  context.read<BookCubit>().resetToHome();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${state.categoryBooks.length} books',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (state.categoryBooks.isEmpty)
          const SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'No books found in this category',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio:
                    0.7, // Updated from 0.65 for better text display
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.categoryBooks.length,
              itemBuilder: (context, index) {
                return BookCard(
                  book: state.categoryBooks[index],
                  width: double.infinity,
                  height: 280,
                );
              },
            ),
          ),
        const SizedBox(height: 20),
      ]),
    );
  }
}
