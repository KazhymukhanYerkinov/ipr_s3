import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_by_date.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_by_name.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_by_size.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_by_type.dart';
import 'package:ipr_s3/features/files/domain/strategies/sort_strategy.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_bloc.dart';
import 'package:ipr_s3/features/files/presentation/bloc/files_event.dart';

class SortDropdown extends StatelessWidget {
  const SortDropdown({super.key});

  static final List<SortStrategy> _strategies = [
    SortByDate(),
    SortByName(),
    SortBySize(),
    SortByType(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<SortStrategy>(
      icon: const Icon(Icons.sort_rounded),
      tooltip: 'Sort',
      onSelected: (strategy) =>
          context.read<FilesBloc>().add(SortStrategyChanged(strategy)),
      itemBuilder: (_) => _strategies
          .map((s) => PopupMenuItem(
                value: s,
                child: Text(s.label),
              ))
          .toList(),
    );
  }
}
