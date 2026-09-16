import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:task/core/constants/app_assets.dart';
import 'package:task/core/theme/app_colors.dart';
import 'package:task/core/widgets/fade_slide_in.dart';
import 'package:task/features/home/home_texts.dart';
import 'package:task/features/home/home_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();
    final isHome = vm.tabIndex == 0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isHome ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 280),
        color: isHome ? AppColors.splashBackground : Colors.white,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Curves.easeOutCubic,
            switchOutCurve: Curves.easeInCubic,
            child: KeyedSubtree(
              key: ValueKey(vm.tabIndex),
              child: isHome
                  ? const _HomeContent()
                  : _Placeholder(index: vm.tabIndex),
            ),
          ),
          bottomNavigationBar: const _BottomNav(),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FadeSlideIn(
          duration: Duration(milliseconds: 420),
          dy: 10,
          child: _Header(),
        ),
        Expanded(
          child: ClipRect(
            child: FadeSlideIn(
              delay: Duration(milliseconds: 60),
              duration: Duration(milliseconds: 460),
              dy: 14,
              child: _Feed(),
            ),
          ),
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.splashBackground,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 14),
          child: Column(
            children: [
              const _TopBar(),
              const SizedBox(height: 20),
              const _SearchBar(),
              const SizedBox(height: 15),
              const _LocationRow(),
              const SizedBox(height: 27),
              SizedBox(
                height: 82,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: EdgeInsets.zero,
                  itemCount: HomeViewModel.categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 19),
                  itemBuilder: (context, index) {
                    return _CategoryItem(
                      category: HomeViewModel.categories[index],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(AppAssets.homeLogo, height: 28, fit: BoxFit.contain),
        const Spacer(),
        const _PerceptionButton(),
        const SizedBox(width: 5.71),
        const _CartButton(),
      ],
    );
  }
}

class _CartButton extends StatelessWidget {
  const _CartButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.homeCartFill,
        borderRadius: BorderRadius.circular(54.47),
        border: Border.all(color: AppColors.homeCartBorder),
      ),
      child: const Icon(
        Icons.shopping_bag_outlined,
        color: Colors.white,
        size: 16,
      ),
    );
  }
}

class _PerceptionButton extends StatelessWidget {
  const _PerceptionButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      padding: const EdgeInsets.symmetric(horizontal: 11.54, vertical: 5.77),
      decoration: BoxDecoration(
        color: AppColors.continueButton,
        borderRadius: BorderRadius.circular(62.85),
      ),
      child: Row(
        children: [
          Image.asset(
            AppAssets.prescriptionIcon,
            width: 12,
            height: 13,
            color: Colors.white,
          ),
          const SizedBox(width: 6),
          Text(
            HomeTexts.perception,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontSize: 11.54,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatefulWidget {
  const _SearchBar();

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hintStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppColors.homeSearchHint,
      fontSize: 10,
      fontWeight: FontWeight.w400,
      height: 1,
      letterSpacing: 0,
    );

    return GestureDetector(
      onTap: () => _focusNode.requestFocus(),
      child: Container(
        width: double.infinity,
        height: 41,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, size: 13, color: AppColors.homeSearchIcon),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                focusNode: _focusNode,
                cursorColor: AppColors.continueButton,
                style: hintStyle?.copyWith(color: AppColors.homeTitle),
                onTapOutside: (_) => _focusNode.unfocus(),
                decoration: InputDecoration(
                  isDense: true,
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: HomeTexts.searchHint,
                  hintStyle: hintStyle,
                ),
              ),
            ),
            const Icon(
              Icons.photo_camera_outlined,
              size: 15,
              color: AppColors.homeCameraIcon,
            ),
            const SizedBox(width: 6),
            const Icon(
              Icons.mic_none_rounded,
              size: 15,
              color: AppColors.homeCameraIcon,
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationRow extends StatelessWidget {
  const _LocationRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: const Icon(
            Icons.location_on_rounded,
            size: 12,
            color: AppColors.continueButton,
          ),
        ),
        const SizedBox(width: 5),
        Flexible(
          child: Text(
            HomeTexts.location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ),
        const SizedBox(width: 7),
        const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 18,
          color: Colors.white,
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final HomeCategory category;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(11),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: category.asset == null
                ? const Icon(
                    Icons.spa_outlined,
                    size: 22,
                    color: AppColors.continueButton,
                  )
                : Image.asset(category.asset!, width: 30, height: 30),
          ),
          const SizedBox(height: 9),
          Text(
            category.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1,
              letterSpacing: 0,
            ),
          ),
        ],
      ),
    );
  }
}

class _Feed extends StatelessWidget {
  const _Feed();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.homeBody,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
          children: const [
            _Banner(),
            SizedBox(height: 25),
            _TopBrandsTitle(),
            SizedBox(height: 15),
            _BrandsRow(),
            SizedBox(height: 25),
            _TrendingHeader(),
            SizedBox(height: 20),
            _ProductsRow(),
          ],
        ),
      ),
    );
  }
}

