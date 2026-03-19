import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';

class ArticlesScreen extends StatelessWidget {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.articleTheme,
      child: Scaffold(
        backgroundColor: AppColors.articleBg,
        drawer: const AppDrawer(),
        body: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.articleBg,
                    elevation: 0,
                    expandedHeight: 110,
                    floating: true,
                    leading: Builder(
                      builder: (ctx) => IconButton(
                        icon: const Icon(Icons.menu_rounded, color: AppColors.articleAccent1),
                        onPressed: () => Scaffold.of(ctx).openDrawer(),
                      ),
                    ),
                    flexibleSpace: const FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                      title: Text('Articles',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.articleAccent1)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(height: 2, color: AppColors.articleAccent2),
                        const SizedBox(height: 24),

                        Text('Past Projects',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                color: AppColors.articleAccent1.withOpacity(0.6), letterSpacing: 1.2)),
                        const SizedBox(height: 16),

                        // Horizontal article cards
                        SizedBox(
                          height: 160,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 4,
                            separatorBuilder: (_, __) => const SizedBox(width: 12),
                            itemBuilder: (context, i) {
                              if (i == 3) {
                                return GestureDetector(
                                  onTap: () => Navigator.pushNamed(context, '/create-project'),
                                  child: Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      color: AppColors.articleSurface,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(color: AppColors.articleAccent1.withOpacity(0.3)),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add_rounded, color: AppColors.articleAccent1, size: 32),
                                        const SizedBox(height: 8),
                                        Text('Add new', style: TextStyle(color: AppColors.articleAccent1.withOpacity(0.7), fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              final titles = ['ArticleCraft Deep Dive', 'Affiliate Myths', 'Writing Income'];
                              return Container(
                                width: 140,
                                decoration: BoxDecoration(
                                  color: AppColors.articleSurface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.articleAccent2.withOpacity(0.5)),
                                ),
                                padding: const EdgeInsets.all(14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: AppColors.articleAccent1.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(child: Icon(Icons.article_rounded, color: AppColors.articleAccent1, size: 28)),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(titles[i], maxLines: 2, overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(color: AppColors.articleText, fontSize: 12, fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                    Text('1,200 words', style: TextStyle(color: AppColors.articleAccent1.withOpacity(0.7), fontSize: 11)),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 28),

                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/create-project'),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              color: AppColors.articleAccent1,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('New Article', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
            const PersistentAudioBar(),
          ],
        ),
      ),
    );
  }
}
