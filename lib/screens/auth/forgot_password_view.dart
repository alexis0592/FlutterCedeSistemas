part of app.auth;

class ForgotPasswordView extends StatefulWidget {
  static String route = '${AuthView.route}/forgotpassword';

  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  _ForgotPasswordViewState createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final NavigatorService navigator = locator<NavigatorService>();
  final AuthRepository repository = locator<AuthRepository>();
  TextEditingController forgotPasswordController = TextEditingController();

  String? emailError;
  bool isEmailValid = false;

  bool get disableButton =>
      forgotPasswordController.text.isEmpty || !isEmailValid;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(
              fontSize: getProportionsScreenHeigth(14), color: secondaryColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
        physics: ClampingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                height: SizeConfig.screenHeight! * 0.05,
              ),
              Text(
                'Forgot Password',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: getProportionsScreenHeigth(28)),
              ),
              Text(
                'Please enter your email and we will send\n you a link to return to your account',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              Input(
                controller: forgotPasswordController,
                label: 'Email',
                icon: Icons.email_outlined,
                placeholder: 'Enter your email',
                onChange: onValidateEmail,
                error: emailError,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.08,
              ),
              Button(
                label: 'Send',
                onPress: onRecoverPassword,
                disable: disableButton,
              ),
              SizedBox(
                height: SizeConfig.screenHeight! * 0.02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  InkWell(
                    onTap: navigateToSignUp,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(color: primaryColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onValidateEmail(String email) {
    isEmailValid = validateEmail(email);
    setState(() {
      isEmailValid ? emailError = null : emailError = 'invalid email';
    });
  }

  void onRecoverPassword() {
    if (isEmailValid) {
      repository.restorePassword(email: forgotPasswordController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Se ha enviado un correo electrónico'),
          action: SnackBarAction(
            label: 'Ok',
            onPressed: () {
              navigateToLogin();
            },
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void navigateToSignUp() {
    navigator.push(route: SignUpView.route, key: navigator.authNavigatorKey);
  }

  void navigateToLogin() {
    navigator.push(route: LoginView.route, key: navigator.authNavigatorKey);
  }
}
