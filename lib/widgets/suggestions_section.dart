import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SuggestionsSection extends StatelessWidget {
  final List<String> suggestions;
  final Function(String) onAddSuggestion;

  const SuggestionsSection({
    super.key,
    required this.suggestions,
    required this.onAddSuggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,                          //  to create shadow effects used in box Shadow
            blurRadius: 6,
            offset: const Offset(0, 3),            // This offset creates a natural shadow effect, making the widget appear to "float" slightly above the surface.
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.lightbulb_outline,
                color: Colors.orange[600],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Smart Suggestions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[600],
                    ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            'Items you often buy together',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 16),

          // Suggestions from OpenAI recommendations API
          FutureBuilder<List<String>>(                      // When We use FutureBuilder, you provide a builder function with two parameters: future and builder
            future: ApiService.getRecommendations(),      // This snapshot is provided by builder function in Future Builder
            builder: (context, snapshot) {               // Flutter automatically creates and updates this snapshot object as the Future progresses through different states.
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {      // If we get the data from API
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: snapshot.data!.map((suggestion) {
                    return _SuggestionChip(
                      suggestion: suggestion,
                      onTap: () => onAddSuggestion(suggestion),
                    );
                  }).toList(),
                );
              } else if (suggestions.isNotEmpty) {          // If API Fails then local list of suggestions
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: suggestions.map((suggestion) {
                    return _SuggestionChip(
                      suggestion: suggestion,
                      onTap: () => onAddSuggestion(suggestion),
                    );
                  }).toList(),
                );
              } else {                                // If both fails API And Local List Of Suggeestions then as a fallback show these products
                // Fallback to database products
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _SuggestionChip(
                      suggestion: 'Whole Milk',
                      onTap: () => onAddSuggestion('Whole Milk'),
                    ),
                    _SuggestionChip(
                      suggestion: 'Whole Wheat Bread',
                      onTap: () => onAddSuggestion('Whole Wheat Bread'),
                    ),
                    _SuggestionChip(
                      suggestion: 'Bananas',
                      onTap: () => onAddSuggestion('Bananas'),
                    ),
                    _SuggestionChip(
                      suggestion: 'Chicken Breast',
                      onTap: () => onAddSuggestion('Chicken Breast'),
                    ),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 8),
          Text(
            '💡 Try saying "add bread" or "add 2 milk" to add items with voice!',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[500],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionChip extends StatelessWidget {
  final String suggestion;
  final VoidCallback onTap;

  const _SuggestionChip({
    required this.suggestion,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(            // When we click on a suggestions it trigger the OnTap callback which is passed to it
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.orange[50],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.orange[200]!,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 16,
              color: Colors.orange[600],
            ),
            const SizedBox(width: 6),
            Text(
              suggestion,
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
