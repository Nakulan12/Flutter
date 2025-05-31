import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '🎵 Vibrant Music Player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.purpleAccent,
      ),
      home: HomeScreen(),
    );
  }
}
final List<Map<String, String>> songs = [
  {"title": "Shape of You", "artist": "Ed Sheeran"},
  {"title": "Blinding Lights", "artist": "The Weeknd"},
  {"title": "Levitating", "artist": "Dua Lipa"},
  {"title": "Perfect", "artist": "Ed Sheeran"},
  {"title": "Stay", "artist": "Justin Bieber"},
];

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("🎧 My Music Library", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.deepPurpleAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.playlist_play),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => PlaylistScreen()));
            },
          )
        ],
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (_, index) {
          return Card(
            color: Colors.grey.shade900,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: Icon(Icons.music_note, color: Colors.purpleAccent, size: 30),
              title: Text(songs[index]['title']!, style: TextStyle(fontSize: 18)),
              subtitle: Text(songs[index]['artist']!, style: TextStyle(color: Colors.grey)),
              trailing: Icon(Icons.play_arrow, color: Colors.white),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NowPlayingScreen(
                        songTitle: songs[index]['title']!,
                        artist: songs[index]['artist']!,
                      ),
                    ));
              },
            ),
          );
        },
      ),
    );
  }
}

class NowPlayingScreen extends StatefulWidget {
  final String songTitle;
  final String artist;

  NowPlayingScreen({required this.songTitle, required this.artist});

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen>
    with SingleTickerProviderStateMixin {
  double _currentSliderValue = 0.0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 2))
          ..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      isPlaying = !isPlaying;
      isPlaying ? _controller.repeat(reverse: true) : _controller.stop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("Now Playing"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.deepPurple.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
        child: Column(
          children: [
            ScaleTransition(
              scale: _animation,
              child: Container(
                height: 250,
                width: 250,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purpleAccent.withOpacity(0.6),
                      blurRadius: 30,
                      spreadRadius: 10,
                    )
                  ],
                  gradient: RadialGradient(
                    colors: [Colors.purpleAccent, Colors.deepPurple],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.music_note, size: 100, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              widget.songTitle,
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              widget.artist,
              style: TextStyle(color: Colors.grey[400], fontSize: 18),
            ),
            SizedBox(height: 40),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.purpleAccent,
                thumbColor: Colors.purpleAccent,
                overlayColor: Colors.purple.withOpacity(0.3),
              ),
              child: Slider(
                value: _currentSliderValue,
                min: 0,
                max: 100,
                onChanged: (value) {
                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
            ),
            Text("${_currentSliderValue.toInt()} sec",
                style: TextStyle(color: Colors.grey)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.skip_previous, size: 40, color: Colors.white),
                GestureDetector(
                  onTap: _togglePlayPause,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isPlaying ? Colors.deepPurple : Colors.purpleAccent,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.purpleAccent.withOpacity(0.6),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: Icon(
                      isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Icon(Icons.skip_next, size: 40, color: Colors.white),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PlaylistScreen extends StatelessWidget {
  final List<String> playlists = [
    "💖 Love Songs",
    "🏋️ Workout Hits",
    "🌧️ Rainy Day",
    "🔥 Party Vibes",
    "🎮 Gaming Tracks",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Playlists")),
      body: ListView.builder(
        itemCount: playlists.length,
        itemBuilder: (_, index) {
          return Card(
            color: Colors.deepPurple.shade800,
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: ListTile(
              leading: Icon(Icons.queue_music, color: Colors.white),
              title: Text(playlists[index], style: TextStyle(fontSize: 18)),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.white70),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Opening '${playlists[index]}'...")),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
