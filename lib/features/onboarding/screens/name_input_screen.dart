// lib/features/onboarding/screens/name_input_screen.dart  [SCREEN 01]
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../providers/onboarding_provider.dart';

class NameInputScreen extends ConsumerStatefulWidget {
  const NameInputScreen({super.key});

  @override
  ConsumerState<NameInputScreen> createState() => _NameInputScreenState();
}

class _NameInputScreenState extends ConsumerState<NameInputScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameCtrl = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isLoading = false;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _fadeCtrl.forward();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _focusNode.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      _focusNode.requestFocus();
      return;
    }

    setState(() => _isLoading = true);
    final prefs = await ref.read(preferencesServiceProvider.future);
    await prefs.setUserName(name);
    await prefs.completeOnboarding();

    ref.read(userNameProvider.notifier).state = name;
    ref.read(isOnboardingDoneProvider.notifier).state = true;

    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(flex: 2),

                // ─── Logo ──────────────────────────────────────────────────
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Strukku',
                        style: AppTypography.pageTitle
                            .copyWith(color: AppColors.accent),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Foto struk, simpan tenang.',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                ),

                const Spacer(flex: 2),

                // ─── Illustration ──────────────────────────────────────────
                Center(
                  child: _ReceiptIllustration(),
                ),

                const Spacer(flex: 2),

                // ─── Name field ────────────────────────────────────────────
                Text(
                  'Nama kamu siapa?',
                  style: AppTypography.sectionTitle,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _nameCtrl,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.words,
                  style: AppTypography.body,
                  decoration: const InputDecoration(
                    hintText: 'Masukkan nama kamu',
                    prefixIcon: Icon(Icons.person_outline_rounded,
                        color: AppColors.textSecondary, size: 20),
                  ),
                  onSubmitted: (_) => _submit(),
                  textInputAction: TextInputAction.done,
                ),

                const SizedBox(height: 20),

                // ─── CTA ──────────────────────────────────────────────────
                ListenableBuilder(
                  listenable: _nameCtrl,
                  builder: (_, __) => ElevatedButton(
                    onPressed: _nameCtrl.text.trim().isNotEmpty && !_isLoading
                        ? _submit
                        : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text('Mulai Pakai Strukku'),
                  ),
                ),

                const Spacer(flex: 1),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Minimalist receipt illustration ──────────────────────────────────────────
class _ReceiptIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      height: 180,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 12,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 10),
          ...List.generate(
            5,
            (i) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      height: 8,
                      decoration: BoxDecoration(
                        color: i == 2
                            ? AppColors.accentLight
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 32,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          Container(
            height: 1.5,
            color: AppColors.border,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 40,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Container(
                width: 48,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
