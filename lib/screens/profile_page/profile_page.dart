import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_todo_app/screens/error_screen.dart';
import 'package:my_todo_app/screens/profile_page/settings/general_settings.dart';
import 'package:my_todo_app/screens/profile_page/skeleton_profile.dart';
import '../../blocs/user/bloc.dart';
import '../../models/user.dart';
import '../../utils/snackbar_util.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return ProfileForm(user: state.user);
          } else if (state is UserLoading) {
            return ShimmerLoading();
          } else if (state is UserError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            });
            return ErrorScreen(
              errorMessage: "Не удалось загрузить данные, проверьте ваше интернет соединение", 
              onRetry: () {
                context.read<UserBloc>().add(LoadUserRequested());
              }
            );
          } else {
            return ShimmerLoading();
          }
        },
      ),
    );
  }
}

class ProfileForm extends StatefulWidget {
  final User user;

  ProfileForm({required this.user});

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _name = widget.user.username;
    _email = widget.user.email;
  }

  Future<void> _refreshUserData() async {
    context.read<UserBloc>().add(LoadUserRequested()); // Assuming you have this event to load user data
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<UserBloc>().add(UpdateUserRequested(name: _name, email: _email));
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshUserData,
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(height: 16),
                  SizedBox(height: 16),
                  Text(
                    'Имя: $_name',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Почта: $_email',
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  if (_isEditing)
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            initialValue: _name,
                            decoration: InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.person),
                            ),
                            onSaved: (value) {
                              _name = value ?? '';
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            initialValue: _email,
                            decoration: InputDecoration(
                              labelText: 'Почта',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.email),
                            ),
                            onSaved: (value) {
                              _email = value ?? '';
                            },
                          ),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text('Сохранить изменения'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = !_isEditing;
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_isEditing ? Icons.cancel : Icons.edit),
                        SizedBox(width: 8),
                        Text(_isEditing ? 'Отмена' : 'Изменить'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Настройки приложения',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  SizedBox(height: 16),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text('Общие настройки'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => GeneralSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Уведомления'),
                    onTap: () {
                      // Функционал пока не реализован
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.security),
                    title: Text('Безопасность'),
                    onTap: () {
                      // Функционал пока не реализован
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.help),
                    title: Text('Помощь и обратная связь'),
                    onTap: () {
                      // Функционал пока не реализован
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
