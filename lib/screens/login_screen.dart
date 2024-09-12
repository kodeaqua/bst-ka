import 'package:cancellation_token/cancellation_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klontong_kodeaqua/cubits/roles_cubit.dart';
import 'package:klontong_kodeaqua/main.dart';

import '../cubits/user_cubit.dart';
import '../models/user_model.dart';
import '../utilities/http_utility_new.dart';
import '../utilities/model_from_json_utility.dart';
import '../utilities/task_utility_new.dart';
import '../widgets/custom_crudcrud_dialog_widget.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late CancellationToken _token;
  late int _secretCounter;
  late bool _isLogin;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _inputUsernameController;
  late final TextEditingController _inputPasswordController;
  late final TextEditingController _inputNameController;

  bool get _isValid => _formKey.currentState!.validate();
  String get _inputedUsername => _inputUsernameController.value.text;
  String get _inputedPassword => _inputPasswordController.value.text;
  String get _inputedName => _inputNameController.value.text;

  @override
  void initState() {
    super.initState();
    _token = CancellationToken();
    _secretCounter = 0;
    _isLogin = true;
    _formKey = GlobalKey<FormState>();
    _inputUsernameController = TextEditingController();
    _inputPasswordController = TextEditingController();
    _inputNameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _inputUsernameController.dispose();
    _inputPasswordController.dispose();
    _inputNameController.dispose();
  }

  void _onSecretLocationTapped() {
    if (_secretCounter < 3) {
      _secretCounter++;
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return const CustomCrudCrudDialogWidget();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ListTile(
                title: InkWell(
                  onTap: _onSecretLocationTapped,
                  child: const Text('Klontong App'),
                ),
                titleTextStyle: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
                subtitle: const Text('The best online store ever!'),
                subtitleTextStyle: Theme.of(context).textTheme.bodyLarge,
                trailing: const Icon(Icons.store_outlined, size: 48),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: _inputUsernameController,
                  decoration: const InputDecoration(filled: true, label: Text('Username')),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in username field';
                    } else if (value.characters.length < 8) {
                      return 'The minimum character is 8';
                    } else {
                      return null;
                    }
                  },
                  maxLength: 16,
                ),
              ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextFormField(
                  controller: _inputPasswordController,
                  decoration: const InputDecoration(filled: true, label: Text('Password')),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill in password field';
                    } else if (value.characters.length < 8) {
                      return 'The minimum character is 8';
                    } else {
                      return null;
                    }
                  },
                  obscureText: true,
                  maxLength: 16,
                ),
              ),
              if (!_isLogin) const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              if (!_isLogin)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isLogin ? 0 : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: TextFormField(
                      controller: _inputNameController,
                      decoration: const InputDecoration(filled: true, label: Text('Name')),
                      validator: (String? value) {
                        if (_isLogin) return null;

                        if (value == null || value.isEmpty) {
                          return 'Please fill in name field';
                        } else if (value.characters.length < 8) {
                          return 'The minimum character is 8';
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                ),
              const Padding(padding: EdgeInsets.symmetric(vertical: 8)),
              ListTile(
                title: FilledButton(
                  onPressed: _onSubmitted,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLogin ? const Text('Login') : const Text('Register'),
                  ),
                ),
                subtitle: OutlinedButton(
                  onPressed: () => _onSwitchView(value: !_isLogin),
                  child: _isLogin ? const Text('Create new account') : const Text('Already have an account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSwitchView({required bool value}) => setState(() => _isLogin = value);

  void _onSubmitted() {
    if (!_isValid) return;

    showDialog(
      context: context,
      builder: (_) {
        return const PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text('Loading'),
            content: LinearProgressIndicator(),
          ),
        );
      },
    );

    _onProcessingRequest().then(_onRequestResultCallback);
  }

  /*
          Note from kodeaqua
          These code might be no optimal ways, because of using 3rd party's REST API
          So this logic is to get all users, and might be memory or resource leak and causing vulnerability issue
      */
  // Start of unoptimized logic #1
  Future<UserModel?> _unoptimizedMethod() async {
    late final List<UserModel>? users;
    late final List<String> mappedUsername;
    late final int indexOfUser;
    late final bool isMatch;
    late final HttpUtilityNew httpUtilityNew;
    late final HttpPayload httpPayload;
    late final TaskPayload taskPayload;
    late final TaskUtilityNew taskUtilityNew;
    late final TaskResult taskResult;

    httpUtilityNew = HttpUtilityNew();
    taskUtilityNew = TaskUtilityNew();
    httpPayload = HttpPayload(entity: 'users', requestType: HttpRequestType.get);
    taskPayload = TaskPayload(token: _token, function: () => httpUtilityNew.makeRequest(payload: httpPayload), isMandatory: true);
    taskResult = await taskUtilityNew.run(payload: taskPayload);

    if (taskResult.result == null) return null;

    users = ModelFromJsonUtility.users(taskResult.result.body);

    if (users.isEmpty) return null;

    mappedUsername = users.map((UserModel u) => u.username ?? '').toList();

    if (!mappedUsername.contains(_inputedUsername)) return null;

    indexOfUser = mappedUsername.indexOf(_inputedUsername);

    isMatch = await FlutterBcrypt.verify(password: _inputedPassword, hash: users[indexOfUser].password ?? '');
    if (!isMatch) return null;

    return users[indexOfUser];
  }
  // End of unoptimized logic #1

  Future<UserModel?> _onProcessingRequest() async {
    // late dynamic response;
    late final DateTime currentTime;
    late UserModel user;

    if (!_isLogin) {
      await context.read<RolesCubit>().init(token: _token);
      currentTime = DateTime.now().toUtc();
      user = UserModel();
      user.username = _inputedUsername;
      user.password = await FlutterBcrypt.hashPw(password: _inputedPassword, salt: await FlutterBcrypt.salt());
      user.name = _inputedName;
      user.roleId = '${context.read<RolesCubit>().state?[1].id}';
      user.createdAt = currentTime;
      user.updatedAt = currentTime;

      // response = await TaskUtility.execute(providerToken: _token, function: () => HttpUtility.post(entity: 'users', data: user));
      // if (response.runtimeType == Null) return null;
      await navigatorKey.currentContext!.read<UserCubit>().send(token: _token, data: user);
    }

    return await _unoptimizedMethod();
  }

  void _onRequestResultCallback(UserModel? value) async {
    Navigator.pop(context);

    if (value == null) {
      if (_isLogin) {
        showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text('Login failed'),
              content: const Text('Please try again with correct credentials'),
              actions: <Widget>[
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                )
              ],
            );
          },
        );
      }

      return;
    }

    context.read<UserCubit>().set(value);
    navigatorKey.currentContext!.read<UserCubit>().save().whenComplete(() => _onSavedCredentialsCallback(value: value));
  }

  void _onSavedCredentialsCallback({required UserModel value}) {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeScreen()), (__) => false);
  }
}
