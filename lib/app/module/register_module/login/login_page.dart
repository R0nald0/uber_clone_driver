import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/register_module/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class LoginPage extends StatefulWidget {
  final RegisterController _registerController;
  const LoginPage({required RegisterController registerController, super.key})
      : _registerController = registerController;

  @override
  State<StatefulWidget> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with DialogLoader<LoginPage> {
  final _controllerEmail = TextEditingController();
  final _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late ReactionDisposer errorReactionDispose;
  late ReactionDisposer isSuccessLoginReactionDispose;
  String erroMensagem = "";

  initReaction() {
    errorReactionDispose = reaction<String?>(
        (_) => widget._registerController.errorMessange, (erro) {
      if (erro != null && erro.isNotEmpty) {
        callSnackBar(erro);
      }
    });

     isSuccessLoginReactionDispose = reaction<bool?>((_) =>widget._registerController.isSuccessLogin, (isSuccessLogin){
       if (isSuccessLogin != null && isSuccessLogin) {
            hideLoader();
            Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.HOME_PAGE_NAME,(route) => false,);
       }  
     });
  }

  @override
  void initState() {
    initReaction();
    super.initState();
  }

  @override
  void dispose() {
    errorReactionDispose();
    _controllerEmail.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.black87,
        
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const CircleAvatar(
                    radius: 120,
                    backgroundColor: null,
                    backgroundImage: AssetImage('assets/images/uber_drive_logo.png'),
                  ),
                  camposLoginTxtV(_formKey),
                  campoBtns(widget._registerController, _formKey),
                ],
              ),
            ),
          )),
    );
  }

  camposLoginTxtV(GlobalKey<FormState> formState) {
    return Form(
      key: formState,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 10),
            child: UberTextFieldWidget(
              controller: _controllerEmail,
              prefixIcon: const Icon(Icons.email_outlined),
              hintText: 'Email...',
              validator: Validatorless.multiple([
                Validatorless.required("Campo requerido"),
                Validatorless.email('E-mail inválido'),
              ]),
            ),
          ),
          UberTextFieldWidget(
            controller: _controllerSenha,
            obscureText: true,
            prefixIcon: const Icon(Icons.key),
            hintText: 'Senha...',
            validator: Validatorless.multiple([
              Validatorless.required("Campo requerido"),
              Validatorless.min(5, 'Senha deve conter no mínimo 5 caracteres'),
            ]),
          ),
        ],
      ),
    );
  }

  campoBtns(
      RegisterController loginController, GlobalKey<FormState> formState) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[200],
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18)),
              textStyle: const TextStyle(fontSize: 20),
            ),
            onPressed: ()   {
              FocusNode().requestFocus();
               
              final isValid = formState.currentState?.validate() ?? false;
                if (isValid) {
                showLoaderDialog();
                final email = _controllerEmail.text;
                final ssenha = _controllerSenha.text;
                 loginController.login(email, ssenha);
                hideLoader();
              } 
            },
            child: const Text("Login"),
          ),
        ),
        TextButton(
            onPressed: () {
               Navigator.of(context).pushNamed(UberDriveConstants.REGISTER_PAGE_NAME);
               Focus.of(context).unfocus();
            },
            child: const Text(
              "Nao tem conta, Cadastre-se!! ",
              style: TextStyle(fontSize: 15, color: Colors.white),
            ))
      ],
    );
  }
}
