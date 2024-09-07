import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:get/get.dart';
import 'package:setappstore/controls/my_courses/my_courses.dart';
import 'package:setappstore/model/my_coursee_model.dart';
import 'package:setappstore/screen/my_courses/my_courses_screen.dart';
import 'package:setappstore/screen/my_courses/subjectdetails.dart';

import '../../Utils/Color.dart';
import '../courses_screen.dart';

class UserCourses extends StatefulWidget {
  UserCourses({Key? key,}) : super(key: key);

  @override
  State<UserCourses> createState() => _UserCoursesState();
}
get_my_courses _get_my_courses=get_my_courses();
List<my_coursee_model> List_my_courses = [];
bool isloading=true;
class _UserCoursesState extends State<UserCourses> {
  secure() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
 Future<void> my_courses() async {
    setState(() {
      isLoading = true;
    });
    _get_my_courses.my_courses().then((value) {
      setState(() {
        List_my_courses = value!;
        isLoading = false;
      });
    });
  }
  @override
  void initState() {
    
    secure();
    my_courses();
    // TODO: implement initState
    super.initState();
  }
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  Widget build(BuildContext context) {
    double wi = MediaQuery.of(context).size.width;
    double hi = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: RefreshIndicator(
        key: _refreshIndicatorKey,
            onRefresh: my_courses,
        child: Column(
          children: [
            Container(
              height: hi / 1.6,
              child: GridView.builder(
                itemCount: List_my_courses.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: (1.1), crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  List<my_coursee_model> my_Coueses_item = List_my_courses;
                  return items(my_Coueses_item[index]);
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(20),
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Courses();
                    }));
                  },
                  child: Text(
                    'Subscribe to a course'.tr,
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: 'Cobe',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                   style: ElevatedButton.styleFrom(
                      primary: Color(Colorbutton), // لون الخلفية
                      onPrimary: Colors.white, // لون النص
                      elevation: 8, // الارتفاع
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15), // الهامش الداخلي
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // شكل الحواف
                      ),
                    ),
              ),
            ),
                    
          ],
        ),
      ),
    );
  }

  Widget items(my_coursee_model my_Courses) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return subjectdetails(
            my_coursee: my_Courses,
            show: false,
          );
        }));
      },
      child: Card(
        elevation: 8,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Image.network(
              my_Courses.image.toString(),
              height: 100,
            ),
            Text(
              my_Courses.title.toString(),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontFamily: 'Cobe', fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
