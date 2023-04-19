import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Project {
  String name;
  int row;
  int stitch;

  Project(this.name, [this.row = 0, this.stitch = 0]);

  Map<String, Object?> toMap() => {
        'name': name,
        'row': row,
        'stitch': stitch,
      };
}

class StitchDb {
  final SharedPreferences prefs;

  static StitchDb? _instance;
  static Future<StitchDb> get instance async {
    _instance ??= StitchDb(await SharedPreferences.getInstance());
    return _instance!;
  }

  StitchDb(this.prefs);

  Future<Map<String, Project>> all() async {
    final str = prefs.getString('projects') ?? '{}';
    final map = json.decode(str) as Map<String, dynamic>;
    return {
      for (final x in map.keys)
        x: Project(map[x]['name'], map[x]['row'], map[x]['stitch']),
    };
  }

  Future<void> update(Project project) async {
    final map = await all();
    map[project.name] = project;
    final str = json.encode({
      for (final e in map.entries) e.key: e.value.toMap(),
    });
    prefs.setString('projects', str);
  }

  Future<void> delete(String name) async {
    final map = await all();
    map.remove(name);
    final str = json.encode({
      for (final e in map.entries) e.key: e.value.toMap(),
    });
    prefs.setString('projects', str);
  }
}
