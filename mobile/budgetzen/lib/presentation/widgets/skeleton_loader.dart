import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class SkeletonContainer extends StatefulWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const SkeletonContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  State<SkeletonContainer> createState() => _SkeletonContainerState();
}

class _SkeletonContainerState extends State<SkeletonContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: widget.borderRadius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.lightGrey,
                AppColors.lightGrey.withOpacity(0.5),
                AppColors.lightGrey,
              ],
              stops: [0.0, _animation.value, 1.0],
            ),
          ),
        );
      },
    );
  }
}

class TransactionSkeletonCard extends StatelessWidget {
  const TransactionSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon skeleton
          SkeletonContainer(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(24),
          ),

          const SizedBox(width: 12),

          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const SkeletonContainer(width: 120, height: 16),
                const SizedBox(height: 8),
                // Subtitle
                const SkeletonContainer(width: 80, height: 12),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Amount skeleton
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SkeletonContainer(width: 80, height: 16),
              const SizedBox(height: 4),
              const SkeletonContainer(width: 60, height: 12),
            ],
          ),
        ],
      ),
    );
  }
}

class CategorySkeletonCard extends StatelessWidget {
  const CategorySkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon skeleton
          SkeletonContainer(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),

          const SizedBox(height: 12),

          // Title skeleton
          const SkeletonContainer(width: 60, height: 12),

          const SizedBox(height: 8),

          // Amount skeleton
          const SkeletonContainer(width: 80, height: 14),
        ],
      ),
    );
  }
}

class StatsSkeletonCard extends StatelessWidget {
  const StatsSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title skeleton
          const SkeletonContainer(width: 100, height: 14),

          const SizedBox(height: 16),

          // Main amount skeleton
          const SkeletonContainer(width: 150, height: 24),

          const SizedBox(height: 12),

          // Subtitle skeleton
          const SkeletonContainer(width: 120, height: 12),
        ],
      ),
    );
  }
}

class ChartSkeletonCard extends StatelessWidget {
  const ChartSkeletonCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title skeleton
            const SkeletonContainer(width: 120, height: 16),

            const SizedBox(height: 20),

            // Chart bars skeleton
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SkeletonContainer(
                    width: 20,
                    height: 80,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SkeletonContainer(
                    width: 20,
                    height: 120,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SkeletonContainer(
                    width: 20,
                    height: 60,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SkeletonContainer(
                    width: 20,
                    height: 100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SkeletonContainer(
                    width: 20,
                    height: 40,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  SkeletonContainer(
                    width: 20,
                    height: 90,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ListSkeletonLoader extends StatelessWidget {
  final int itemCount;
  final Widget skeletonItem;

  const ListSkeletonLoader({
    super.key,
    this.itemCount = 5,
    required this.skeletonItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => skeletonItem,
    );
  }
}

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          // Header skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SkeletonContainer(width: 80, height: 14),
                    const SizedBox(height: 8),
                    const SkeletonContainer(width: 120, height: 20),
                  ],
                ),
                SkeletonContainer(
                  width: 40,
                  height: 40,
                  borderRadius: BorderRadius.circular(20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Stats cards skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Expanded(child: StatsSkeletonCard()),
                const SizedBox(width: 12),
                const Expanded(child: StatsSkeletonCard()),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Chart skeleton
          const ChartSkeletonCard(),

          const SizedBox(height: 24),

          // Categories title skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonContainer(width: 100, height: 18),
                SkeletonContainer(width: 60, height: 14),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Categories horizontal list skeleton
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 4,
              itemBuilder: (context, index) =>
                  const SizedBox(width: 100, child: CategorySkeletonCard()),
            ),
          ),

          const SizedBox(height: 24),

          // Recent transactions title skeleton
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SkeletonContainer(width: 150, height: 18),
                SkeletonContainer(width: 80, height: 14),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Transactions list skeleton
          ListSkeletonLoader(
            itemCount: 3,
            skeletonItem: const TransactionSkeletonCard(),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
