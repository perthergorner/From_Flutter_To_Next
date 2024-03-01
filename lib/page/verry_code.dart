import 'package:fbroadcast/fbroadcast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/common/websocket_api.dart';
import 'package:kirihare/utils/prefs.dart';
import 'package:kirihare/utils/utils.dart';
import 'package:kirihare/widget/dialog_custom_view.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:universal_html/html.dart' as html;
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart' show FirebaseAuthPlatform;

class VerryCodePage extends StatefulWidget {
  VerryCodePage({Key? key, required this.userId, this.phone, this.sendCheck})
      : super(key: key);

  late String userId;
  String? phone;
  String?
      sendCheck; // CODE: màn hình code, PHONE: Màn hình Nhập số điện thoại, NULL cả 2, PHONE_ADD

  @override
  State<VerryCodePage> createState() => _VerryCodePageState();
}

class _VerryCodePageState extends State<VerryCodePage> {
  TextEditingController codeController = TextEditingController();
  bool checkLoginSussce = false;
  bool loading = false;
  bool sendTcodeCheck = false;
  bool addphoneVerry = false;
  String phoneNumber = "";
  String verryID = "";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    phoneNumber = widget.phone ?? '';
    try {
      phoneNumber.length;
    } catch (e) {
      print(e);
      phoneNumber = "";
    }
    regeditCall();
    // send code isNumberPhone
    if (widget.sendCheck != null &&
        widget.sendCheck == 'CODE' &&
        phoneNumber != "") {
      sendcode(phoneNumber);
      setState(() {
        sendTcodeCheck = true;
      });
    } else {
      addphoneVerry = true;
    }
  }

  void regeditCall() {
    FBroadcast.instance().register(Constants.YOU_ARE_CONNECTED,
        (value, callback) {
      gotoChatPage();
      FBroadcast.instance().clear(Constants.YOU_ARE_CONNECTED);
    });
  }

  void gotoChatPage() {
    if (!checkLoginSussce) {
      checkLoginSussce = true;
      closeProgress();
      Navigator.pushNamedAndRemoveUntil(context, '/ChatPage', (route) => false);
    }
  }

  void connectToSocket() {
  }

  void showProgress() {
    setState(() {
      loading = true;
    });
  }

  void closeProgress() {
    setState(() {
      loading = false;
    });
  }

  //send Tcode
  void sendTcode() {
    if (phoneNumber.length < 12) {
      showToast('またはあなたの電話番号を入力してください');
      return;
    }
    sendcode(phoneNumber);
  }

  late ConfirmationResult confirmationResult;
  void sendcode(String phone) async {
    showProgress();
    try {
      if (kIsWeb) {
        confirmationResult = await auth.signInWithPhoneNumber(
            phone,
            RecaptchaVerifier(
              auth: FirebaseAuthPlatform.instance,
              size: RecaptchaVerifierSize.compact,
              theme: RecaptchaVerifierTheme.dark,
              onSuccess: () {
                closeProgress();
                setState(() {
                  sendTcodeCheck = true;
                });
              },
              onError: (FirebaseAuthException error) => closeProgress(),
              onExpired: () => closeProgress(),
            ));
      } else {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phone,
          verificationCompleted: (PhoneAuthCredential credential) {

          },
          verificationFailed: (FirebaseAuthException e) {

          },
          codeSent: (String verificationId, int? resendToken) {
            verryID = verificationId;

            closeProgress();
            setState(() {
              sendTcodeCheck = true;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {

          },
        );
      }
    } catch (e) {
    }
  }

  void verryCode(String code, smscode) async {
    showProgress();
    try {
      if (kIsWeb) {
        await confirmationResult.confirm(smscode).then((value) {
          comfimCodeSussce(true);
        }, onError: (e) {
          comfimCodeSussce(false);
        });
      } else {
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: code, smsCode: smscode);
        // Sign the user in (or link) with the credential
        await auth.signInWithCredential(credential).then((value) {
          comfimCodeSussce(true);
        }).catchError((e) {
          comfimCodeSussce(false);
        });
      }
    } catch (e) {
      closeProgress();
      showToast(
          '電話のクレデンシャルの生成に使用されたSMS確認コードが無効です。確認コードをもう一度SMSで送信し、ユーザーから提供された確認コードを使用してください。！');
    }
  }

  void confirmTcode() {
    if (codeController.text.length < 4 && verryID.length != 0) {
      showToast('コードを入力してください');
      return;
    }
    verryCode(verryID, codeController.text);
  }

  void comfimCodeSussce(bool value) {
    if (kIsWeb) {
      final el =
          html.window.document.getElementById('__ff-recaptcha-container');
      if (el != null) {
        el.style.visibility = 'hidden';
      }
    }
    if (value == false) {
      closeProgress();
    } else {
      closeProgress();
      if (widget.sendCheck != null && widget.sendCheck == 'PHONE_ADD') {
        addphoneSussce();
        Navigator.pop(context);
      } else {
        if (addphoneVerry) {
          addphoneSussce();
        }
        connectToSocket();
      }
    }
  }

  void addphoneSussce() async {
    Common.userPhone = phoneNumber;
    Prefs.save(Constants.PHONE_NUMBER, phoneNumber);
    showProgress();
    await LoginAPI().AddNumberPhone(Common.userId, phoneNumber).then((value) {
      if (value == null || value == false) {
        showToast('エラーが発生しました。しばらくしてからもう一度お試しください'); // add number phone sussce
        closeProgress();
      } else {
        closeProgress();
        showToast('電話番号を追加します'); // add number phone sussce
      }
    });
  }

  String showNumberPhone(String phone) {
    String phoneSub = "";
    try {
      if (phoneNumber.length > 4) {
        phoneSub = phone.substring(phone.length - 4);
        phoneSub = "*" * (phone.length - 4) + phoneSub;
      }
    } catch (e) {
      print(e);
      phoneNumber = "";
      return phoneSub;
    }
    return phoneSub;
  }

  void logout() {
    DialogUtils.showCustomDialog(context, content: "ログアウトしますか？",
        okBtnFunction: () {
      Prefs.save(Constants.PHONE_NUMBER, '');
      Prefs.save(Constants.PASSWORD, '');
      Navigator.pushNamedAndRemoveUntil(
          context, '/LoginPage', (route) => false);
    });
  }

  //継続する //contine
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        titleSpacing: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        actions: [
          if (!Common.userId.contains("SKIPCODE") &&
              widget.sendCheck == 'PHONE_ADD')
            InkWell(
              onTap: () {
                logout();
              },
              child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Center(
                    child: Text(
                      "ログアウト",
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: Colors.white,
                      ),
                    ),
                  )),
            )
        ],
        title: Text(sendTcodeCheck ? "ユーザ認証" : "ツーファクタ認証"),
      ),
      body: ModalProgressHUD(child: buildMain(), inAsyncCall: loading),
    );
  }

  Widget buildMain() {
    return Container(
        padding: EdgeInsets.only(left: 15, right: 10, top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sendTcodeCheck ? "" : "電話番号を設定",
                  style: TextStyle(color: Colors.black38),
                ),
              ],
            ),
            Visibility(
                visible: sendTcodeCheck,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('確認コードは次の宛先に送信されました： '),
                        SizedBox(width: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("${showNumberPhone(phoneNumber)}  "),
                            widget.sendCheck == 'PHONE_ADD'
                                ? InkWell(
                                    onTap: () {
                                      setState(() {
                                        sendTcodeCheck = false;
                                      });
                                    },
                                    child: Text(
                                      '変化する',
                                      style: TextStyle(color: Colors.blue),
                                    ))
                                : Container()
                          ],
                        ),
                        SizedBox(height: 15),
                      ],
                    ))),
            Visibility(
                visible: !sendTcodeCheck,
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 400),
                    opacity: sendTcodeCheck ? 0 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5),
                        Text('電話番号:'),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5)),
                          child: IntlPhoneField(
                            initialValue: phoneNumber,
                            initialCountryCode:
                                phoneNumber.length == 0 ? 'JP' : null,
                            invalidNumberMessage: null,
                            decoration: InputDecoration(
                              labelText: null,
                              filled: true,
                              contentPadding: EdgeInsets.only(top: 13),
                              counter: null,
                              counterText: null,
                              fillColor: Colors.black12,
                              border: InputBorder.none,
                            ),
                            onSaved: (p) {
                              phoneNumber = p!.completeNumber;
                            },
                            onChanged: (phone) {
                              phoneNumber = phone.completeNumber;
                            },
                            onCountryChanged: (country) {
                              setState(() {
                                phoneNumber = '';
                              });
                            },
                          ),
                        )
                      ],
                    ))),
            Visibility(
                visible: sendTcodeCheck,
                child: AnimatedOpacity(
                    duration: Duration(milliseconds: 400),
                    opacity: !sendTcodeCheck ? 0 : 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('確認コード'),
                        SizedBox(height: 5),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(5)),
                          child: TextFormField(
                            controller: codeController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.only(left: 15, right: 15),
                                border: InputBorder.none),
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                            child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('コードを受信していませんか? '),
                            SizedBox(width: 5),
                            InkWell(
                                onTap: sendTcode,
                                child: Text(
                                  'へ送信する',
                                  style: TextStyle(color: Colors.blue),
                                )),
                            SizedBox(height: 5),
                          ],
                        ))
                      ],
                    ))),
            Container(
              margin: EdgeInsets.only(top: 20),
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: sendTcodeCheck ? confirmTcode : sendTcode,
                  child: Text(sendTcodeCheck ? '確認' : "保存")),
            ),
          ],
        ));
  }
}
