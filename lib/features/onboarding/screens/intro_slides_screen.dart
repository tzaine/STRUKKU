// lib/features/onboarding/screens/intro_slides_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class IntroSlidesScreen extends StatefulWidget {
  const IntroSlidesScreen({super.key});

  @override
  State<IntroSlidesScreen> createState() => _IntroSlidesScreenState();
}

class _IntroSlidesScreenState extends State<IntroSlidesScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<_SlideData> _slides = const [
    _SlideData(
      icon: Icons.document_scanner_outlined,
      title: 'Scan Sekali,\nSimpan Selamanya',
      subtitle: 'Scan struk belanjamu dalam\nhitungan detik.',
    ),
    _SlideData(
      icon: Icons.folder_outlined,
      title: 'Semua Tersimpan\nRapi & Teratur',
      subtitle: 'Semua struk tersimpan rapi,\nkapan saja bisa diakses.',
    ),
    _SlideData(
      icon: Icons.alarm_outlined,
      title: 'Jangan Lewatkan\nMasa Garansi',
      subtitle: 'Jangan lewatkan masa garansi\ndan retur produkmu.',
      isLast: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // ─── Page view ───────────────────────────────────────────────────
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (_, i) => _SlidePage(data: _slides[i]),
              ),
            ),

            // ─── Indicators ──────────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _slides.length,
                (i) => AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _currentPage ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? AppColors.accent
                        : AppColors.border,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ─── Actions ─────────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: _currentPage == _slides.length - 1
                  ? ElevatedButton(
                      onPressed: () => context.go('/onboarding/name'),
                      child: const Text('Mulai →'),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.go('/onboarding/name'),
                          child: Text(
                            'Lewati',
                            style: AppTypography.body
                                .copyWith(color: AppColors.textSecondary),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _controller.nextPage(
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeOut,
                          ),
                          child: Row(
                            children: [
                              Text(
                                'Geser untuk lanjut',
                                style: AppTypography.caption,
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward,
                                  size: 14,
                                  color: AppColors.textSecondary),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),

            // ─── App branding ─────────────────────────────────────────────
            const SizedBox(height: 24),
            Text(
              'Strukku',
              style: AppTypography.sectionTitle
                  .copyWith(color: AppColors.accent),
            ),
            Text(
              'Simpan struk. Jangan kehilangan hak klaim.',
              style: AppTypography.caption,
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _SlidePage extends StatelessWidget {
  final _SlideData data;
  const _SlidePage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: AppColors.border, width: 0.5),
            ),
            child: Icon(data.icon, size: 72, color: AppColors.accent),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: AppTypography.pageTitle.copyWith(fontSize: 26),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            style: AppTypography.body
                .copyWith(color: AppColors.textSecondary, height: 1.6),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SlideData {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

  const _SlideData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });
}
