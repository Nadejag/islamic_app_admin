import 'package:flutter/material.dart';

import '../../../shared/widgets/admin_scaffold.dart';
import '../../../shared/widgets/section_card.dart';
import '../../../shared/widgets/workflow_card.dart';

class AiLogsPage extends StatelessWidget {
  const AiLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AdminScaffold(
      title: 'AI Monitoring',
      body: _AiLogsBody(),
    );
  }
}

class _AiLogsBody extends StatelessWidget {
  const _AiLogsBody();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SectionCard(
          title: 'AI Questions Log',
          action: OutlinedButton(onPressed: () {}, child: const Text('Flag Incorrect Response')),
          child: const Text('Track question-response pairs and misuse indicators.'),
        ),
        SizedBox(height: 12),
        SectionCard(
          title: 'AI Disclaimer',
          action: FilledButton(onPressed: () {}, child: const Text('Edit')),
          child: const Text('Central disclaimer text for all AI responses.'),
        ),
        SizedBox(height: 12),
        WorkflowCard(
          title: 'AI Oversight Workflow',
          steps: [
            'Review user prompts and generated responses',
            'Flag incorrect/unsafe outputs and categorize misuse type',
            'Update disclaimer and model-use policy text',
            'Escalate repeated violations to trust and safety',
          ],
        ),
      ],
    );
  }
}
