import 'package:flutter/foundation.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/features/home/home_texts.dart';

class HomeCategory {
  const HomeCategory({required this.label, this.asset});

  final String label;
  final String? asset;
}

class HomeBrand {
  const HomeBrand({required this.label, required this.asset});

  final String label;
  final String asset;
}

class HomeProduct {
  const HomeProduct({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.variant,
    required this.price,
    required this.originalPrice,
    required this.discount,
  });

  final String image;
  final String title;
  final String subtitle;
  final String variant;
  final String price;
  final String originalPrice;
  final String discount;
}

class HomeViewModel extends ChangeNotifier {
  int tabIndex = 0;

  static const categories = [
    HomeCategory(label: HomeTexts.allProduct, asset: AppAssets.allProducts),
    HomeCategory(label: HomeTexts.babyCare, asset: AppAssets.babyCare),
    HomeCategory(label: HomeTexts.personalCare, asset: AppAssets.personalCare),
    HomeCategory(label: HomeTexts.nutritional, asset: AppAssets.nutritional),
    HomeCategory(label: HomeTexts.skinCare, asset: AppAssets.skinCare),
    HomeCategory(label: HomeTexts.wellness),
  ];

  static const brands = [
    HomeBrand(label: HomeTexts.minimalist, asset: AppAssets.minimalist),
    HomeBrand(label: HomeTexts.prohance, asset: AppAssets.prohance),
    HomeBrand(label: HomeTexts.horlicks, asset: AppAssets.horlicks),
    HomeBrand(label: HomeTexts.pilgrim, asset: AppAssets.pilgrim),
    HomeBrand(label: HomeTexts.vaseline, asset: AppAssets.vaseline),
  ];

  static const products = [
    HomeProduct(
      image: AppAssets.himalaya,
      title: HomeTexts.himalayaTitle,
      subtitle: HomeTexts.himalayaSubtitle,
      variant: HomeTexts.himalayaVariant,
      price: HomeTexts.himalayaPrice,
      originalPrice: HomeTexts.himalayaOriginal,
      discount: HomeTexts.himalayaDiscount,
    ),
    HomeProduct(
      image: AppAssets.diataal,
      title: HomeTexts.diataalTitle,
      subtitle: HomeTexts.diataalSubtitle,
      variant: HomeTexts.diataalVariant,
      price: HomeTexts.diataalPrice,
      originalPrice: HomeTexts.diataalOriginal,
      discount: HomeTexts.diataalDiscount,
    ),
  ];

  void selectTab(int index) {
    if (tabIndex == index) return;
    tabIndex = index;
    notifyListeners();
  }
}
