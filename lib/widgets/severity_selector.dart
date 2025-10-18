import 'package:flutter/material.dart';

class SeveritySelector extends StatelessWidget {
  final int severity;
  final ValueChanged<int> onSeverityChanged;

  const SeveritySelector({
    super.key,
    required this.severity,
    required this.onSeverityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(11, (index) {
        return GestureDetector(
          onTap: () => onSeverityChanged(index),
          child: CircleAvatar(
            radius: 15,
            backgroundColor: index <= severity
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.surfaceVariant,
            child: Text(
              index.toString(),
              style: TextStyle(
                color: index <= severity
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }),
    );
  }
}