import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:provider/provider.dart';
import '../model/todo.dart';
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
  late ConfettiController _confettiController;
  late AnimationController _animationController;

  // Filters
  TodoCategory? _selectedCategory;
  TodoPriority _selectedPriority = TodoPriority.medium;

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
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _todoController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchTodos() async {
    final todos = await DatabaseHelper.instance.readAllTodos();
    setState(() {
      todosList = todos;
      _foundToDo = todos;
    });
  }

  Future<void> _addTodo(String todo) async {
    if (todo.isEmpty) return;

    final newTodo = ToDo(
      todoText: todo,
      category: _selectedCategory ?? TodoCategory.other,
      priority: _selectedPriority,
      orderIndex: todosList.length,
    );

    await DatabaseHelper.instance.create(newTodo);
    _todoController.clear();
    _selectedCategory = null;
    _selectedPriority = TodoPriority.medium;
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

  String _getCategoryLabel(TodoCategory category) {
    final l10n = AppLocalizations.of(context);
    switch (category) {
      case TodoCategory.health:
        return l10n?.health ?? 'Health';
      case TodoCategory.productivity:
        return l10n?.productivity ?? 'Productivity';
      case TodoCategory.social:
        return l10n?.social ?? 'Social';
      case TodoCategory.other:
        return l10n?.other ?? 'Other';
    }
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
              Text(AppLocalizations.of(context)?.category ?? 'Category:',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  Color color;
                  switch (category) {
                    case TodoCategory.health:
                      color = AppThemes.categoryHealth;
                      break;
                    case TodoCategory.productivity:
                      color = AppThemes.categoryProductivity;
                      break;
                    case TodoCategory.social:
                      color = AppThemes.categorySocial;
                      break;
                    case TodoCategory.other:
                      color = AppThemes.categoryOther;
                      break;
                  }
                  return ChoiceChip(
                    label: Text(_getCategoryLabel(category)),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
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
    TodoCategory editCategory = todo.category;
    TodoPriority editPriority = todo.priority;

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
              const Text('Category:',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: TodoCategory.values.map((category) {
                  final isSelected = editCategory == category;
                  Color color;
                  String label;
                  switch (category) {
                    case TodoCategory.health:
                      color = AppThemes.categoryHealth;
                      label = 'Health';
                      break;
                    case TodoCategory.productivity:
                      color = AppThemes.categoryProductivity;
                      label = 'Productivity';
                      break;
                    case TodoCategory.social:
                      color = AppThemes.categorySocial;
                      label = 'Social';
                      break;
                    case TodoCategory.other:
                      color = AppThemes.categoryOther;
                      label = 'Other';
                      break;
                  }
                  return ChoiceChip(
                    label: Text(label),
                    selected: isSelected,
                    onSelected: (selected) {
                      setModalState(() {
                        editCategory = category;
                      });
                    },
                    selectedColor: color,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  );
                }).toList(),
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
                        final updatedTodo = todo.copyWith(
                          todoText: textController.text,
                          category: editCategory,
                          priority: editPriority,
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
          RadioGroup<Locale>(
            groupValue: localeProvider.locale,
            onChanged: (value) {
              if (value != null) {
                localeProvider.setLocale(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<Locale>(
                  title: Text(l10n?.english ?? 'English'),
                  value: const Locale('en'),
                  secondary: const Text('🇺🇸'),
                ),
                RadioListTile<Locale>(
                  title: Text(l10n?.french ?? 'Français'),
                  value: const Locale('fr'),
                  secondary: const Text('🇫🇷'),
                ),
              ],
            ),
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
          RadioGroup<ThemeModeOption>(
            groupValue: themeProvider.themeModeOption,
            onChanged: (value) {
              if (value != null) {
                themeProvider.setTheme(value);
              }
            },
            child: Column(
              children: [
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.system ?? 'System'),
                  value: ThemeModeOption.system,
                  secondary: const Icon(Icons.brightness_auto),
                ),
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.light ?? 'Light'),
                  value: ThemeModeOption.light,
                  secondary: const Icon(Icons.brightness_7),
                ),
                RadioListTile<ThemeModeOption>(
                  title: Text(l10n?.dark ?? 'Dark'),
                  value: ThemeModeOption.dark,
                  secondary: const Icon(Icons.brightness_2),
                ),
              ],
            ),
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
