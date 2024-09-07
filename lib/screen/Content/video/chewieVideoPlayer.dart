import 'package:flutter/material.dart';
import 'package:setappstore/Utils/Color.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';


class MyNewVideoPlayer extends StatelessWidget {
  const MyNewVideoPlayer({super.key, required this.url,});
  final String url;
  @override
  Widget build(BuildContext context) {
    return MyVideoPlayer(url: url,);
  }
}

class MyVideoPlayer extends StatefulWidget {
  final String url;
  const MyVideoPlayer({super.key, required this.url,});
  @override
  _MyVideoPlayerState createState() => _MyVideoPlayerState();
}
bool _isPlaying = false;
class _MyVideoPlayerState extends State<MyVideoPlayer> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
   

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.network(
      widget.url.toString());
    _chewieController = ChewieController(
     autoInitialize: true,
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      fullScreenByDefault: true,
      customControls: Builder(
        builder: (context) {
          return Column(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Stack(
                    children: [
                      Align(
                  alignment: Alignment.bottomCenter,
                  child: VideoProgressIndicator(
                    _videoPlayerController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.red,
                      bufferedColor: Colors.grey,
                      backgroundColor: Colors.black26,
                    ),
                  ),
                          ),
                          Align(
                  alignment: Alignment.bottomCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.fullscreen,color: Colors.white,size: 35,),
                        onPressed: () {
                          setState(() {
                            _chewieController.enterFullScreen();
                          });
                        },
                      ),
                       IconButton(
                      icon: Icon(Icons.play_arrow,color: Colors.white,size: 35,),
                      onPressed: () {
                        setState(() {
                          _videoPlayerController.play();
                          _isPlaying = true;
                        });
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.pause,color: Colors.white,size: 35,),
                      onPressed: () {
                        setState(() {
                          _videoPlayerController.pause();
                          _isPlaying = false;
                        });
                      },
                    ),
                      
                    ],
                  ),
                          )
                    ],
                  ),
                )
                
              ),
             
            ],
          );
        }
      ),
    );
   
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
     appBar: AppBar(
      backgroundColor: Color(Colorbutton),
      title: Text("video"),
     ),
      body: Center(
        child: Chewie(
          controller: _chewieController,
        ),
      ),
    );
  }
}
