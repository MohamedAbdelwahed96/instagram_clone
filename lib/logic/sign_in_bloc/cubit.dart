import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instagram_clone/logic/sign_in_bloc/state.dart';

class SignInCubit extends Cubit<SignInStates> {
  final FirebaseAuth firebaseAuth;

  SignInCubit(this.firebaseAuth) : super(SignInInitialState());

  Future signIn(String email, password) async {
    emit(SignInLoadingState());
    try {
      await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      emit(SignInSuccessState());
    } catch (e) {
      emit(SignInErrorState(e.toString()));
    }
  }
}