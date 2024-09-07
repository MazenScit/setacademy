import 'package:dio/dio.dart';
import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:setappstore/Utils/Color.dart';


class FileDownloader extends  StatefulWidget {
  final String downloadurl;
  final String name;
 
  const FileDownloader({super.key, required this.downloadurl, required this.name});

  @override
  State<FileDownloader> createState() => _FileDownloaderState();
}

class _FileDownloaderState extends State<FileDownloader> {
  bool ispressed=false;
   bool notpdf=false;
  @override
  void initState() {
    if (widget.downloadurl.contains(".pdf")) {
                            setState(() {
                            notpdf=true;
                            });
                         }
    fileurl=widget.downloadurl;
    print(fileurl);
    super.initState();
  }
    int myreceived=0;
    int mytotal=0;
    bool dowloadprogress=false;
  late String fileurl;
  //you can save other file formats too.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: 
          notpdf?
          (myreceived / mytotal * 100)!=100?
          !dowloadprogress?
          
          Center(
            child: 
            !ispressed?
            ElevatedButton(
              style: ButtonStyle(
                 backgroundColor: MaterialStateProperty.all(Color(Colorbutton)),    
              ),
               onPressed: () async {
                setState(() {
                  ispressed=true;
                });
                  Map<Permission, PermissionStatus> statuses = await [
                      Permission.storage, 
                      //add more permission to request here.
                  ].request();
          
                  if(statuses[Permission.storage]!.isGranted){ 
                      var dir = await DownloadsPathProvider.downloadsDirectory;
                      if(dir != null){
                        
                            String savename = widget.name;
                            String savePath = dir.path + "/$savename.pdf";
          
                            
                            print(savePath);
                            //output:  /storage/emulated/0/Download/banner.png
          
                                await Dio().download(
                                    fileurl, 
                                    savePath,
                                    onReceiveProgress: (received, total) {
                                     myreceived=received;
                                     mytotal=total;
                                        if (total != -1) {
                                          print(received);
          
                                            print((received / total * 100).toStringAsFixed(0) + "%");
                                            setState(() {
                                              dowloadprogress=true;
                                            });
                                            //you can build progressbar feature too
                                        }
                                      });
                                 print("File is saved to download folder.");  
                      }
                  }else{
                     print("No permission to read and write.");
                  }
          
               },
               child: Text("بدء التحميل",style: TextStyle(fontSize: 9,color: Colors.white),),
            ):CircularProgressIndicator(),
          ):Center(child: Text((myreceived / mytotal * 100).toStringAsFixed(0) + "%",style: TextStyle(color: Color(Colorbutton)),))
          :ElevatedButton(
            style: ButtonStyle(
               backgroundColor: MaterialStateProperty.all(Colors.green),    
            ),
            child: Text("افتح الملف",style: TextStyle(color: Colors.white,fontSize: 9),),
            
            onPressed: () async {
            var dir = await DownloadsPathProvider.downloadsDirectory;
            OpenFilex.open(dir!.path + "/"+widget.name+".pdf");
          },):Center(child: Text("pdf الملف ليس بصيغة",style: TextStyle(color: Colors.white,fontSize: 10),)));
  }
}