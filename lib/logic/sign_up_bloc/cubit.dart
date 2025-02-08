import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/logic/sign_up_bloc/state.dart';

class SignUpCubit extends Cubit<SignUpStates> {
  final FirebaseAuth firebaseAuth;

  SignUpCubit(this.firebaseAuth) : super(SignUpInitialState());

  Future signUp(String email, password) async {
    emit(SignUpLoadingState());
    try {
      await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      emit(SignUpSuccessState());
    } catch (e) {
      emit(SignUpErrorState(e.toString()));
    }
  }
}