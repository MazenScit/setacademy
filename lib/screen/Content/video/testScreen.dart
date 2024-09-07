import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:setappstore/Utils/Color.dart';
import 'package:setappstore/controls/quizzes/finish.dart';
import 'package:setappstore/model/quizzes_model.dart';
import 'package:setappstore/screen/Content/Content.dart';
import 'package:setappstore/screen/Content/testresult.dart';
import 'package:setappstore/screen/Content/video/PricingExam.dart';
import 'package:setappstore/screen/my_courses/my_courses_screen.dart';
import 'package:timer_count_down/timer_count_down.dart';

class TestScreen extends StatefulWidget {
  final List<quizzes_model> quizzes;
  const TestScreen({super.key, required this.quizzes});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

int quesion_index = 0;
var ans;
int numPage = 1;
PageController _pageController = PageController();
// احتفظنا باسم المصفوفة _ischecked لتخزين الإجابات
List<String> _ischecked = []; // مصفوفة لتخزين إجابات المستخدم
bool _onFinishButtonPresses = false;
finish_quizzes _finish_quizzes = finish_quizzes();
late List<PricingExam> allquestion = [];

class _TestScreenState extends State<TestScreen> {
  @override
  void initState() {
    // تهيئة مصفوفة الإجابات بناءً على عدد الأسئلة
    _ischecked = List<String>.filled(widget.quizzes[0].questions!.length, "0");

    // تجهيز قائمة الأسئلة
    for (var i = 0; i < widget.quizzes[0].questions!.length; i++) {
      allquestion.add(PricingExam(myquestion: widget.quizzes[0].questions![i], ischecked: _ischecked[i]));
    }

    _onFinishButtonPresses = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 100,
              color: quesion_index == 0 ? Colors.grey[300] : Colors.white,
              child: IconButton(
                  onPressed: decreaseindex,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: quesion_index != 0 ? Colors.grey : Colors.white,
                  ))),
            !_onFinishButtonPresses
                ? ElevatedButton(
                    onPressed: () {
                      // عند الانتهاء، يتم تجهيز _ischecked للإرسال
                      for (var i = 0; i < _ischecked.length; i++) {
                        _ischecked[i] = "\"" + allquestion[i].getreult() + "\"";
                      }
                      setState(() {
                        _onFinishButtonPresses = true;
                      });
                      print("id :" + widget.quizzes[0].id.toString());
                      _finish_quizzes
                          .quiz(widget.quizzes[0].id.toString(), _ischecked)
                          .then((value) {
                        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                          return FinalResult(myvalue: value);
                        }), (route) => false);
                      });
                    },
                    child: Text(
                      'Finish'.tr,
                      style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        minimumSize: const Size(100, 50),
                        primary: Colors.red))
                : MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                        return myCourses();
                      }), (route) => false);
                    },
                    child: Text("go to home page")),
            Container(
              width: 100,
              color: quesion_index == (allquestion.length - 1) ? Colors.grey[300] : Colors.white,
              child: IconButton(
                  onPressed: increaseindex,
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: quesion_index != (allquestion.length - 1) ? Colors.grey : Colors.white,
                  ))),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(Colorbutton),
        title: Text(widget.quizzes[0].title),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Countdown(
                      seconds: int.parse(widget.quizzes[0].duration.toString()) * 60,
                      build: (BuildContext context, double time) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'test duration :  '.tr,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                            CircularCountDownTimer(
                              duration: time.toInt(),
                              initialDuration: 0,
                              controller: CountDownController(),
                              width: 35,
                              height: 70,
                              ringColor: Colors.grey[300]!,
                              fillColor: Color(Colorbutton),
                              backgroundColor: Colors.purple[500],
                              strokeWidth: 10.0,
                              strokeCap: StrokeCap.round,
                              textStyle: TextStyle(fontSize: 13.0, color: Colors.white, fontWeight: FontWeight.bold),
                              textFormat: CountdownTextFormat.S,
                              isReverse: true,
                              isReverseAnimation: true,
                              isTimerTextShown: true,
                              autoStart: true,
                              onStart: () {
                                debugPrint('Countdown Started');
                              },
                              onComplete: () {
                                debugPrint('Countdown Ended');
                                setState(() {
                                  _onFinishButtonPresses = true;
                                });
                                _finish_quizzes.quiz(widget.quizzes[0].id.toString(), _ischecked).then((value) {
                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
                                    return FinalResult(myvalue: value);
                                  }), (route) => false);
                                });
                              },
                            ),
                            Text(
                              '  seconds'.tr,
                              style: TextStyle(fontSize: 20),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                      interval: Duration(milliseconds: 100),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: 30,
                      child: Text((quesion_index + 1).toString() + "/" + widget.quizzes[0].questions!.length.toString()),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 1.55,
                      width: 460,
                      child: allquestion[quesion_index],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // لحفظ الإجابة للمستخدم لكل سؤال في _ischecked
  void saveAnswer(String answer) {
    setState(() {
      _ischecked[quesion_index] = answer;
    });
  }

  // استرجاع الإجابة المخزنة للسؤال الحالي من _ischecked
  String? getAnswerForCurrentQuestion() {
    return _ischecked[quesion_index];
  }

  void increaseindex() {
    if (quesion_index < allquestion.length - 1) {
      setState(() {
        quesion_index++;
      });
    }
    allquestion[quesion_index].getreult();
  }

  void decreaseindex() {
    if (quesion_index > 0) {
      setState(() {
        quesion_index--;
      });
    }
  }
}
