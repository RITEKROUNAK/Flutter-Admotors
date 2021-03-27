import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:flutteradmotors/config/ps_config.dart';
import 'package:flutteradmotors/constant/ps_constants.dart';
import 'package:flutteradmotors/constant/route_paths.dart';
import 'package:flutteradmotors/repository/user_repository.dart';
import 'package:flutteradmotors/ui/common/dialog/error_dialog.dart';
import 'package:flutteradmotors/ui/common/dialog/warning_dialog_view.dart';
import 'package:flutteradmotors/ui/common/facebook_login_web_view.dart';
import 'package:flutteradmotors/utils/global/global.dart';
import 'package:flutteradmotors/utils/ps_progress_dialog.dart';
import 'package:flutteradmotors/utils/utils.dart';
import 'package:flutteradmotors/viewobject/api_status.dart';
import 'package:flutteradmotors/viewobject/common/ps_value_holder.dart';
import 'package:flutteradmotors/viewobject/holder/apple_login_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/facebook_login_user_holder.dart';
import 'package:flutteradmotors/viewobject/holder/fb_login_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/google_login_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/user_login_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/user_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/holder/user_register_parameter_holder.dart';
import 'package:flutteradmotors/viewobject/shipping_city.dart';
import 'package:flutteradmotors/viewobject/shipping_country.dart';
import 'package:flutteradmotors/viewobject/user.dart';
import 'package:flutter/material.dart';
import 'package:flutteradmotors/api/common/ps_resource.dart';
import 'package:flutteradmotors/api/common/ps_status.dart';
import 'package:flutteradmotors/provider/common/ps_provider.dart';
import 'package:flutteradmotors/viewobject/user_login.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class UserProvider extends PsProvider {
  UserProvider(
      {@required UserRepository repo,
      @required this.psValueHolder,
      int limit = 0})
      : super(repo, limit) {
    _repo = repo;
    isDispose = false;
    print('User Provider: $hashCode');
    userListStream = StreamController<PsResource<User>>.broadcast();
    subscription = userListStream.stream.listen((PsResource<User> resource) {
      if (resource != null && resource.data != null) {
        _user = resource;
        holderUser = resource.data;
      }

      if (resource.status != PsStatus.BLOCK_LOADING &&
          resource.status != PsStatus.PROGRESS_LOADING) {
        isLoading = false;
      }

      if (!isDispose) {
        notifyListeners();
      }
    });
  }

  UserRepository _repo;
  PsValueHolder psValueHolder;
  User holderUser;
  ShippingCountry selectedCountry;
  ShippingCity selectedCity;
  bool isCheckBoxSelect = true;
  bool isVendor = false;
  UserLogin user_login=UserLogin();
  bool _wait_sign=false;
 bool get wait_sign=>_wait_sign;
  QuerySnapshot items;
  UserParameterHolder userParameterHolder =
      UserParameterHolder().getOtherUserData();

  PsResource<User> _user = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> _holderUser = PsResource<User>(PsStatus.NOACTION, '', null);
  PsResource<User> get user => _user;

  PsResource<ApiStatus> _apiStatus =
      PsResource<ApiStatus>(PsStatus.NOACTION, '', null);
  PsResource<ApiStatus> get apiStatus => _apiStatus;

  StreamSubscription<PsResource<User>> subscription;
  StreamController<PsResource<User>> userListStream;
  final fb_auth.FirebaseAuth _firebaseAuth = fb_auth.FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  @override
  void dispose() {
    subscription.cancel();
    isDispose = true;
    print('User Provider Dispose: $hashCode');
    super.dispose();
  }

  Future<dynamic> postUserRegister(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserRegister(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserEmailVerify(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserEmailVerify(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postImageUpload(
    String userId,
    String platformName,
    File imageFile,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postImageUpload(userId, platformName, imageFile,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postForgotPassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postForgotPassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postChangePassword(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postChangePassword(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postProfileUpdate(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _holderUser = await _repo.postProfileUpdate(
        jsonMap, isConnectedToInternet, PsStatus.SUCCESS);
    if (_holderUser.status == PsStatus.SUCCESS) {
      //_user = _holderUser;
      return _holderUser;
    } else {
      return _holderUser;
    }
  }

  Future<dynamic> postPhoneLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postPhoneLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postUserFollow(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postUserFollow(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postFBLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postFBLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postAppleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postAppleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postGoogleLogin(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.postGoogleLogin(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> postResendCode(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postResendCode(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> getUser(
    String loginUserId,
  ) async {
    isLoading = true;
    isConnectedToInternet = await Utils.checkInternetConnectivity();

    await _repo.getUser(userListStream, loginUserId, isConnectedToInternet,
        PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getUserFromDB(String loginUserId) async {
    isLoading = true;

    await _repo.getUserFromDB(
        loginUserId, userListStream, PsStatus.PROGRESS_LOADING);
  }

  Future<dynamic> getOtherUserData(
      Map<dynamic, dynamic> jsonMap, String otherUserId) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _user = await _repo.getOtherUserData(userListStream, jsonMap, otherUserId,
        isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _user;
  }

  Future<dynamic> userReportItem(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.userReportItem(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> blockUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.blockUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postUnBlockUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postUnBlockUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  Future<dynamic> postDeleteUser(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.postDeleteUser(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }

  ///
  /// Firebase Auth
  ///
  Future<fb_auth.User> getCurrentFirebaseUser() async {
    final fb_auth.FirebaseAuth auth = fb_auth.FirebaseAuth.instance;
    final fb_auth.User currentUser = auth.currentUser;
    return currentUser;
  }

  Future<void> handleFirebaseAuthError(BuildContext context, String email,
      {bool ignoreEmail = false}) async {
    if (email.isEmpty) {
      return;
    }

    final List<String> providers =
        await _firebaseAuth.fetchSignInMethodsForEmail(email);

    final String provider = providers.single;
    print('provider : $provider');
    // Registered With Email
    if (provider.contains(PsConst.emailAuthProvider) && !ignoreEmail) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message: '[ $email ]\n' +
                    Utils.getString(context,
                        Utils.getString(context, 'auth__email_provider')),
                onPressed: () {});
          });
    }
    // Registered With Google
    else if (provider.contains(PsConst.googleAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message: '[ $email ]\n' +
                    Utils.getString(context,
                        Utils.getString(context, 'auth__google_provider')),
                onPressed: () {});
          });
    }
    // Registered With Facebook
    else if (provider.contains(PsConst.facebookAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message: '[ $email ]\n' +
                    Utils.getString(context,
                        Utils.getString(context, 'auth__facebook_provider')),
                onPressed: () {});
          });
    }
    // Registered With Apple
    else if (provider.contains(PsConst.appleAuthProvider)) {
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message: '[ $email ]\n' +
                    Utils.getString(context,
                        Utils.getString(context, 'auth__apple_provider')),
                onPressed: () {});
          });
    }
  }

  ///
  /// Apple Login Related
  ///
  Future<void> loginWithAppleId(
      BuildContext context, Function onAppleIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Apple Id Login
        ///
        final fb_auth.User firebaseUser =
            await _getFirebaseUserWithAppleId(context);

        if (firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint('User id : ${firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User> resourceUser =
              await _submitLoginWithAppleId(firebaseUser);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onAppleIdSignInSelected != null) {
              onAppleIdSignInSelected(resourceUser.data.userId);
            } else {
              Navigator.pop(context, resourceUser.data);
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null && resourceUser.message != null) {
                    return ErrorDialog(
                      message: resourceUser.message ?? '',
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message:
                    Utils.getString(context, 'login__warning_agree_privacy'),
                onPressed: () {});
          });
    }
  }

  Future<PsResource<User>> _submitLoginWithAppleId(fb_auth.User user) async {
    if (user != null) {
      String email = user.email;
      if (email == null || email == '') {
        // Apple and Facebook
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email.trim() != '') {
              email = user.providerData[i].email;
            }
          }
          // Email Checking
          email ??= '';
        }
      }
      final AppleLoginParameterHolder appleLoginParameterHolder =
          AppleLoginParameterHolder(
              appleId: user.uid,
              userName: user.displayName,
              userEmail: email,
              profilePhotoUrl: user.photoURL,
              deviceToken: psValueHolder.deviceToken);

      final PsResource<User> _apiStatus =
          await postAppleLogin(appleLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        replaceVerifyUserData('', '', '', '');
        replaceLoginUserId(_apiStatus.data.userId);
      }
      return _apiStatus;
    } else {
      return null;
    }
  }

  Future<fb_auth.User> _getFirebaseUserWithAppleId(BuildContext context) async {
    final List<Scope> scopes = <Scope>[Scope.email, Scope.fullName];

    // 1. perform the sign-in request
    final AuthorizationResult result = await AppleSignIn.performRequests(
        <AppleIdRequest>[AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential appleIdCredential = result.credential;

        final OAuthProvider oAuthProvider = OAuthProvider('apple.com');
        final OAuthCredential credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        fb_auth.UserCredential authResult;
        try {
          authResult = await _firebaseAuth.signInWithCredential(credential);
        } on PlatformException catch (e) {
          print(e);

          handleFirebaseAuthError(context, appleIdCredential.email);
          // Fail to Login to Firebase, must return null;
          return null;
        }
        fb_auth.User firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          String displayName;

          displayName = null;

          if (appleIdCredential.fullName.givenName != null) {
            displayName = '${appleIdCredential.fullName.givenName}';
          }

          if (appleIdCredential.fullName.familyName != null) {
            if (displayName != null) {
              displayName = '$displayName ';
            }
            if (displayName != null) {
              displayName += '${appleIdCredential.fullName.familyName}';
            } else {
              displayName = '${appleIdCredential.fullName.familyName}';              
            }
          }

          if (displayName != null && displayName != ' ' && displayName != '') {
            await firebaseUser.updateProfile(displayName: displayName);
          }
        }

        firebaseUser = _firebaseAuth.currentUser;

        return firebaseUser;
      case AuthorizationStatus.error:
        print(result.error.toString());
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
    }
    return null;
  }

  ///
  /// Google Login Related
  ///
  Future<void> loginWithGoogleId(
      BuildContext context, Function onGoogleIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Google Id Login
        ///
        final fb_auth.User firebaseUser = await _getFirebaseUserWithGoogleId();

        if (firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint('User id : ${firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User> resourceUser =
              await _submitLoginWithGoogleId(firebaseUser);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onGoogleIdSignInSelected != null) {
              onGoogleIdSignInSelected(resourceUser.data.userId);
            } else {
              Navigator.pop(context, resourceUser.data);
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null && resourceUser.message != null) {
                    return ErrorDialog(
                      message: resourceUser.message ?? '',
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message:
                    Utils.getString(context, 'login__warning_agree_privacy'),
                onPressed: () {});
          });
    }
  }

  Future<fb_auth.User> _getFirebaseUserWithGoogleId() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();

      //for not select any google acc
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb_auth.User user =
          (await _firebaseAuth.signInWithCredential(credential)).user;
      print('signed in' + user.displayName);
      return user;
    } on Exception {
      print('not select google account');
      return null;
    }
  }

  Future<PsResource<User>> _submitLoginWithGoogleId(fb_auth.User user) async {
    if (user != null) {
      String email = user.email;
      if (email == null || email == '') {
        // Apple and Facebook
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email.trim() != '') {
              email = user.providerData[i].email;
            }
          }
          // Email Checking
          email ??= '';
        }
      }
      final GoogleLoginParameterHolder googleLoginParameterHolder =
          GoogleLoginParameterHolder(
        googleId: user.uid,
        userName: user.displayName,
        userEmail: email,
        profilePhotoUrl: user.photoURL,
        deviceToken: psValueHolder.deviceToken,
      );

      final PsResource<User> _apiStatus =
          await postGoogleLogin(googleLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        replaceVerifyUserData('', '', '', '');
        replaceLoginUserId(_apiStatus.data.userId);
      }

      return _apiStatus;
    } else {
      return null;
    }
  }

  ///
  /// Facebook Login Related
  ///
  Future<void> loginWithFacebookId(
      BuildContext context, Function onFacebookIdSignInSelected) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Facebook Id Login
        ///
        final FacebookLoginUserHolder facebookLoginUserHolder =
            await _getFirebaseUserWithFacebookId(context);

        if (facebookLoginUserHolder != null &&
            facebookLoginUserHolder.firebaseUser != null) {
          ///
          /// Got Firebase User
          ///
          Utils.psPrint(
              'User id : ${facebookLoginUserHolder.firebaseUser.uid}');

          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User> resourceUser =
              await _submitLoginWithFacebookId(facebookLoginUserHolder);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onFacebookIdSignInSelected != null) {
              onFacebookIdSignInSelected(resourceUser.data.userId);
            } else {
              Navigator.pop(context, resourceUser.data);
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null && resourceUser.message != null) {
                    return ErrorDialog(
                      message: resourceUser.message ?? '',
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message:
                    Utils.getString(context, 'login__warning_agree_privacy'),
                onPressed: () {});
          });
    }
  }

  Future<FacebookLoginUserHolder> _getFirebaseUserWithFacebookId(
      BuildContext context) async {
    // Get Keys
    const String yourClientId = PsConfig.fbKey;
    const String yourRedirectUrl =
        'https://www.facebook.com/connect/login_success.html';

    // Get Access Token
    final String result = await Navigator.push(
      context,
      MaterialPageRoute<String>(
          builder: (BuildContext context) => const FacebookLoginWebView(
                selectedUrl:
                    'https://www.facebook.com/dialog/oauth?client_id=$yourClientId&redirect_uri=$yourRedirectUrl&response_type=token&scope=email,public_profile,',
              ),
          maintainState: true),
    );

    // Get User Info Based on the Access Token
    final dynamic graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$result');
    final dynamic profile = json.decode(graphResponse.body);

    // Firebase Base Login
    if (result != null) {
      final AuthCredential credential = FacebookAuthProvider.credential(result);

      try {
        final fb_auth.User user =
            (await _firebaseAuth.signInWithCredential(credential)).user;
        print('signed in' + user.displayName);

        return FacebookLoginUserHolder(user, profile);
        // return user;
      } on PlatformException catch (e) {
        print(e);

        handleFirebaseAuthError(context, profile['email']);

        return null;
      }
    } else {
      return null;
    }
  }

  Future<PsResource<User>> _submitLoginWithFacebookId(
      FacebookLoginUserHolder facebookLoginUserHolder) async {
    final fb_auth.User user = facebookLoginUserHolder.firebaseUser;
    final dynamic facebookUser = facebookLoginUserHolder.facebookUser;
    if (user != null) {
      String email = user.email;
      if (email == null || email == '') {
        // Apple and Facebook
        if (user.providerData.isNotEmpty) {
          for (int i = 0; i < user.providerData.length; i++) {
            if (user.providerData[i].email != null &&
                user.providerData[i].email.trim() != '') {
              email = user.providerData[i].email;
            }
          }
          // Email Checking
          email ??= '';
        }
      }
      final FBLoginParameterHolder fbLoginParameterHolder =
          FBLoginParameterHolder(
        facebookId: user.uid,
        userName: user.displayName,
        userEmail: email,
        profilePhotoUrl: '',
        deviceToken: psValueHolder.deviceToken,
        profileImgId: facebookUser['id'],
      );

      final PsResource<User> _apiStatus =
          await postFBLogin(fbLoginParameterHolder.toMap());

      if (_apiStatus.data != null) {
        replaceVerifyUserData('', '', '', '');
        replaceLoginUserId(_apiStatus.data.userId);
      }

      return _apiStatus;
    } else {
      return null;
    }
  }

  ///
  /// Email Login Related
  ///
  Future<void> loginWithEmailId(BuildContext context, String email,
      String password, Function onProfileSelected) async {
    ///
    /// Check Connection
    ///
    if (await Utils.checkInternetConnectivity()) {
      ///
      /// Get Firebase User with Email Id Login
      ///

      await signInWithEmailAndPassword(context, email, email);

      ///
      /// Show Progress Dialog
      ///
      await PsProgressDialog.showDialog(context);

      ///
      /// Submit to backend
      ///
      final PsResource<User> resourceUser =
          await _submitLoginWithEmailId(email, password);

      ///
      /// Close Progress Dialog
      ///
      PsProgressDialog.dismissDialog();

      if (resourceUser != null && resourceUser.data != null) {
        ///
        /// Success
        ///
        if (onProfileSelected != null) {
          onProfileSelected(resourceUser.data.userId);
        } else {
          Navigator.pop(context, resourceUser.data);
        }
      } else {
        ///
        /// Error from server
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              if (resourceUser != null && resourceUser.message != null) {
                return ErrorDialog(
                  message: resourceUser.message ?? '',
                );
              } else {
                return ErrorDialog(
                  message: Utils.getString(context, 'login__error_signin'),
                );
              }
            });
      }
    } else {
      ///
      /// No Internet Connection
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return ErrorDialog(
              message: Utils.getString(context, 'error_dialog__no_internet'),
            );
          });
    }
  }

  Future<fb_auth.User> signInWithEmailAndPassword(
      BuildContext context, String email, String password) async {
    fb_auth.UserCredential result;

    try {
      result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      print(e);

      final fb_auth.User user = await createUserWithEmailAndPassword(
          context, email, password,
          ignoreHandleFirebaseAuthError: true);

      // Sign In as Dummy User
      if (user == null) {
        try {
          await _firebaseAuth.signInWithEmailAndPassword(
              email: PsConst.defaultEmail, password: PsConst.defaultPassword);
        } on PlatformException catch (e) {
          print(e);
          await createUserWithEmailAndPassword(
              context, PsConst.defaultEmail, PsConst.defaultPassword,
              ignoreHandleFirebaseAuthError: true);
        }
      }

      // Fail to Login to Firebase, must return null;
      return null;
    }

    final fb_auth.User user = result.user;

    print('signInEmail succeeded: $user');

    return user;
  }

  Future<PsResource<User>> _submitLoginWithEmailId(
      String email, String password) async {
    final UserLoginParameterHolder userLoginParameterHolder =
        UserLoginParameterHolder(
      userEmail: email,
      userPassword: password,
      deviceToken: psValueHolder.deviceToken,
    );

    final PsResource<User> _apiStatus =
        await postUserLogin(userLoginParameterHolder.toMap());

    if (_apiStatus.data != null) {
      replaceVerifyUserData('', '', '', '');
      replaceLoginUserId(_apiStatus.data.userId);
    }
    return _apiStatus;
  }

  ///
  /// Email Register Related
  ///
  Future<void> signUpWithEmailId(
      BuildContext context,
      Function onRegisterSelected,
      String name,
      String email,
      String password) async {
    ///
    /// Check User is Accept Terms and Conditions
    ///
    if (isCheckBoxSelect) {
      ///
      /// Check Connection
      ///
      if (await Utils.checkInternetConnectivity()) {
        ///
        /// Get Firebase User with Email Id Login
        ///
        final fb_auth.User firebaseUser =
            await createUserWithEmailAndPassword(context, email, email);

        if (firebaseUser != null) {
          ///
          /// Show Progress Dialog
          ///
          await PsProgressDialog.showDialog(context);

          ///
          /// Submit to backend
          ///
          final PsResource<User> resourceUser = await _submitSignUpWithEmailId(
              context, onRegisterSelected, name, email, password);

          ///
          /// Close Progress Dialog
          ///
          PsProgressDialog.dismissDialog();

          if (resourceUser != null && resourceUser.data != null) {
            ///
            /// Success
            ///
            if (onRegisterSelected != null) {
              await onRegisterSelected(resourceUser.data.userId);
            } else {
              final dynamic returnData = await Navigator.pushNamed(
                  context, RoutePaths.user_verify_email_container,
                  arguments: resourceUser.data.userId);

              if (returnData != null && returnData is User) {
                final User user = returnData;
                if (Provider != null && Provider.of != null) {
                  psValueHolder =
                      Provider.of<PsValueHolder>(context, listen: false);
                }
                psValueHolder.loginUserId = user.userId;
                psValueHolder.userIdToVerify = '';
                psValueHolder.userNameToVerify = '';
                psValueHolder.userEmailToVerify = '';
                psValueHolder.userPasswordToVerify = '';
                print(user.userId);
                Navigator.of(context).pop();
              }
            }
          } else {
            ///
            /// Error from server
            ///
            showDialog<dynamic>(
                context: context,
                builder: (BuildContext context) {
                  if (resourceUser != null && resourceUser.message != null) {
                    return ErrorDialog(
                      message: resourceUser.message ?? '',
                    );
                  } else {
                    return ErrorDialog(
                      message: Utils.getString(context, 'login__error_signin'),
                    );
                  }
                });
          }
        }
        // else{
        //   ///
        //   /// Email Exist
        //   ///
        //   showDialog<dynamic>(
        //       context: context,
        //       builder: (BuildContext context) {
        //         return ErrorDialog(
        //           message: Utils.getString(context, 'register__email_exist')
        //         );
        //       });
        // }
      } else {
        ///
        /// No Internet Connection
        ///
        showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {
              return ErrorDialog(
                message: Utils.getString(context, 'error_dialog__no_internet'),
              );
            });
      }
    } else {
      ///
      /// Not yet agree on Privacy Policy
      ///
      showDialog<dynamic>(
          context: context,
          builder: (BuildContext context) {
            return WarningDialog(
                message:
                    Utils.getString(context, 'login__warning_agree_privacy'),
                onPressed: () {});
          });
    }
  }

  // Future<FirebaseUser> createUserWithEmailAndPassword(
  //     BuildContext context, String email, String password,
  //     {bool ignoreHandleFirebaseAuthError = false}) async {
  //   AuthResult result;
  //   try {
  //     result = await _firebaseAuth.createUserWithEmailAndPassword(
  //         email: email, password: password);
  //   } on PlatformException catch (e) {
  //     print(e);

  //     final FirebaseUser user =
  //         await signInWithEmailAndPassword(context, email, email);
  //     if (user == null) {
  //       if (!ignoreHandleFirebaseAuthError) {
  //         handleFirebaseAuthError(context, email, ignoreEmail: true);
  //       }

  //       // Fail to Login to Firebase, must return null;
  //       return null;
  //     } else {
  //       return user;
  //     }
  //   }

  //   final FirebaseUser user = result.user;

  //   return user;
  // }

  Future<fb_auth.User> createUserWithEmailAndPassword(
      BuildContext context, String email, String password,
      {bool ignoreHandleFirebaseAuthError = false}) async {
    fb_auth.UserCredential result;
    try {
      result = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on PlatformException catch (e) {
      print(e);

      final List<String> providers =
          await _firebaseAuth.fetchSignInMethodsForEmail(email);

      final String provider = providers.single;
      print('provider : $provider');
      // Registered With Email
      if (provider.contains(PsConst.emailAuthProvider)) {
        final fb_auth.User user =
            await signInWithEmailAndPassword(context, email, email);
        if (user == null) {
          if (!ignoreHandleFirebaseAuthError) {
            handleFirebaseAuthError(context, email, ignoreEmail: true);
          }

          // Fail to Login to Firebase, must return null;
          return null;
        } else {
          return user;
        }
      } else {
        if (!ignoreHandleFirebaseAuthError) {
          handleFirebaseAuthError(context, email, ignoreEmail: true);
        }
        return null;
      }
    }

    final fb_auth.User user = result.user;

    return user;
  }
  void change_isVendor(){
    isVendor=!isVendor;
    notifyListeners();
  }
 Future get_data(String email ,String pass)async{
    String name;
   if(isVendor) name='vendor';
   else name='user';

    try{
      _wait_sign=true;
      notifyListeners();
      items= await FirebaseFirestore.instance
        .collection(name)
        .get();
      if(items.docs.length!=0){
     items.docs.forEach((element) {
      if( element['email']==email&&element['password']==pass){
        print("ssssssssssssssssss");
        user_login.id=element['id'].toString();
        user_login.login=true;
        user_login.isVendor=isVendor;
        GlobalAppRepo.isVendor=isVendor;

      }

     });}}
     catch(e){
      print(e);
      print(";;;;;;;;;;;;;");
     }
     finally{
      _wait_sign=false;

       notifyListeners();

     }




  }

  Future<PsResource<User>> _submitSignUpWithEmailId(
      BuildContext context,
      Function onRegisterSelected,
      String name,
      String email,
      String password) async {
    final UserRegisterParameterHolder userRegisterParameterHolder =
        UserRegisterParameterHolder(
      userId: '',
      userName: name,
      userEmail: email,
      userPassword: password,
      userPhone: '',
      deviceToken: psValueHolder.deviceToken,
    );

    final PsResource<User> _apiStatus =
        await postUserRegister(userRegisterParameterHolder.toMap());

    if (_apiStatus.data != null) {
      final User user = _apiStatus.data;

      if (user.status == PsConst.ONE) {
        replaceVerifyUserData('', '', '', '');
        replaceLoginUserId(_apiStatus.data.userId);

        if (onRegisterSelected != null) {
          await replaceVerifyUserData('', '', '', '');
          await replaceLoginUserId(_apiStatus.data.userId);
          await onRegisterSelected(_apiStatus.data.userId);
        } else {
          Navigator.pop(context, _apiStatus.data);
        }
      } else {
        await replaceVerifyUserData(_apiStatus.data.userId,
            _apiStatus.data.userName, _apiStatus.data.userEmail, password);

        psValueHolder.userIdToVerify = user.userId;
        psValueHolder.userNameToVerify = user.userName;
        psValueHolder.userEmailToVerify = user.userEmail;
        psValueHolder.userPasswordToVerify = user.userPassword;
      }
    }
    return _apiStatus;
  }

  Future<dynamic> userLogout(
    Map<dynamic, dynamic> jsonMap,
  ) async {
    isLoading = true;

    isConnectedToInternet = await Utils.checkInternetConnectivity();

    _apiStatus = await _repo.userLogout(
        jsonMap, isConnectedToInternet, PsStatus.PROGRESS_LOADING);

    return _apiStatus;
  }
}
