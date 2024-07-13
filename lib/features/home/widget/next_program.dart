import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spa_app/features/program/cubit/program_cubit.dart';
import 'package:spa_app/routes.dart';
import 'package:spa_app/shared/widgets/primary_card.dart';

class NextProgramWidget extends StatelessWidget {
  NextProgramWidget({super.key});

  final DateTime targetDate = DateTime(2024, 7, 20);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProgramCubit, ProgramState>(
      bloc: BlocProvider.of<ProgramCubit>(context),
      builder: (context, programState) {
        if (programState.nextActivity == null) {
          return Container();
        }

        var nextActivityDateDiff =
            programState.nextActivity!.date!.difference(DateTime.now());

        return SizedBox(
          width: double.infinity,
          child: PrimaryCardWidget(
            onTap: () => Navigator.pushNamed(context, Routes.program),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(
                    programState.nextActivity!.title!,
                    style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                  if (nextActivityDateDiff.inMinutes < 90)
                    Text(
                      'Over ${nextActivityDateDiff.inMinutes} minuten',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  if (nextActivityDateDiff.inMinutes > 90)
                    Text(
                      'Over ${nextActivityDateDiff.inHours} uur',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