class _Banner extends StatelessWidget {
  const _Banner();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15.53),
      child: Image.asset(
        AppAssets.homeBanner,
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class _TopBrandsTitle extends StatelessWidget {
  const _TopBrandsTitle();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1,
      letterSpacing: 0,
    );

    return Text.rich(
      TextSpan(
        text: HomeTexts.topBrandsLead,
        style: style?.copyWith(color: AppColors.continueButton),
        children: [
          TextSpan(
            text: HomeTexts.topBrandsTail,
            style: style?.copyWith(color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: AppColors.homeTitle,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1,
        letterSpacing: 0,
      ),
    );
  }
}

class _BrandsRow extends StatelessWidget {
  const _BrandsRow();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: HomeViewModel.brands.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return _BrandItem(brand: HomeViewModel.brands[index]);
        },
      ),
    );
  }
}

class _BrandItem extends StatelessWidget {
  const _BrandItem({required this.brand});

  final HomeBrand brand;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        children: [
          Container(
            width: 65,
            height: 65,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.homeCardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset(brand.asset, width: 54, height: 54),
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              brand.label,
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrendingHeader extends StatelessWidget {
  const _TrendingHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        const Expanded(child: _SectionTitle(HomeTexts.trendingNow)),
        Text(
          HomeTexts.viewAll,
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.viewAll,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1,
            letterSpacing: 0,
          ),
        ),
        const SizedBox(width: 4),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.continueButton,
          ),
          child: const Icon(Icons.arrow_forward, size: 10, color: Colors.white),
        ),
      ],
    );
  }
}

class _ProductsRow extends StatelessWidget {
  const _ProductsRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < HomeViewModel.products.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: _ProductCard(product: HomeViewModel.products[i])),
        ],
      ],
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final HomeProduct product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(color: AppColors.prductCardBorder),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 106,
            width: double.infinity,
            child: Image.asset(product.image, fit: BoxFit.contain),
          ),
          const SizedBox(height: 24.5),
          Row(
            children: [
              const Icon(
                Icons.star_rounded,
                size: 10,
                color: AppColors.continueButton,
              ),
              const SizedBox(width: 1),
              Text(
                HomeTexts.rating,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.productReview,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                HomeTexts.reviews,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.productReview,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            product.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.productTitle,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          Text(
            product.subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(
              color: AppColors.productTitle,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            product.variant,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.productTitle,
              fontSize: 10,
              fontWeight: FontWeight.w400,
              height: 1,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 5),
          const Divider(
            height: 1,
            thickness: 0.5,
            color: AppColors.productDivider,
          ),
          const SizedBox(height: 5),
          Row(
            children: [
              Text(
                '${HomeTexts.rupee} ${product.price}',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.continueButton,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 3),
              Text(
                product.originalPrice,
                style: textTheme.bodySmall?.copyWith(
                  color: AppColors.homeSearchHint,
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1,
                  decoration: TextDecoration.lineThrough,
                  decorationColor: AppColors.homeSearchHint,
                  letterSpacing: 0,
                ),
              ),
              const SizedBox(width: 3),
              Flexible(
                child: Text(
                  product.discount,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall?.copyWith(
                    color: AppColors.discount,
                    fontSize: 10,
                    fontWeight: FontWeight.w400,
                    height: 1,
                    letterSpacing: 0,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            height: 25,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: AppColors.continueButton,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                minimumSize: const Size(0, 32),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
                textStyle: textTheme.bodySmall?.copyWith(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  height: 0.9,
                  letterSpacing: 0,
                ),
              ),
              child: const Text(HomeTexts.addToCart),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeViewModel>();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.navBorder),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 74,
          child: Row(
            children: [
              _NavItem(
                icon: AppAssets.homeIcon,
                label: HomeTexts.home,
                selected: vm.tabIndex == 0,
                onTap: () => vm.selectTab(0),
              ),
              _NavItem(
                icon: AppAssets.categoriesIcon,
                label: HomeTexts.categories,
                selected: vm.tabIndex == 1,
                onTap: () => vm.selectTab(1),
              ),
              _NavItem(
                icon: AppAssets.offersIcon,
                label: HomeTexts.offers,
                selected: vm.tabIndex == 2,
                onTap: () => vm.selectTab(2),
              ),
              _NavItem(
                icon: AppAssets.profileIcon,
                label: HomeTexts.profile,
                selected: vm.tabIndex == 3,
                onTap: () => vm.selectTab(3),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconColor = selected
        ? AppColors.continueButton
        : AppColors.homeNavInactive;

    final textColor = selected
        ? AppColors.continueButton
        : AppColors.verifySubtitle;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.08 : 1,
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
                child: Image.asset(icon, width: 22, height: 22),
              ),
            ),
            const SizedBox(height: 9),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutCubic,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: textColor,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                height: 1,
              ),
              child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    const labels = [
      HomeTexts.home,
      HomeTexts.categories,
      HomeTexts.offers,
      HomeTexts.profile,
    ];

    return SafeArea(
      child: Center(
        child: Text(
          '${labels[index]}\n${HomeTexts.comingSoon}',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.homeTitle,
            fontSize: 16,
            fontWeight: FontWeight.w600,
            height: 1.4,
          ),
        ),
      ),
    );
  }
}
