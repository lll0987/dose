import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: GridView.count(
        crossAxisCount: 8,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: [
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryFixedDim,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onPrimaryFixedVariant,
            ),
          ),
          // Container(
          //   height: 16,
          //   decoration: BoxDecoration(
          //     color: Theme.of(context).colorScheme.inversePrimary,
          //   ),
          // ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryFixedDim,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSecondaryFixedVariant,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiary,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiaryFixed,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiaryFixedDim,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onTertiaryFixedVariant,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.errorContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onErrorContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.outlineVariant,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.inverseSurface,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceBright,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainer,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLow,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerLowest,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceTint,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Colors.limeAccent),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).disabledColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).dividerColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).focusColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).highlightColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).hintColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).hoverColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).indicatorColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColorLight,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).secondaryHeaderColor,
            ),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).shadowColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(color: Theme.of(context).splashColor),
          ),
          Container(
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).unselectedWidgetColor,
            ),
          ),
        ],
      ),
    );
  }
}
