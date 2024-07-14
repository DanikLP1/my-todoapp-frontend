import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/user/bloc.dart';
import '../models/user.dart';
import '../utils/snackbar_util.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoaded) {
            return ProfileForm(user: state.user);
          } else if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserError) {
            WidgetsBinding.instance?.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBarUtil.errorSnackBar(state.error),
              );
            });
            return Center(child: Text('Failed to load user'));
          } else {
            return Center(child: CircularProgressIndicator());
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

  @override
  void initState() {
    super.initState();
    _name = widget.user.username;
    _email = widget.user.email;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      context.read<UserBloc>().add(UpdateUserRequested(name: _name, email: _email));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              initialValue: _name,
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) {
                _name = value ?? '';
              },
            ),
            TextFormField(
              initialValue: _email,
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (value) {
                _email = value ?? '';
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
