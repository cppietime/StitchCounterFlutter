import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:stitch_counter/data/database.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Project>? _projects;
  StitchDb? _db;

  @override
  void initState() {
    super.initState();
    _getProjects();
  }

  void _getProjects() async {
    _db = await StitchDb.instance;
    _projects = (await _db?.all())?.values.toList();
    setState(() {});
  }

  void _addProject(BuildContext context) async {
    TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Name new project'),
        content: TextField(
          controller: controller,
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                Navigator.pop(context);
              });
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (_projects
                      ?.map((p) => p.name)
                      .toSet()
                      .contains(controller.text) ==
                  false) {
                final p = Project(controller.text);
                await _db?.update(p);
                _projects = (await _db?.all())?.values.toList();
                if (mounted) {
                  setState(() {
                    context.pop();
                    context.push('/project',
                        extra: [_db!, p]).then((value) => _getProjects());
                  });
                }
              } else if (mounted) {
                setState(() {
                  context.pop();
                });
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteProject(String name) async {
    await _db?.delete(name);
    _projects = (await _db?.all())?.values.toList();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Projects'),
      ),
      body: Builder(
        builder: (context) {
          if (_projects == null) {
            return const Text('Waiting...');
          } else if (_projects?.isEmpty == true) {
            return TextButton(
              onPressed: () => _addProject(context),
              child: Text('No projects yet. Add one now?',
                  style: Theme.of(context).textTheme.displayMedium),
            );
          } else {
            return Center(
              child: ListView(
                children: [
                  for (final project in _projects!)
                    ListTile(
                        title: TextButton(
                          child: Text(
                            '${project.name}: ${project.row}(${project.stitch})',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          onPressed: () => context.push('/project',
                              extra: [_db!, project]).then((value) {
                            _getProjects();
                          }),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _deleteProject(project.name),
                        ))
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addProject(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
