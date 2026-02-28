import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
import '../model/tag.dart';
import '../model/relapse_log.dart';
import '../constants/colors.dart';
import '../constants/themes.dart';
import '../widgets/todo_item.dart';
import '../helpers/database_helper.dart';
import '../providers/theme_provider.dart';
import '../providers/locale_provider.dart';
import '../l10n/app_localizations.dart';
import 'archive_screen.dart';
import 'statistics_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<ToDo> todosList = [];
  late List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final _searchController = TextEditingController();
  final _costController = TextEditingController();
  late ConfettiController _confettiController;
  late AnimationController _animationController;

  // Filters
  List<String> _selectedTagIds = [];
  TodoPriority _selectedPriority = TodoPriority.medium;
  List<Tag> _allTags = [];

  // Phase 1 New Fields
  bool _isRecurring = true;
  DateTime? _eventDate;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fetchTodos();
    _fetchTags();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _todoController.dispose();
    _searchController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _fetchTodos() async {
    final todos = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      todosList = todos;
      _foundToDo = todos;
    });
  }

  Future<void> _fetchTags() async {
    final tags = await DatabaseHelper.instance.getAllTags();
    setState(() => _allTags = tags);
  }

  Future<void> _addTodo(String todo) async {
    if (todo.isEmpty) return;
    if (!_isRecurring && _eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an event date.')),
      );
      return;
    }

    final newTodo = ToDo(
      todoText: todo,
      tagIds: List.from(_selectedTagIds),
      priority: _selectedPriority,
      orderIndex: todosList.length,
      isRecurring: _isRecurring,
      eventDate: _eventDate,
      estimatedCost: double.tryParse(_costController.text),
    );

    await DatabaseHelper.instance.create(newTodo);
    _todoController.clear();
    _costController.clear();
    setState(() {
      _selectedTagIds = [];
      _selectedPriority = TodoPriority.medium;
      _isRecurring = true;
      _eventDate = null;
    });
    _fetchTodos();
  }

  Future<void> _archiveTodo(int id) async {
    await DatabaseHelper.instance.archiveTodo(id);
    _confettiController.play();
    _fetchTodos();
  }

  void _showItemAvoidedSnackBar(ToDo todo) {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    const snackBarDuration = Duration(seconds: 4);

    messenger.hideCurrentSnackBar();
    final snackBarController = messenger.showSnackBar(
      SnackBar(
        content: Text('"${todo.todoText}" ${l10n?.itemAvoided ?? 'avoided!'}'),
        duration: snackBarDuration,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: l10n?.undo ?? 'Undo',
          onPressed: () async {
            await DatabaseHelper.instance.restoreTodo(
              int.parse(todo.id!),
            );
            _fetchTodos();
          },
        ),
      ),
    );

    // Ensure the snackbar does not remain visible indefinitely.
    Future.delayed(snackBarDuration, () {
      if (!mounted) return;
      snackBarController.close();
    });
  }

  String _getPriorityLabel(TodoPriority priority) {
    final l10n = AppLocalizations.of(context);
    switch (priority) {
      case TodoPriority.high:
        return l10n?.high ?? 'High';
      case TodoPriority.medium:
        return l10n?.medium ?? 'Medium';
      case TodoPriority.low:
        return l10n?.low ?? 'Low';
    }
  }

  Future<void> _showCreateTagDialog(
    BuildContext ctx,
    List<Tag> localTags,
    void Function(VoidCallback) setModalState,
  ) async {
    final nameController = TextEditingController();
    int selectedColor = Tag.palette.first;

    await showDialog(
      context: ctx,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setDialogState) => AlertDialog(
          title: const Text('New Tag'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Tag name'),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: Tag.palette.map((colorVal) {
                  final isSelected = selectedColor == colorVal;
                  return GestureDetector(
                    onTap: () => setDialogState(() => selectedColor = colorVal),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(width: 3, color: Colors.white)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                    color: Color(colorVal).withAlpha(120),
                                    blurRadius: 6)
                              ]
                            : null,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final newTag = Tag(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: name,
                  colorValue: selectedColor,
                );
                await DatabaseHelper.instance.createTag(newTag);
                await _fetchTags();
                setModalState(() => localTags.add(newTag));
                if (dialogContext.mounted) Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tdAvoidRed,
                foregroundColor: Colors.white,
              ),
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTodoDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)?.addThingToAvoid ??
                    'Add Thing to Avoid',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _todoController,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)?.whatToAvoid ??
                      'What do you need to avoid?',
                  prefixIcon: const Icon(Icons.block),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text('Tags:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              FutureBuilder<List<Tag>>(
                future: DatabaseHelper.instance.getAllTags(),
                builder: (context, snapshot) {
                  final localTags = snapshot.data ?? _allTags;
                  return Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      ...localTags.map((tag) {
                        final isSelected = _selectedTagIds.contains(tag.id);
                        return FilterChip(
                          label: Text(tag.name),
                          selected: isSelected,
                          onSelected: (selected) {
                            setModalState(() {
                              if (selected) {
                                _selectedTagIds.add(tag.id);
                              } else {
                                _selectedTagIds.remove(tag.id);
                              }
                            });
                          },
                          selectedColor: tag.color.withAlpha(180),
                          checkmarkColor: Colors.white,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : null,
                          ),
                        );
                      }),
                      ActionChip(
                        avatar: const Icon(Icons.add, size: 16),
                        label: const Text('New tag'),
                        onPressed: () => _showCreateTagDialog(
                            context, localTags, setModalState),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)?.priority ?? 'Priority:',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoPriority.values.map((priority) {
                  final isSelected = _selectedPriority == priority;
                  Color color;
                  switch (priority) {
                    case TodoPriority.high:
                      color = AppThemes.priorityHigh;
                      break;
                    case TodoPriority.medium:
                      color = AppThemes.priorityMedium;
                      break;
                    case TodoPriority.low:
                      color = AppThemes.priorityLow;
                      break;
                  }
                  return ChoiceChip(
                    label: Text(_getPriorityLabel(priority)),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() {
                          _selectedPriority = priority;
                        });
                      }
                    },
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // Recurring vs Single Event Toggle
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Is this a recurring habit?',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                value: _isRecurring,
                onChanged: (bool value) {
                  setModalState(() {
                    _isRecurring = value;
                    if (value) {
                      _eventDate = null; // Clear date if switching back
                    }
                  });
                },
                activeThumbColor: tdAvoidRed,
              ),

              if (!_isRecurring)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Text('Event Date: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(_eventDate == null
                            ? 'Select Date'
                            : '${_eventDate!.day}/${_eventDate!.month}/${_eventDate!.year}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate:
                                DateTime.now().add(const Duration(days: 1)),
                            firstDate: DateTime.now(),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setModalState(() {
                              _eventDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 16),
              TextField(
                controller: _costController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost per Relapse / Duration',
                  hintText: 'e.g., 5.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _addTodo(_todoController.text);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: tdAvoidRed,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(AppLocalizations.of(context)?.addToAvoidList ??
                      'Add to Avoid List'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      results = todosList;
    } else {
      results = todosList
          .where((item) => item.todoText!
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _foundToDo = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor:
          isDark ? AppThemes.darkBackground : AppThemes.lightBackground,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(themeProvider),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 15,
            ),
            child: Column(
              children: [
                _buildSearchBox(),
                Expanded(
                  child: _foundToDo.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: 64,
                                color: isDark
                                    ? AppThemes.darkTextSecondary
                                    : AppThemes.lightTextSecondary,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(context)?.noItemsYet ??
                                    'No items to avoid yet',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isDark
                                      ? AppThemes.darkTextSecondary
                                      : AppThemes.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: _foundToDo.length,
                          itemBuilder: (context, i) {
                            return Dismissible(
                              key: ValueKey(_foundToDo[i].id),
                              direction: DismissDirection.startToEnd,
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 20),
                                margin: const EdgeInsets.only(bottom: 12),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.archive,
                                        color: Colors.white),
                                    const SizedBox(height: 4),
                                    Text(
                                      AppLocalizations.of(context)
                                              ?.avoidedLabel ??
                                          'Avoided!',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (_) async {
                                final todo = _foundToDo[i];
                                await _archiveTodo(int.parse(todo.id!));
                                if (mounted) {
                                  _showItemAvoidedSnackBar(todo);
                                }
                              },
                              child: ToDoItem(
                                todo: _foundToDo[i],
                                onEditItem: _editTodo,
                                onRelapse: _triggerRelapse,
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoDialog,
        icon: const Icon(Icons.add),
        label: const Text('Add'),
      ),
    );
  }

  Future<void> _editTodo(ToDo todo) async {
    final textController = TextEditingController(text: todo.todoText);
    final costController =
        TextEditingController(text: todo.estimatedCost?.toString() ?? '');
    List<String> editTagIds = List.from(todo.tagIds);
    TodoPriority editPriority = todo.priority;
    bool editIsRecurring = todo.isRecurring;
    DateTime? editEventDate = todo.eventDate;
    final localTags = List<Tag>.from(_allTags);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)?.editItem ?? 'Edit Item',
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: textController,
                decoration: const InputDecoration(
                  hintText: 'What do you need to avoid?',
                  prefixIcon: Icon(Icons.block),
                ),
                autofocus: true,
              ),
              const SizedBox(height: 16),
              const Text('Tags:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  ...localTags.map((tag) {
                    final isSelected = editTagIds.contains(tag.id);
                    return FilterChip(
                      label: Text(tag.name),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          if (selected) {
                            editTagIds.add(tag.id);
                          } else {
                            editTagIds.remove(tag.id);
                          }
                        });
                      },
                      selectedColor: tag.color.withAlpha(180),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : null,
                      ),
                    );
                  }),
                  ActionChip(
                    avatar: const Icon(Icons.add, size: 16),
                    label: const Text('New tag'),
                    onPressed: () =>
                        _showCreateTagDialog(context, localTags, setModalState),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)?.priority ?? 'Priority:',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoPriority.values.map((priority) {
                  final isSelected = editPriority == priority;
                  Color color;
                  String label;
                  switch (priority) {
                    case TodoPriority.high:
                      color = AppThemes.priorityHigh;
                      label = 'High';
                      break;
                    case TodoPriority.medium:
                      color = AppThemes.priorityMedium;
                      label = 'Medium';
                      break;
                    case TodoPriority.low:
                      color = AppThemes.priorityLow;
                      label = 'Low';
                      break;
                  }
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setModalState(() {
                          editPriority = priority;
                        });
                      }
                    },
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Is this a recurring habit?',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                value: editIsRecurring,
                onChanged: (bool value) {
                  setModalState(() {
                    editIsRecurring = value;
                    if (value) {
                      editEventDate = null;
                    }
                  });
                },
                activeThumbColor: tdAvoidRed,
              ),
              if (!editIsRecurring)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      const Text('Event Date: ',
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      TextButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(editEventDate == null
                            ? 'Select Date'
                            : '${editEventDate!.day}/${editEventDate!.month}/${editEventDate!.year}'),
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: editEventDate ?? DateTime.now(),
                            firstDate: DateTime.now()
                                .subtract(const Duration(days: 365)),
                            lastDate:
                                DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) {
                            setModalState(() {
                              editEventDate = picked;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 16),
              TextField(
                controller: costController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Estimated Cost per Relapse / Duration',
                  hintText: 'e.g., 5.00',
                  prefixIcon: Icon(Icons.attach_money),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                          AppLocalizations.of(context)?.cancel ?? 'Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (!editIsRecurring && editEventDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please select an event date.')),
                          );
                          return;
                        }

                        final updatedTodo = todo.copyWith(
                          todoText: textController.text,
                          tagIds: editTagIds,
                          priority: editPriority,
                          isRecurring: editIsRecurring,
                          eventDate: editEventDate,
                          estimatedCost: double.tryParse(costController.text),
                        );
                        await DatabaseHelper.instance.update(updatedTodo);
                        _fetchTodos();
                        if (context.mounted) Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tdAvoidRed,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(AppLocalizations.of(context)?.save ?? 'Save'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _triggerRelapse(ToDo todo) async {
    final noteController = TextEditingController();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Oh no! What triggered this?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Logging your triggers helps you avoid them in the future.',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: 'Optional notes...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final updatedTodo = todo.copyWith(
                        lastRelapsedAt: DateTime.now(),
                        relapseCount: todo.relapseCount + 1,
                      );
                      await DatabaseHelper.instance.update(updatedTodo);

                      final log = RelapseLog(
                        todoId: todo.id!,
                        triggerNote: noteController.text.isNotEmpty
                            ? noteController.text
                            : null,
                      );
                      await DatabaseHelper.instance.addRelapseLog(log);

                      _fetchTodos();
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Streak reset. Don\'t give up!'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdAvoidRed,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Confirm Relapse'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (value) => _runFilter(value),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          prefixIcon: const Icon(
            Icons.search,
            size: 20,
          ),
          prefixIconConstraints: const BoxConstraints(
            maxHeight: 20,
            minWidth: 25,
          ),
          border: InputBorder.none,
          hintText: AppLocalizations.of(context)?.search ?? 'Search',
          hintStyle: TextStyle(
            color: Theme.of(context).hintColor,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, size: 18),
                  onPressed: () {
                    _searchController.clear();
                    _runFilter('');
                  },
                )
              : null,
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset('assets/images/avoid_logo.png'),
            ),
          ),
        ],
      ),
    );
  }

  Drawer _buildDrawer(ThemeProvider themeProvider) {
    final localeProvider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/avoid_logo.png',
                    height: 60,
                    width: 60,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n?.appTitle ?? 'Avoid ToDo',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  l10n?.appTagline ?? 'Stay productive by avoiding!',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n?.language ?? 'Language',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Column(
            children: [
              RadioListTile<Locale>(
                title: Text(l10n?.english ?? 'English'),
                value: const Locale('en'),
                groupValue: localeProvider.locale,
                onChanged: (value) {
                  if (value != null) localeProvider.setLocale(value);
                },
                secondary: const Text('🇺🇸'),
              ),
              RadioListTile<Locale>(
                title: Text(l10n?.french ?? 'Français'),
                value: const Locale('fr'),
                groupValue: localeProvider.locale,
                onChanged: (value) {
                  if (value != null) localeProvider.setLocale(value);
                },
                secondary: const Text('🇫🇷'),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.archive),
            title: Text(l10n?.archive ?? 'Archive'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ArchiveScreen()),
              ).then((_) => _fetchTodos());
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: Text(l10n?.statistics ?? 'Statistics'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const StatisticsScreen()),
              );
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              l10n?.theme ?? 'Theme',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Column(
            children: [
              RadioListTile<ThemeModeOption>(
                title: Text(l10n?.system ?? 'System'),
                value: ThemeModeOption.system,
                groupValue: themeProvider.themeModeOption,
                onChanged: (value) {
                  if (value != null) themeProvider.setTheme(value);
                },
                secondary: const Icon(Icons.brightness_auto),
              ),
              RadioListTile<ThemeModeOption>(
                title: Text(l10n?.light ?? 'Light'),
                value: ThemeModeOption.light,
                groupValue: themeProvider.themeModeOption,
                onChanged: (value) {
                  if (value != null) themeProvider.setTheme(value);
                },
                secondary: const Icon(Icons.brightness_7),
              ),
              RadioListTile<ThemeModeOption>(
                title: Text(l10n?.dark ?? 'Dark'),
                value: ThemeModeOption.dark,
                groupValue: themeProvider.themeModeOption,
                onChanged: (value) {
                  if (value != null) themeProvider.setTheme(value);
                },
                secondary: const Icon(Icons.brightness_2),
              ),
            ],
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: Text(l10n?.about ?? 'About'),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(l10n?.appTitle ?? 'Avoid Todo App'),
                    content: Text(l10n?.aboutDescription ??
                        'Never forget what you need to avoid anymore.'),
                    actions: [
                      TextButton(
                        child: Text(l10n?.close ?? 'Close'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
