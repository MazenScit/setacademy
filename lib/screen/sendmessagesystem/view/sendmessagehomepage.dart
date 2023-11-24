import 'package:flutter/material.dart';
import 'package:setappstore/screen/sendmessagesystem/controller/mywidget.dart';
import 'package:setappstore/screen/sendmessagesystem/controller/sendmessagecontroller.dart';
import 'package:setappstore/screen/sendmessagesystem/view/checkcode.dart';

class SendAMwssage extends StatefulWidget {
  final String pass;
  const SendAMwssage({super.key, required this.pass});

  @override
  State<SendAMwssage> createState() => _SendAMwssageState();
}

TextEditingController phonecontroller = TextEditingController();

class _SendAMwssageState extends State<SendAMwssage> {
  GlobalKey<FormState> formstate = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.only(top: 5),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios))
                  ],
                ),
              ),
              SizedBox(
                height: 100,
              ),
              textform(phonecontroller, "phone number", TextInputType.phone,
                  (value) {
                if (!(value!.length == 10)) {
                  return "enter a valid phone number";
                }
              }, Icons.numbers),
              SizedBox(
                height: 100,
              ),
              MaterialButton(
                child: Text("send"),
                color: Colors.red,
                onPressed: () {
                  var formdata = formstate.currentState;
                  if (formdata!.validate()) {
                    print("true");
                    String s = sendmessage(phonecontroller.text,widget.pass);
                    Future.delayed(
                      Duration(seconds: 3),
                      () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => CheckCode(
                                      code: s,
                                    )),
                            (Route<dynamic> route) => false);
                      },
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
