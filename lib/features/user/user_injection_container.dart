
import 'package:get_it/get_it.dart';
import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source.dart';
import 'package:test_server_app/features/user/data/data_sources/remote/user_remote_data_source_impl.dart';
import 'package:test_server_app/features/user/data/repository/user_repository_impl.dart';
import 'package:test_server_app/features/user/domain/repository/user_repository.dart';
import 'package:test_server_app/features/user/domain/usecases/credential/get_current_uid_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/credential/is_sign_in_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/credential/send_otp_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/credential/sign_out_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/credential/verify_phone_number_usecsae.dart';
import 'package:test_server_app/features/user/domain/usecases/user/create_user_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/user/get_all_users_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/user/get_device_number_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/user/get_single_user_usecase.dart';
import 'package:test_server_app/features/user/domain/usecases/user/update_user_usecase.dart';
import 'package:test_server_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/get_device_number/get_device_number_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/get_single_user/get_single_user_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/login/login_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/user/user_cubit.dart';

Future<void> userInjectionContainer() async {

  // * CUBITS INJECTION
final sl = GetIt.instance;
  sl.registerFactory<AuthCubit>(() => AuthCubit(
      getCurrentUidUseCase: sl.call(),
      isSignInUseCase: sl.call(),
      signOutUseCase: sl.call()
  ));

  sl.registerFactory<UserCubit>(() => UserCubit(
      getAllUsersUseCase: sl.call(),
      updateUserUseCase: sl.call()
  ));

  sl.registerFactory<LoginCubit>(() => LoginCubit(
      sendOtpUseCase: sl.call()
  ));
sl.registerFactory<GetSingleUserCubit>(() => GetSingleUserCubit(
      getSingleUserUseCase: sl.call()
  ));
  sl.registerFactory<GetDeviceNumberCubit>(() => GetDeviceNumberCubit(
      getDeviceNumberUseCase: sl.call()
  ));
   sl.registerFactory<CredentialCubit>(() => CredentialCubit(
     verifyPhoneNumberUseCase:sl.call(),
      createUserUseCase: sl.call(),
  ));

  // * USE CASES INJECTION

  sl.registerLazySingleton<GetCurrentUidUseCase>(() => GetCurrentUidUseCase(repository: sl.call()));

  sl.registerLazySingleton<IsSignInUseCase>(
          () => IsSignInUseCase(repository: sl.call()));

  sl.registerLazySingleton<SignOutUseCase>(
          () => SignOutUseCase(repository: sl.call()));

  sl.registerLazySingleton<CreateUserUseCase>(
          () => CreateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetAllUsersUseCase>(
          () => GetAllUsersUseCase(repository: sl.call()));

  sl.registerLazySingleton<UpdateUserUseCase>(
          () => UpdateUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetSingleUserUseCase>(
          () => GetSingleUserUseCase(repository: sl.call()));

  sl.registerLazySingleton<VerifyPhoneNumberUseCase>(
          () => VerifyPhoneNumberUseCase(repository: sl.call()));

  sl.registerLazySingleton<GetDeviceNumberUseCase>(
          () => GetDeviceNumberUseCase(repository: sl.call()));
  sl.registerLazySingleton<SendOtpUseCase>(
          () => SendOtpUseCase(repository: sl.call()));        

  // * REPOSITORY & DATA SOURCES INJECTION

  sl.registerLazySingleton<UserRepository>(
          () => UserRepositoryImpl(remoteDataSource: sl.call()));

  sl.registerLazySingleton<UserRemoteDataSource>(() => UserRemoteDataSourceImpl(
     baseUrl: Config.baseUrl 
  ));

}