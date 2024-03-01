import 'package:fbroadcast/fbroadcast.dart';
import 'package:flutter/material.dart';
import 'package:kirihare/page/verry_code.dart';
import 'package:kirihare/utils/log_utils.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:kirihare/common/api.dart';
import 'package:kirihare/common/common.dart';
import 'package:kirihare/common/constants.dart';
import 'package:kirihare/common/websocket_api.dart';
import 'package:kirihare/utils/prefs.dart';
import 'package:kirihare/utils/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController edtMail = new TextEditingController();
  TextEditingController edtPwd = new TextEditingController();

  bool isChecked = false;
  bool loading = false;
  bool checkLoginSussce = false;

  String userId = '';

  @override
  void initState() {
    restorePrefs();
    getPhoneRestore();

    super.initState();
  }

  void regeditCall() {
    FBroadcast.instance().register(Constants.YOU_ARE_CONNECTED, (value, callback) {
      gotoChatPage();
    });
  }

  void getPhoneRestore() async {
    try {
      // Prefs.restoreを呼び出し、成功すれば結果をCommon.userPhoneに格納
      Common.userPhone = await Prefs.restore(Constants.PHONE_NUMBER);
    } catch (e) {
      // エラーが発生した場合、ここでキャッチされます
      // 必要に応じてエラーログを出力したり、ユーザーに通知したりすることができます
      print('電話番号の復元に失敗しました: $e');
      // エラーが発生してもアプリケーションがクラッシュしないように、
      // ここで処理を続けることができます
    }
  }


  void restorePrefs() async {
    final String? m = Uri.base.queryParameters["m"];
    final String? p = Uri.base.queryParameters["p"];
    final isSlackLogin = (m != null && p != null) || await Prefs.restore(Constants.LAST_LOGIN_IS_SLASK);
    edtMail.text = m ?? await Prefs.restore(Constants.MAIL);
    edtPwd.text = p ?? await Prefs.restore(Constants.PASSWORD);
    if (edtMail.text.isNotEmpty && edtPwd.text.isNotEmpty) {
      login(username: m,pwd: p,isSlackLogin: isSlackLogin);
    }
  }

  void login({String? username, String? pwd,required bool isSlackLogin}) {
    checkLoginSussce = false;
    showProgress();
    LoginAPI().login(username ?? edtMail.text, pwd ?? edtPwd.text, Common.device,isSlackLogin).then((value) {
      if (value == null) {
        showToast('メールアドレスかパスワードが異なります');
        closeProgress();
      } else if ((value.twoPhaseAuth ?? false)) {
        // (value.twoPhaseAuth ?? false)
        if (value.phone != null || value.phone!.isNotEmpty && value.phone!.length > 10) {
          Common.userPhone = value.phone!;
        }
        Common.userId = value.userId!;

        closeProgress();
        FocusScope.of(context).unfocus();
        Prefs.save(Constants.MAIL, edtMail.text);
        Prefs.save(Constants.PASSWORD, edtPwd.text);
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => VerryCodePage(
                  userId: value.userId!,
                  phone: Common.userPhone,
                  sendCheck: "CODE",
                )));
      } else {
        closeProgress();
        FocusScope.of(context).unfocus();
        regeditCall();
        Common.userId = value.userId!;

        connectToSocket();
      }
    });
  }

  void skiplogin() {
    login(username: 'skip', pwd: 'skip',isSlackLogin: false);
  }

  bool isValid() {
    if (edtMail.text.isEmpty) {
      showToast('メールアドレスを入力してください。');
      return false;
    }

    if (edtPwd.text.isEmpty) {
      showToast('パスワードを入力してください。');
      return false;
    }
    return true;
  }

  void gotoChatPage() {
    if (!checkLoginSussce) {
      checkLoginSussce = true;
      closeProgress();
      LogUtils.log("Go to chat page");
      Prefs.save(Constants.MAIL, edtMail.text);
      Prefs.save(Constants.PASSWORD, edtPwd.text);
      Navigator.pushNamedAndRemoveUntil(context, '/ChatPage', (route) => false);
    }
  }

  void connectToSocket() {
    Common.webSocketAPI = new WebSocketAPI();
    Common.webSocketAPI?.init(Common.userId);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: ModalProgressHUD(child: _buildWidget(context), inAsyncCall: loading),
    );
  }

  Widget _buildWidget(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('ユーザログイン'),
          actions: [],
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Container(
          padding: EdgeInsets.only(left: 15, right: 10, top: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // email
              Text('メールアドレス'),
              Container(
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: edtMail,
                  toolbarOptions: ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15, right: 15), border: InputBorder.none),
                ),
              ),
              SizedBox(height: 30),

              // password
              Text('パスワード'),
              Container(
                decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5)),
                child: TextFormField(
                  controller: edtPwd,
                  toolbarOptions: ToolbarOptions(
                    copy: false,
                    cut: false,
                    paste: true,
                    selectAll: false,
                  ),
                  obscureText: true,
                  decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 15, right: 15), border: InputBorder.none),
                ),
              ),
              SizedBox(height: 5),
              // terms and condition
              InkWell(
                onTap: () {
                  skiplogin();
                },
                child: Container(
                  padding: const EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
                  child: Text(
                    "スキップ",
                    style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () {
                      if (isValid()) login(isSlackLogin: false);
                    },
                    child: Text('ログイン')),
              ),
            ],
          ),
        )),
      ),
    );
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
}
