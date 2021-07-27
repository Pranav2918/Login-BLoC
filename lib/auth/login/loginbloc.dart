import 'package:bloc_login/auth/auth_repo.dart';
import 'package:bloc_login/auth/login/formsubmission.dart';
import 'package:bloc_login/auth/login/loginevent.dart';
import 'package:bloc_login/auth/login/loginstate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepo;
  LoginBloc({required this.authRepo}) : super(LoginState());

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    //username update
    if (event is LoginUsernameChanged) {
      yield state.copyWith(username: event.username);

      //password update
    } else if (event is LoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    }

    //form submission
    else if (event is LoginSubmitted) {
      yield state.copyWith(formStatus: FormSubmitting());

      try {
        await authRepo.login();
        yield state.copyWith(formStatus: SubmissionSuccess());
      } catch (e) {
        yield state.copyWith(
            formStatus: SubmissionFailed(exception: e.toString()));
      }
    }
  }
}
