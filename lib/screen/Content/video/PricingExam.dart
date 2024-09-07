import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart';
import 'package:setappstore/Utils/Color.dart';
import 'package:setappstore/model/question_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
class PricingExam extends StatefulWidget {
  
  getreult(){
    return ischecked.toString();
    
  }
  String ischecked;
  final question_model myquestion;
   PricingExam({super.key, required this.myquestion,required this.ischecked});

  @override
  State<PricingExam> createState() => _PricingExamState();
  
}

class _PricingExamState extends State<PricingExam> {
  void _reloadWebView() {
    print('ss');
    setState(() {
      _webViewKey = UniqueKey(); // تحديث مفتاح WebView
    });
  }
  
  String _buildHtmlString(String content) {

    _reloadWebView();
   return '''
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1.0, user-scalable=no">
        <style>
        body{
          background:white;
          overflow:auto;
        }
        p,div,span{
          font-size:14px !important;
        }

        .content{
            max-height:100px;
            overflow:auto;
        }

          .content::-webkit-scrollbar {
            width: 5px;
          }

          .content::-webkit-scrollbar-track {
            box-shadow: inset 0 0 5px grey; 
            border-radius: 5px;
          }
          
          .content::-webkit-scrollbar-thumb {
            background: #4c3192; 
            border-radius: 5px;
          }

          .content::-webkit-scrollbar-thumb:hover {
            background: #b30000; 
          }
        
        </style>
        </head>
        <body>
        <div class="content">
        $content
        </body>
        </body>
        </html>
      ''';

  }

 @override
  void initState() {
    print(base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.question))));
    super.initState();
  }
  @override
 
  Widget build(BuildContext context) {
    
    // var width= MediaQuery.of(context).size.width;
   var height= MediaQuery.of(context).size.height;
    return Scaffold(
      
      backgroundColor: Color(Colorbutton),
      
      body: 
      Container(
        child: Column(
          children: [
            Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
               
                     Container(
                      alignment: Alignment.center,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        margin:  EdgeInsets.all(10),
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Container(
                              height: 100,
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width-50,
                              // child: Text(widget.myquestion.question??"",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
                              // child: Html(
                              //           data: widget.myquestion.question??"",
                              //         ),
                               child:  WebView(
                                
                                        key: _webViewKey,
                                        initialUrl:
                                            'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.question)))}',
                                        javascriptMode: JavascriptMode.unrestricted,
                                        backgroundColor: Colors.white,

                                      ),
                                    ),
                              
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              color: widget.ischecked=="a"?Color(Colorbutton):Colors.white,
                              child: InkWell(
                                onTap: () {
                                  
                                 setState(() {
                                  widget.ischecked="a";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                    activeColor: Colors.red,
                                    value: "a", groupValue: widget.ischecked, onChanged: (value) {
                                      setState(() {
                                        
                                        widget.ischecked=value!;
                                      });
                                      },),
                                    Container(
                                      width: 240,
                                      height: 70,
                                      child: 
                                      // Html(
                                      //   data: (widget.myquestion.a??""),
                                      //   style: {
                                      //         'body': Style(
                                      //           color: widget.ischecked=="a"?Colors.white:Colors.black
                                      //         ),
                                      //       },
                                      // ),
                                      WebView(
                                        key: _webViewKey,
                                        initialUrl:
                                            'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.a)))}',
                                        javascriptMode: JavascriptMode.unrestricted,
                                        backgroundColor: Colors.white,
                                      ),
                                      //  Text("1-"+extractTextFromHtml(widget.myquestion.a).replaceAll("\n", '').replaceAll("\r", '') ,style: TextStyle(fontSize: 15,color: widget.ischecked!="a"?Color(Colorbutton):Colors.white))
                                      ),
                                  ],
                                )),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              color: widget.ischecked=="b"?Color(Colorbutton):Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                  widget.ischecked="b";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                      
                                    activeColor: Colors.red,
                                    value: "b", groupValue: widget.ischecked, onChanged: (value) {
                                      setState(() {
                                        widget.ischecked=value!;
                                      });
                                      },),
                                    Container(
                                      height: 70,
                                      width: 240,
                                      // child: Text("2-"+(widget.myquestion.b??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="b"?Color(Colorbutton):Colors.white))
                                      child: 
                                      WebView(
                                        key: _webViewKey,
                                        initialUrl:
                                            'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.b)))}',
                                        javascriptMode: JavascriptMode.unrestricted,
                                        backgroundColor: Colors.white,
                                      ),
                                      // Html(
                                      //   data: (widget.myquestion.b??""),
                                      //    style: {
                                      //         'body': Style(
                                      //           color: widget.ischecked=="b"?Colors.white:Colors.black
                                      //         ),
                                      //       },
                                      // ),
                                      ),
                                  ],
                                )),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              color: widget.ischecked=="c"?Color(Colorbutton):Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                  widget.ischecked="c";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                    activeColor: Colors.red,
                                    value: "c", groupValue: widget.ischecked, onChanged: (value) {
                                      setState(() {
                                        widget.ischecked=value!;
                                      });
                                      },),
                                    Container(
                                      height: 70,
                                      width: 240,
                                      // child: Text("3-"+(widget.myquestion.c??""),style: TextStyle(fontSize: 15,color:  widget.ischecked!="c"?Color(Colorbutton):Colors.white))
                                      child:
                                       WebView(
                                        key: _webViewKey,
                                        initialUrl:
                                            'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.c)))}',
                                        javascriptMode: JavascriptMode.unrestricted,
                                        backgroundColor: Colors.white,
                                      ), 
                                      // Html(
                                      //   data: (widget.myquestion.c??""),
                                      //   style: {
                                      //         'body': Style(
                                      //           color: widget.ischecked=="c"?Colors.white:Colors.black
                                      //         ),
                                      //       },
                                      // ),
                                      ),
                                  ],
                                )),
                            ),
        
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 2),
                              color: widget.ischecked=="d"?Color(Colorbutton):Colors.white,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                 widget.ischecked="d";
                                  });
                                },
                                child: Row(
                                  children: [
                                    Radio(
                                    activeColor: Colors.red,
                                    value: "d", groupValue: widget.ischecked, onChanged: (value) {
                                      setState(() {
                                        widget.ischecked=value!;
                                      });
                                      },),
                                    Container(
                                      height: 70,
                                      width: 240,
                                      // child: Text("4-"+((widget.myquestion.d)??""),style: TextStyle(fontSize: 15,color: widget.ischecked!="d"?Color(Colorbutton):Colors.white))
                                      child:
                                       WebView(
                                        key: _webViewKey,
                                        initialUrl:
                                            'data:text/html;base64,${base64Encode(utf8.encode(_buildHtmlString(widget.myquestion.d)))}',
                                        javascriptMode: JavascriptMode.unrestricted,
                                        backgroundColor: Colors.white,
                                      ),
                                      //  Html(
                                      //   data: ((widget.myquestion.d)??""),
                                      //   style: {
                                      //         'body': Style(
                                      //           color: widget.ischecked=="d"?Colors.white:Colors.black
                                      //         ),
                                      //       },
                                      // ),
                                      ),
                                  ],
                                )),
                            ),
                            
                            
                          ],
              
                        ),
                      )),
                
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
  String extractTextFromHtml(String htmlString) {
  final document = parse(htmlString); 
  return parse(document.body!.text).documentElement!.text;
}
 
}



Future<void> _launchUrl(String url) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(
    _url,
    mode: LaunchMode.inAppWebView
    )) {
    throw Exception('Could not launch $_url');
  }
  
}
 Key _webViewKey = UniqueKey();