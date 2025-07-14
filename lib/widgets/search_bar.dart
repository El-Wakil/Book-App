import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final VoidCallback? onClear;

  const SearchBar({super.key, required this.onSearch, this.onClear});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.glassGradient,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: AppColors.accent.withOpacity(0.2),
            blurRadius: 30,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        onSubmitted: widget.onSearch,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: 'Search books or authors...',
          hintStyle: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  AppColors.accentGradient.createShader(bounds),
              child: const Icon(Icons.search, color: Colors.white, size: 24),
            ),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: IconButton(
                    icon: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.clear,
                        color: Colors.grey[600],
                        size: 16,
                      ),
                    ),
                    onPressed: () {
                      _controller.clear();
                      widget.onClear?.call();
                    },
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
        onChanged: (value) {
          setState(() {});
          if (value.isEmpty && widget.onClear != null) {
            widget.onClear!();
          }
        },
      ),
    );
  }
}
