import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:prime_top_front/core/gen/colors.gen.dart';
import 'package:prime_top_front/features/auth/application/cubit/auth_cubit.dart';

enum _AuthMode { login, register }

class AuthDialog extends StatefulWidget {
  const AuthDialog({super.key});

  @override
  State<AuthDialog> createState() => _AuthDialogState();
}

class _AuthDialogState extends State<AuthDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  _AuthMode _mode = _AuthMode.login;
  String _email = '';
  String _password = '';
  String _companyName = '';

  bool _obscure = true;
  bool _obscureRepeat = true;

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordRepeatController = TextEditingController();

  static final RegExp _emailRegExp = RegExp(
    r'^(?:(?:[^<>()\[\]\\.,;:\s@"]+(?:\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@(?:(?:[a-zA-Z0-9\-]+\.)+[a-zA-Z]{2,}|(?:\d{1,3}\.){3}\d{1,3})$',
  );

  void _toggleMode() {
    setState(() {
      _mode = _mode == _AuthMode.login ? _AuthMode.register : _AuthMode.login;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    final auth = context.read<AuthCubit>();
    if (_mode == _AuthMode.login) {
      auth.login(email: _email.trim(), password: _password);
    } else {
      auth.register(email: _email.trim(), password: _password, companyName: _companyName.trim());
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state.status == AuthStatus.authenticated) {
                Navigator.of(context).maybePop();
              }
            },
            builder: (context, state) {
              final bool isLoading = state.status == AuthStatus.loading;
              final BorderRadius borderRadius = BorderRadius.circular(8);
              final OutlineInputBorder normalBorder = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: BorderSide(color: Theme.of(context).dividerColor),
              );
              final OutlineInputBorder focusedBorder = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: ColorName.primary, width: 1.5),
              );
              final OutlineInputBorder errorBorder = OutlineInputBorder(
                borderRadius: borderRadius,
                borderSide: const BorderSide(color: ColorName.danger, width: 1.5),
              );
              InputDecoration makeDecoration({
                Widget? suffixIcon,
              }) {
                return InputDecoration(
                  filled: true,
                  fillColor: ColorName.backgroundSecondary,
                  isDense: false,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  floatingLabelAlignment: FloatingLabelAlignment.start,
                  focusColor: Colors.black,
                  contentPadding: const EdgeInsets.fromLTRB(12, 20, 12, 14),
                  border: normalBorder,
                  enabledBorder: normalBorder,
                  focusedBorder: focusedBorder,
                  errorBorder: errorBorder,
                  focusedErrorBorder: errorBorder,
                  suffixIcon: suffixIcon,
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    switchInCurve: Curves.easeOut,
                    switchOutCurve: Curves.easeIn,
                    child: Text(
                      _mode == _AuthMode.login ? 'Вход' : 'Регистрация',
                      key: ValueKey(_mode),
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Email',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: makeDecoration(),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            final v = (value ?? '').trim();
                            if (v.isEmpty) return 'Введите email';
                            if (!_emailRegExp.hasMatch(v)) return 'Некорректный email';
                            return null;
                          },
                          onSaved: (newValue) => _email = newValue ?? '',
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: 12),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Название компании',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: makeDecoration(),
                                validator: (value) {
                                  final v = (value ?? '').trim();
                                  if (v.isEmpty) return 'Введите название компании';
                                  if (v.length < 2) return 'Слишком короткое название';
                                  return null;
                                },
                                onSaved: (newValue) => _companyName = newValue ?? '',
                                enabled: !isLoading,
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                          crossFadeState: _mode == _AuthMode.register
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                          sizeCurve: Curves.easeInOut,
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Пароль',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          decoration: makeDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                              onPressed: isLoading
                                  ? null
                                  : () => setState(() {
                                        _obscure = !_obscure;
                                      }),
                            ),
                          ),
                          obscureText: _obscure,
                          controller: _passwordController,
                          validator: (value) {
                            final v = value ?? '';
                            if (v.isEmpty) return 'Введите пароль';
                            if (v.length < 6) return 'Минимум 6 символов';
                            return null;
                          },
                          onSaved: (newValue) => _password = newValue ?? '',
                          enabled: !isLoading,
                        ),
                        AnimatedCrossFade(
                          firstChild: const SizedBox.shrink(),
                          secondChild: Column(
                            children: [
                              const SizedBox(height: 12),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Повторите пароль',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                decoration: makeDecoration(
                                  suffixIcon: IconButton(
                                    icon: Icon(_obscureRepeat ? Icons.visibility_off : Icons.visibility),
                                    onPressed: isLoading
                                        ? null
                                        : () => setState(() {
                                              _obscureRepeat = !_obscureRepeat;
                                            }),
                                  ),
                                ),
                                obscureText: _obscureRepeat,
                                controller: _passwordRepeatController,
                                validator: (value) {
                                  final v = value ?? '';
                                  if (v.isEmpty) return 'Повторите пароль';
                                  if (v != _passwordController.text) return 'Пароли не совпадают';
                                  return null;
                                },
                                enabled: !isLoading,
                              ),
                            ],
                          ),
                          crossFadeState: _mode == _AuthMode.register
                              ? CrossFadeState.showSecond
                              : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 200),
                          sizeCurve: Curves.easeInOut,
                        ),
                      ],
                    ),
                  ),
                  if (state.errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      state.errorMessage!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColorName.danger),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: isLoading ? null : _submit,
                          style: FilledButton.styleFrom(
                            backgroundColor: ColorName.primary,
                            minimumSize: const Size.fromHeight(52),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            child: Text(
                              _mode == _AuthMode.login ? 'Войти' : 'Зарегистрироваться',
                              key: ValueKey(_mode),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      TextButton(
                        onPressed: isLoading ? null : _toggleMode,
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          switchInCurve: Curves.easeOut,
                          switchOutCurve: Curves.easeIn,
                          child: Text(
                            _mode == _AuthMode.login ? 'Регистрация' : 'У меня уже есть аккаунт',
                            key: ValueKey(_mode),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}


