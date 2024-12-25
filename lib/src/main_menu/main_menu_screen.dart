import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/rough/button.dart';
import '../style/delayed_appear.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.watch<Palette>();

    return Scaffold(
      backgroundColor: palette.redPen,
      body: ResponsiveScreen(
        mainAreaProminence: 0.45,
        squarishMainArea: DelayedAppear(
          ms: 1000,
          child: Center(
            child: Transform.scale(
              scale: 1,
              child: Image.asset(
                'assets/images/main-menu.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        rectangularMenuArea: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DelayedAppear(
              ms: 800,
              child: RoughButton(
                onTap: () {
                  GoRouter.of(context).go('/play');
                },
                drawRectangle: true,
                textColor: palette.redPen,
                fontSize: 42,
                child: const Text('Play'),
              ),
            ),
            _gap,
            DelayedAppear(
              ms: 400,
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/store'),
                child: const Text('Store'),
              ),
            ),
            _gap,
            DelayedAppear(
              ms: 200,
              child: RoughButton(
                onTap: () => GoRouter.of(context).go('/settings'),
                child: const Text('Settings'),
              ),
            ),
            _gap,
          ],
        ),
      ),
    );
  }

  /// Prevents the game from showing game-services-related menu items
  /// until we're sure the player is signed in.
  ///
  /// This normally happens immediately after game start, so players will not
  /// see any flash. The exception is folks who decline to use Game Center
  /// or Google Play Game Services, or who haven't yet set it up.
  Widget _hideUntilReady({required Widget child, required Future<bool> ready}) {
    return FutureBuilder<bool>(
      future: ready,
      builder: (context, snapshot) {
        return AnimatedOpacity(
          duration: const Duration(milliseconds: 700),
          opacity: snapshot.hasData ? 1 : 0,
          child: child,
        );
      },
    );
  }

  static const _gap = SizedBox(height: 12);
}
