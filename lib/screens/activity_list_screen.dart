
import 'package:material_ui/material_ui.dart';
import '../models/activity.dart';

class ActivityListScreen extends StatefulWidget {
  const ActivityListScreen({super.key});

  @override
  State<ActivityListScreen> createState() {
    return _ActivityListScreenState();
  }
}

class _ActivityListScreenState extends State<ActivityListScreen> {
  List<Activity> activities = [];

  final controller = TextEditingController();

  void addActivity() {
    controller.clear();
    bool isImportant = false;

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, updateDialog) => AlertDialog(
          title: const Text('New Activity'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  labelText: 'Activity title',
                ),
              ),
              CheckboxListTile(
                title: const Text('Important'),
                value: isImportant,
                onChanged: (value) {
                  updateDialog(() {
                    isImportant = value ?? false;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final title = controller.text.trim();

                if (title.isNotEmpty) {
                  setState(() {
                    activities.add(
                      Activity(
                        title,
                        isImportant: isImportant,
                      ),
                    );
                  });

                  Navigator.pop(dialogContext);
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void manageActivity(Activity activity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(activity.title),
        content: Text(
          activity.isImportant
              ? 'Important activity'
              : 'Normal activity',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                activity.completed = !activity.completed;
              });

              Navigator.pop(dialogContext);
            },
            child: Text(
              activity.completed
                  ? 'Mark as To do'
                  : 'Mark as Done',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              confirmDeleteActivity(activity);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void confirmDeleteActivity(Activity activity) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Activity'),
        content: const Text(
          'Are you sure you want to delete this activity?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                activities.remove(activity);
              });

              Navigator.pop(dialogContext);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedCount =
        activities.where((activity) => activity.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Activities'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Completed: $completedCount / ${activities.length}',
            ),
          ),
          Expanded(
            child: activities.isEmpty
                ? const Center(
              child: Text('No activities available'),
            )
                : ListView.builder(
              itemCount: activities.length,
              itemBuilder: (context, index) {
                final activity = activities[index];

                return ListTile(
                  leading: Icon(
                    activity.completed
                        ? Icons.check_circle
                        : Icons.assignment,
                  ),
                  title: Text(
                    activity.title,
                    style: TextStyle(
                      decoration: activity.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                  subtitle: Text(
                    activity.completed ? 'Done' : 'To do',
                  ),
                  trailing: activity.isImportant
                      ? const Icon(Icons.star)
                      : null,
                  onTap: () {
                    manageActivity(activity);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addActivity,
        child: const Icon(Icons.add),
      ),
    );
  }
}
