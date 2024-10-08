import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:setappstore/Utils/general_URL.dart';
import 'package:setappstore/model/lessons_model.dart';
import 'package:setappstore/model/question_model.dart';
import 'package:setappstore/model/quizzes_model.dart';
import 'package:setappstore/screen/Content/testresult.dart';
import 'package:setappstore/screen/Content/video/chewieVideoPlayer.dart';
import 'package:setappstore/screen/Content/video/filedownloader.dart';
import 'package:setappstore/screen/Content/video/testScreen.dart';
import 'package:setappstore/screen/Content/video/video.dart';
import 'package:setappstore/screen/Content/video/videoapp.dart';
import 'package:setappstore/screen/my_courses/my_courses_screen.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Utils/Color.dart';
import '../../Utils/imageURL.dart';
import '../../controls/get_control.dart';
import '../../controls/lessons/lessons.dart';
import '../../controls/quizzes/finish.dart';
import '../../controls/quizzes/quizzes.dart';
import '../../controls/quizzes/start.dart';
import '../../model/chapters_model.dart';
import '../../model/files_model.dart';
import '../../model/my_coursee_model.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Content extends StatefulWidget {
  courses_model courses;
  bool show;
  Content({Key? key, required this.courses, required this.show})
      : super(key: key);

  @override
  State<Content> createState() => _ContentState();
}
int trytofail=0;
bool _onFinishButtonPresses=false;
class _ContentState extends State<Content> with SingleTickerProviderStateMixin {
  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  TabController? _tabController;
  PageController _pageController = PageController();
  String isloadingBook = '0';
  get_Control _get_control = get_Control();
  get_lessons _get_lessons = get_lessons();
  get_quizzes _get_quizzes = get_quizzes();
  start_quizzes _start_quizzes = start_quizzes();
  finish_quizzes _finish_quizzes = finish_quizzes();
  List<files_model> _files = [];
  List<new_lessons_model> _lessons = [];
  List<files_model> _books = [];
  List<quizzes_model> _quizzes = [];

  List<String> answer = [];
  // List<question_model> _question = [];
  bool isloading1 = true;
  bool isloading2 = true;
  bool isloading3 = true;
  bool isStart = false;
  var _total;
  int numPage = 1;
  getfiles() {
    _get_control
        .get_files(widget.courses.id.toString())
        .then((value) => setState(() {
              _files = value!;
              isloading2 = false;
            }));
  }

  get_quizzess() {
    _get_quizzes
        .quizzes(widget.courses.id.toString())
        .then((value) => setState(() {
              _quizzes = value!;
              print("_quizzes${_quizzes[0].title}");
              isloading3 = false;
            }));
  }

  // get_question() {
  //   print('get_question');
  //   _get_quizzes
  //       .question(widget.courses.id.toString())
  //       .then((value) => setState(() {
  //             _question = value!;
  //           }));
  // }

  get_lessonss() {
    _get_lessons
        .lessons(widget.courses.id.toString())
        .then((value) => setState(() {
              _lessons = value!;
              isloading1 = false;
            }));
  }

  var ans;
  getbooks(files_model file) async {
    print('object');

    // _get_control.get_books(id).then((value) => setState(() {
    //       _books = value!;
    //       // _download.get_Download(_books[0].file_url.toString());

    //     }));
    // _download
    //     .get(file.file_url.toString(), file.file_name.toString())
    //     .whenComplete(() {
    //   if (_download.state == true) {
    //     setState(() {
    //       isloadingBook = '2';
    //     });
    //   }
    // });
    String fileurl = file.file_url.toString();
    String savename = file.file_name;

    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      //add more permission to request here.
    ].request();

