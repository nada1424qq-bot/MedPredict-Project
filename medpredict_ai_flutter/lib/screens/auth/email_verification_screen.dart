import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../configurations/theme/app_colors.dart';
import '../../configurations/theme/app_typography.dart';
import '../../services/auth_service.dart';
import '../../widgets/custom_button.dart';

class EmailVerificationScreen extends ConsumerStatefulWidget {
  final String email;

  const EmailVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  ConsumerState<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState
    extends ConsumerState<EmailVerificationScreen>
    with TickerProviderStateMixin {
  Timer? _pollingTimer;
  Timer? _cooldownTimer;
  int _cooldownSeconds = 0;
  bool _isVerified = false;
  bool _isCheckingVerification = false;
  bool _isResending = false;
  late AnimationController _pulseController;
  late AnimationController _successController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Start auto-polling every 3 seconds
    _startPolling();
    // Start initial cooldown (just sent during registration)
    _startCooldown();
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _cooldownTimer?.cancel();
    _pulseController.dispose();
    _successController.dispose();
    super.dispose();
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (_) async {
      if (_isVerified) return;
      await _checkVerification();
    });
  }

  Future<void> _checkVerification() async {
    if (_isCheckingVerification) return;

    setState(() => _isCheckingVerification = true);

    final authService = ref.read(authServiceProvider);
    final verified = await authService.checkEmailVerified();

    if (mounted) {
      setState(() => _isCheckingVerification = false);

      if (verified) {
        _pollingTimer?.cancel();
        setState(() => _isVerified = true);
        _successController.forward();

        // Wait for success animation, then navigate
        await Future.delayed(const Duration(seconds: 2));
        if (mounted) {
          // Sign out so user logs in fresh with verified account
          await authService.logout();
          if (mounted) {
            context.go('/login');
          }
        }
      }
    }
  }

  void _startCooldown() {
    setState(() => _cooldownSeconds = 60);
    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _cooldownSeconds--;
          if (_cooldownSeconds <= 0) {
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendEmail() async {
    if (_cooldownSeconds > 0 || _isResending) return;

    setState(() => _isResending = true);

    try {
      final authService = ref.read(authServiceProvider);
      await authService.sendVerificationEmail();

      if (mounted) {
        setState(() => _isResending = false);
        _startCooldown();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text('Verification email sent!'),
              ],
            ),
            backgroundColor: AppColors.success,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isResending = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to resend: ${e.toString()}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  String _maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return email;
    return '${name[0]}${'•' * (name.length - 2)}${name[name.length - 1]}@$domain';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary.withOpacity(0.05),
              AppColors.background,
              AppColors.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const SizedBox(height: 40),

                // ── Back Button ──
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () async {
                      // Sign out and go back to welcome
                      final authService = ref.read(authServiceProvider);
                      await authService.logout();
                      if (mounted) context.go('/');
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          size: 18, color: AppColors.textPrimary),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // ── Animated Mail Icon ──
                _buildMailIcon(),

                const SizedBox(height: 32),

                // ── Title & Description ──
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _isVerified
                      ? _buildVerifiedContent()
                      : _buildPendingContent(),
                ),

                const SizedBox(height: 40),

                // ── Action Buttons ──
                if (!_isVerified) ...[
                  // Resend Button
                  CustomButton(
                    text: _cooldownSeconds > 0
                        ? 'Resend in ${_cooldownSeconds}s'
                        : 'Resend Verification Email',
                    onPressed: _cooldownSeconds > 0 ? () {} : _resendEmail,
                    isLoading: _isResending,
                    backgroundColor: _cooldownSeconds > 0
                        ? AppColors.divider
                        : AppColors.primary,
                  ),

                  const SizedBox(height: 16),

                  // Open Email App hint
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline,
                            color: AppColors.primary, size: 20),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Open your email app and click the verification link to continue.',
                            style:
                                AppTypography.textTheme.bodySmall?.copyWith(
                              color: AppColors.primaryDark,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),

                  const SizedBox(height: 24),

                  // Polling Status Indicator
                  _buildPollingIndicator(),

                  const SizedBox(height: 32),

                  // Change Email / Start Over
                  TextButton(
                    onPressed: () async {
                      final authService = ref.read(authServiceProvider);
                      await authService.logout();
                      if (mounted) context.go('/register');
                    },
                    child: Text(
                      'Use a different email?',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMailIcon() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _isVerified ? 1.0 : (1.0 + _pulseController.value * 0.05),
          child: child,
        );
      },
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        child: _isVerified
            ? Container(
                key: const ValueKey('verified'),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.success,
                      AppColors.success.withOpacity(0.8),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.success.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              )
                .animate(controller: _successController)
                .scale(begin: const Offset(0, 0), end: const Offset(1, 1),
                    curve: Curves.elasticOut, duration: 800.ms)
            : Container(
                key: const ValueKey('pending'),
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.15),
                      blurRadius: 25,
                      spreadRadius: 8,
                    ),
                  ],
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(
                      Icons.mark_email_unread_rounded,
                      size: 56,
                      color: AppColors.primary,
                    ),
                    // Small notification dot
                    Positioned(
                      top: 24,
                      right: 28,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms).scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1, 1),
                duration: 500.ms,
                curve: Curves.easeOutBack),
      ),
    );
  }

  Widget _buildPendingContent() {
    return Column(
      key: const ValueKey('pending_content'),
      children: [
        Text(
          'Verify Your Email',
          style: AppTypography.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.2),
        const SizedBox(height: 12),
        Text(
          'We\'ve sent a verification link to',
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 200.ms),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            _maskEmail(widget.email),
            style: AppTypography.textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
        const SizedBox(height: 12),
        Text(
          'Click the link in the email to activate your account.',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 400.ms),
      ],
    );
  }

  Widget _buildVerifiedContent() {
    return Column(
      key: const ValueKey('verified_content'),
      children: [
        Text(
          'Email Verified! 🎉',
          style: AppTypography.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.success,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),
        const SizedBox(height: 12),
        Text(
          'Your account has been verified successfully.\nRedirecting to login...',
          style: AppTypography.textTheme.bodyLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 300.ms),
        const SizedBox(height: 24),
        SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColors.success,
          ),
        ).animate().fadeIn(delay: 600.ms),
      ],
    );
  }

  Widget _buildPollingIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 14,
          height: 14,
          child: _isCheckingVerification
              ? const CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                )
              : Icon(
                  Icons.wifi_protected_setup_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
        ),
        const SizedBox(width: 8),
        Text(
          _isCheckingVerification
              ? 'Checking verification status...'
              : 'Auto-checking every 3 seconds',
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}
