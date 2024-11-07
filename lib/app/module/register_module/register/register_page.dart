import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:uber_clone_core/uber_clone_core.dart';
import 'package:uber_clone_driver/app/helper/uber_drive_constants.dart';
import 'package:uber_clone_driver/app/module/register_module/register_controller.dart';
import 'package:validatorless/validatorless.dart';

class RegisterPage extends StatefulWidget{
  final RegisterController registerController;

  const RegisterPage({super.key, required this.registerController});

  @override
  State<StatefulWidget> createState() => RegisterPageState();

}

class RegisterPageState extends State<RegisterPage> with DialogLoader{
 final _controllerEmail = TextEditingController();
 final _controllerNome  =  TextEditingController();
 final _controllerSenha =  TextEditingController();
 final _formKey = GlobalKey<FormState>();

 late ReactionDisposer errorReactionDispose;
 late ReactionDisposer isSuccessLoginReactionDispose;

  @override
  void initState() {
     
     initReaction();
    super.initState();
  }

  initReaction(){
    errorReactionDispose = reaction<String?>((_) =>widget.registerController.errorMessange, (erro){
       if (erro != null && erro.isNotEmpty) {
           callSnackBar(erro);
       }
     });

     isSuccessLoginReactionDispose = reaction<bool?>((_) =>widget.registerController.isSuccessLogin, (isSuccessLogin){
       if (isSuccessLogin != null && isSuccessLogin) {
           Navigator.of(context).pushNamedAndRemoveUntil(UberDriveConstants.HOME_PAGE_NAME,(route) => false,);
       }  
     });
  }

  @override
  void dispose() {
     errorReactionDispose();
     isSuccessLoginReactionDispose();
    _controllerEmail.dispose();
    _controllerNome.dispose();
    _controllerSenha.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
      
       title: const Text("Cadastro"),
     ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child:Center(
           child: SingleChildScrollView(
             child: Column( crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[
                  _camposCadastro(_formKey),

                 const SizedBox(height: 20),

                 ElevatedButton(
                   style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.blue[200],
                     padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                     textStyle: const TextStyle(fontSize: 18,),
                     shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                     elevation: 1
                   ),
                     onPressed: () async{
                         FocusNode().unfocus();
                        showLoaderDialog();
                         final isValid = _formKey.currentState?.validate() ?? false; 
                         if (isValid) {
                             final name = _controllerNome.text;
                             final email = _controllerEmail.text;
                             final password = _controllerSenha.text;  
                             await  widget.registerController.register(name, email, password);
                         }
                         hideLoader(); 
                     },
                     child: const Text("Cadastrar")
                 )
               ],
             ),
           ),
        ) ,
      ),

   );
  }
  _camposCadastro(GlobalKey<FormState> formKey){
     return Form(
      key:formKey ,
       child: Column(crossAxisAlignment: CrossAxisAlignment.stretch,
         children:<Widget> [
           UberTextFieldWidget(
            controller: _controllerNome,
            inputType: TextInputType.name,
            label:"Nome......" ,
            prefixIcon: const Icon(Icons.person),
            validator: Validatorless.multiple([
              Validatorless.required('Nome requerido'),
              Validatorless.min(6, "seu nome precisar ter pelo menos 6 letras")
            ]),
            ),
      
           Padding(
             padding: const EdgeInsets.only(top: 13,bottom: 13),
             child: UberTextFieldWidget(
            controller: _controllerEmail,
            inputType: TextInputType.emailAddress,
            label:"Email......" ,
            hintText: "SeuEmail@.com......",
            prefixIcon: const Icon(Icons.email),
            validator: Validatorless.multiple([
              Validatorless.required("Email requerido"),
              Validatorless.email("Defina um Email válido")
            ]),
            ),
       
           ),
       
            UberTextFieldWidget(
            controller: _controllerSenha,
            inputType: TextInputType.text,
            label:"Senha" ,
            obscureText: true,
            prefixIcon: const Icon(Icons.key),
            validator: Validatorless.multiple([
              Validatorless.required("Email requerido"),
              Validatorless.min(5, "Defina uma senha com mais que 5 caracteres")
            ]),
            ),
         
         ],
       ),
     );
  }
}