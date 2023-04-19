import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/database.dart';

class ProjectScreen extends StatefulWidget {
  final StitchDb db;
  final Project project;

  ProjectScreen(this.db, this.project, {super.key});

  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen> {
  final _rowController = TextEditingController();
  final _stitchController = TextEditingController();

  Future<void> _update() async {
    widget.project.row = max(widget.project.row, 0);
    widget.project.stitch = max(widget.project.stitch, 0);
    await widget.db.update(widget.project);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _syncText() async {
    widget.project.row =
        int.tryParse(_rowController.text) ?? widget.project.row;
    widget.project.stitch =
        int.tryParse(_stitchController.text) ?? widget.project.stitch;
    return _update();
  }

  Future<void> _delete() async {
    await widget.db.delete(widget.project.name);
    if (mounted) {
      context.pop(1);
    }
  }

  @override
  Widget build(BuildContext context) {
    _rowController.text = widget.project.row.toString();
    _stitchController.text = widget.project.stitch.toString();
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.project.name),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Row:',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    widget.project.row--;
                    _update();
                  },
                  icon: const Icon(Icons.remove_outlined),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _rowController,
                    onChanged: (value) => _syncText,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.project.row++;
                    _update();
                  },
                  icon: const Icon(Icons.add_outlined),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.background),
                  onPressed: () {
                    widget.project.row = 0;
                    _update();
                  },
                  child: Text(
                    'Reset',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    widget.project.row++;
                    widget.project.stitch = 0;
                    _update();
                  },
                  style: TextButton.styleFrom(
                      backgroundColor:
                          Theme.of(context).colorScheme.background),
                  child: Text(
                    'Next Row',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            Text(
              'Stitch:',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    widget.project.stitch--;
                    _update();
                  },
                  icon: const Icon(Icons.remove_outlined),
                ),
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _stitchController,
                    onChanged: (value) => _syncText,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    widget.project.stitch++;
                    _update();
                  },
                  icon: const Icon(Icons.add_outlined),
                ),
              ],
            ),
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.background),
              onPressed: () {
                widget.project.stitch = 0;
                _update();
              },
              child: Text(
                'Reset',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outlined),
              onPressed: () => _delete(),
            ),
          ],
        ),
      ),
    );
  }
}