    if (statuses[Permission.storage]!.isGranted) {
      var dir = '/storage/emulated/0/Download/';

      if (dir != null) {
        String savePath = dir + "$savename" + ".pdf";

        try {
          await Dio().download(fileurl, savePath,
              onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
              setState(() {
                _total = (received / total * 100).toStringAsFixed(0) + "%";
              });
            }
            if (_total.toString() == '100%') {
              setState(() {
                isloadingBook = '2';

                Fluttertoast.showToast(
                  msg: "Upload completed".tr,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              });
            }
          });
          print("File is saved to download folder.");
        } on DioError catch (e) {
          print(e.message);
        }
      }
    } else {
      print("No permission to read and write.");
    }
  }

  @override
  void initState() {
    trytofail=0;
    _onFinishButtonPresses=false;
    print(widget.courses.id);
    getfiles();
    get_lessonss();
    get_quizzess();
    secure();
    // get_question();
    // TODO: implement initState
    _tabController = TabController(length: 3, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Container(
            //   padding: EdgeInsets.only(top: 5),
            //   child: Row(
            //     children: [
            //       IconButton(
            //           onPressed: () {
            //             Navigator.pop(context);
            //           },
            //           icon: Icon(Icons.arrow_back_ios))
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  InkWell(
                    child: Icon(
                      Icons.arrow_back,
                    ),
                    onTap: (() {
                      Navigator.pop(context);
                    }),
                  ),
                ],
              ),
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          NetworkImage('${imageUrl + widget.courses.image}'))),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    width: 320,
                    child: Text(
                      widget.courses.title.toString(),
                      style: TextStyle(
                        fontSize: 15,
                        fontFamily: 'Cobe',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                    color: Color(Colorbutton),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                width: double.infinity,
                height: 35,
                child: TabBar(
                  unselectedLabelColor: Colors.white,
                  labelColor: Colors.black,
                  indicatorColor: Colors.black,
                  tabs: [
                    Tab(
                      text: "Sessions".tr,
                    ),
                    Tab(
                      text: "Files".tr,
                    ),
                    Tab(
                      text: "Exams".tr,
                    ),
                  ],
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.white),
                  controller: _tabController,
                  indicatorSize: TabBarIndicatorSize.tab,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  isloading1
                      ? Circular()
                      : _lessons.length == 0
                          ? Center(child: Text('There are no data'.tr))
                          : lessons(),
                  isloading2
                      ? Circular()
                      : _files.length == 0
                          ? Center(child: Text('There are no data'.tr))
                          : files(),
                  isloading3
                      ? Circular()
                      : _quizzes.isEmpty
                          ? Center(child: Text('There are no data'.tr))
                          :  Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'test duration'.tr,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          ' ${_quizzes[0].duration} ',
                                          style: TextStyle(fontSize: 25),
                                        ),
                                        Text(
                                          'minutes'.tr,
                                          style: TextStyle(fontSize: 25),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    ElevatedButton(
                                        onPressed: () {
                                          widget.show
                                              ? {
                                                  ScaffoldMessenger.of(context)
                                                    ..hideCurrentSnackBar()
                                                    ..showSnackBar(SnackBar(
                                                      elevation: 0,
                                                      behavior: SnackBarBehavior
                                                          .floating,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content:
                                                          AwesomeSnackbarContent(
                                                        title:
                                                            'There is no subscription'
                                                                .tr,
                                                        message:
                                                            'Complaint sent successfully'
                                                                .tr,
                                                        contentType:
                                                            ContentType.warning,
                                                      ),
                                                    ))
                                                }
                                              : {
                                                showDialog(context: context, builder: (context2) {
                                                  return AlertDialog(
                                                    shape: RoundedRectangleBorder(
                                                              side: BorderSide(color: Colors.blue),
                                                              borderRadius: BorderRadius.circular(50.0),
                                                            ),
                                                    content: Opacity(
                                                      opacity: 0.6,
                                                      child: Container(
                                                        
                                                        height: 120,
                                                        child: Row(
                                                          children: [
                                                            Icon(Icons.info,size: 70,color: Color(Colorbutton),),
                                                            SizedBox(width: 2,),
                                                            Column(
                                                              children: [
                                                                Text("لا تستطيع التقدم \nلهذا الاختبار الا مرة واحدة",textAlign: TextAlign.center,style: TextStyle(color: Colors.black),),
                                                                SizedBox(height: 5,),
                                                                Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      width: 78,
                                                                      child: MaterialButton(
                                                                        color: Colors.green,
                                                                        child: Text("ok"),
                                                                        onPressed: () {
                                                                          Navigator.of(context2).pop();
                                                                          _start_quizzes
                                                                            .start(
                                                                                _quizzes[0].id
                                                                                    .toString(),
                                                                                context)
                                                                            .whenComplete(() {
                                                                              
                                                                          setState(() {
                                                                            
                                                                            isStart =
                                                                                _start_quizzes.status;
                                                                                if (isStart) {
                                                                                  Navigator.pushAndRemoveUntil(context,
                                                                                      MaterialPageRoute(builder: (context) {
                                                                                    return TestScreen(quizzes:  _quizzes,);
                                                                                  }), (route) => false);
                                                                                  
                                                                                }
                                                                          });
                                                                        });
                                                                      },),
                                                                    ),

                                                                    SizedBox(width: 4,),
                                                    
                                                    
                                                                    Container(
                                                                      width: 78,
                                                                      child: MaterialButton(
                                                                        color: Colors.red,
                                                                        child: Text("cancel"),
                                                                        onPressed: () {
                                                                           Navigator.of(context).pop();
                                                                      },),
                                                                    )
                                                    
                                                    
                                                                  ],
                                                                )
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },)
                                                
                                                };
                                        },
                                        child: Text(
                                          'Start'.tr,
                                          style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                // side: BorderSide(width: 1.0, color: Colors.black),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            minimumSize: const Size(100, 50),
                                            primary: Colors.green)),
                                  ],
                                )
                              
                ],
                controller: _tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container lessons() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _lessons.length,
        itemBuilder: (BuildContext context, int index) {
          return item_lessons(_lessons[index]);
        },
      ),
    );
  }

  Center Circular() {
    return Center(
      child: CircularProgressIndicator(
        color: Color(Colorbutton),
      ),
    );
  }

  Container files() {
    return Container(
      height: 200,
      child: ListView.builder(
        itemCount: _files.length,
        itemBuilder: (BuildContext context, int index) {
          return items(_files[index]);
        },
      ),
    );
  }

  // Container quizzes() {
  //   return Countdown(

  //     seconds: 20,
  //     build: (BuildContext context, double time) => Text(time.toString()),
  //     interval: Duration(milliseconds: 100),
  //     onFinished: () {
  //       print('Timer is done!');
  //     },
  //   );
  // }

  Widget items(files_model file) {
    return Card(
      elevation: 8,
      child: ListTile(
          onTap: () {
            // widget.show
            //     ? {
                //     ScaffoldMessenger.of(context)
                //       ..hideCurrentSnackBar()
                //       ..showSnackBar(SnackBar(
                //         elevation: 0,
                //         behavior: SnackBarBehavior.floating,
                //         backgroundColor: Colors.transparent,
                //         content: AwesomeSnackbarContent(
                //           title: 'There is no subscription'.tr,
                //           message: 'Complaint sent successfully'.tr,
                //           contentType: ContentType.warning,
                //         ),
                //       ))
                //   }
                // : {
                //     setState(() {
                //       isloadingBook = '1';
                //     }),
                //     getbooks(file)
                //   };
          },
          title: Text(
            file.file_name.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontFamily: 'Cobe', fontWeight: FontWeight.bold),
          ),
          trailing: Container(
                          height: 50,
                          width: 80,
                          child: FileDownloader(downloadurl:file.file_url,name:file.file_name)),
                      
          leading: Image.asset(
            logo,
            height: 75,
          ),
          // trailing: isloadingBook == '0'
          //     ? SizedBox()
          //     : isloadingBook == '1'
          //         ? _total.toString() == 'null'
          //             ? CircularProgressIndicator(
          //                 color: Color(Colorbutton),
          //               )
          //             : Text(_total.toString())
          //         : Icon(
          //             Icons.done,
          //             color: Colors.green,
          //           )
                    ),
    );
  }

  Widget item_lessons(new_lessons_model lessons) {
    return Card(
      color: lessons.free?Colors.white:Colors.purple[100],
      elevation: 8,
      child: ListTile(
        onTap: () {
           print(lessons.subscribed.toString());
          // print(lessons.free);
          lessons.free != true
              ? {
                (lessons.subscribed.toString()=="true")?{
                  (lessons.use_resource.toString()=="drive")?{
                    _launchUrl(lessons.drive_url)
                  }:{
                     Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyNewVideoPlayer(url: lessons.video_url,);
                        }))
                  }
                
                        
                        }:{
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'There is no subscription'.tr,
                        message: 'Complaint sent successfully'.tr,
                        contentType: ContentType.warning,
                      ),
                    ))
                }
                }
              :  (lessons.use_resource.toString()=="drive")?{
                    _launchUrl(lessons.drive_url)
                  }:{
                     Navigator.push(context,
                            MaterialPageRoute(builder: (BuildContext context) {
                          return MyNewVideoPlayer(url: lessons.video_url,);
                        }))
                  };
        },
        title: Row(
          children: [
            Container(
              width: 120,
              child: Text(
                lessons.title.toString(),
                style: TextStyle(fontFamily: 'Cobe', fontWeight: FontWeight.bold,fontSize: 10),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            lessons.free
                ? Text(
                    'Free',
                    style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold,fontSize: 19),
                  )
                : Icon(Icons.lock,color: Color(Colorbutton),)
          ],
        ),
        subtitle: Text(
          lessons.description.toString(),
          style: TextStyle(
            fontFamily: 'Cobe',
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        leading: Image.network(
          lessons.poster_url.toString(),
          height: 75,
        ),
        trailing: Text(lessons.duration.toString() + 'm'),
      ),
    );
  }
  Future<void> _launchUrl(String video_Drive_URl) async {
  final Uri _url = Uri.parse(video_Drive_URl);
  if (!await launchUrl(
    _url,
    mode: LaunchMode.externalApplication,
    webViewConfiguration: WebViewConfiguration(
      enableJavaScript: true,
      
    )
    )) {
    throw Exception('Could not launch $_url');
  }
}
}
filtercolor(String studentanswer,String correctanswer,String curruntans){
  
  if ((studentanswer==correctanswer) && (studentanswer==curruntans)) {
    return Colors.green;
  }else if((studentanswer!=correctanswer) && (studentanswer==curruntans)){
    return Colors.red;
  }else if((studentanswer!=correctanswer) && (correctanswer==curruntans)){
     return Colors.green;
  }
  else{
    return Colors.white;
  }
}
