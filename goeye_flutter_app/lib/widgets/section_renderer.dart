import 'package:flutter/material.dart';
import '../models/section_model.dart';
import 'hero_banner_widget.dart';
import 'hero_slider_widget.dart';
import 'product_grid_widget.dart';
import 'collection_list_widget.dart';
import 'announcement_widget.dart';
import 'announcement_bars_widget.dart';
import 'app_header_widget.dart';
import 'moving_usp_strip_widget.dart';
import 'category_grid_widget.dart';
import 'gender_categories_widget.dart';
import 'special_collection_widget.dart';
import 'eyewear_collection_cards_widget.dart';
import 'featured_products_widget.dart';
import 'offers_grid_widget.dart';
import 'trust_badges_widget.dart';
import 'instagram_stories_widget.dart';
import 'footer_widget.dart';
// FIRELENS-STYLE SECTIONS
import 'homepage_feature_section.dart';
import 'homepage_stats_section.dart';
import 'homepage_video_section.dart';
import 'homepage_faq_section.dart';
// NEW SECTIONS FROM GOEYE.IN
import 'circular_categories_widget.dart';
import 'video_slider_widget.dart';
import 'best_selling_collection_widget.dart';

class SectionRenderer extends StatelessWidget {
  final Section section;

  const SectionRenderer({super.key, required this.section});

  @override
  Widget build(BuildContext context) {
    switch (section.type) {
      // Original sections
      case 'hero':
        return HeroBannerWidget(settings: section.settings);
      
      case 'product_grid':
        return ProductGridWidget(settings: section.settings);
      
      case 'collection_list':
        return CollectionListWidget(settings: section.settings);
      
      case 'announcement':
        return AnnouncementWidget(settings: section.settings);
      
      // New sections matching goeye.in (New BOGO Theme)
      case 'app_header':
        // Skip app_header section - using Flutter AppBar instead
        return const SizedBox.shrink();
      
      case 'announcement_bars':
        return AnnouncementBarsWidget(settings: section.settings);
      
      case 'moving_usp_strip':
        return MovingUspStripWidget(settings: section.settings);
      
      // NEW: Circular Categories Section (5 circles)
      case 'circular_categories':
        return CircularCategoriesWidget(settings: section.settings);
      
      case 'hero_slider':
        return HeroSliderWidget(settings: section.settings);
      
      // NEW: Video Slider Section
      case 'video_slider':
        return VideoSliderWidget(settings: section.settings);
      
      case 'category_grid':
        // Hide category grid (4 boxes) - per user request
        return const SizedBox.shrink();
      
      case 'gender_categories':
        return GenderCategoriesWidget(settings: section.settings);
      
      case 'special_collection':
        return SpecialCollectionWidget(settings: section.settings);
      
      case 'eyewear_collection_cards':
        return EyewearCollectionCardsWidget(settings: section.settings);
      
      case 'best_selling_collection':
        return BestSellingCollectionWidget(settings: section.settings);
      
      case 'featured_products':
        return FeaturedProductsWidget(settings: section.settings);
      
      case 'offers_grid':
        return OffersGridWidget(settings: section.settings);
      
      case 'trust_badges':
        return TrustBadgesWidget(settings: section.settings);
      
      case 'instagram_stories':
        return InstagramStoriesWidget(settings: section.settings);
      
      // NEW FIRELENS-STYLE SECTIONS
      case 'homepage_features':
        return const HomepageFeatureSection();
      
      case 'homepage_stats':
        return const HomepageStatsSection();
      
      case 'homepage_video':
        return const HomepageVideoSection();
      
      case 'homepage_faq':
        return const HomepageFAQSection();
      
      case 'footer':
        return const FooterWidget();
      
      default:
        // Fallback for unknown section types
        return Container(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Unknown section type: ${section.type}',
            style: const TextStyle(color: Colors.grey),
          ),
        );
    }
  }
}

