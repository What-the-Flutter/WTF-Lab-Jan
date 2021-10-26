import 'package:flutter/material.dart';

class BottomNavigation extends StatefulWidget{

  @override
  _BottomNavigationState createState() => _BottomNavigationState();

}

class _BottomNavigationState extends State<BottomNavigation>{
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      items: [
        const BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: ('Home'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: ('Daily'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.exposure),
          label: ('Timeline'),
        ),
        const BottomNavigationBarItem(
          icon: Icon(Icons.api),
          label: ('Explore'),
        )
      ],
      onTap: (index) {
        setState((){
          selectedIndex = index;
          _navigateToMenuScreen();
        });
      },
    );
  }

  void _navigateToMenuScreen()  {
    if(selectedIndex == 0) {
      Navigator.pushNamed(context, '/');
    } else if(selectedIndex==1) {
      Navigator.pushNamed(context, '/daily');
    } else if(selectedIndex==2){
      Navigator.pushNamed(context, '/timeline');
    } else if(selectedIndex==3){
      Navigator.pushNamed(context, '/explore');
    }
  }
}


Widget _buildAppBarLeftButton(){
  return IconButton(
      icon: const Icon(Icons.menu_outlined),
      onPressed: () {
        print('Click on menu outlined button');
      }
  );
}

class DailyScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _createAppBarTitle(),
        leading: _buildAppBarLeftButton(),
        actions: <Widget> [
          _buildAppBarRightButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _createAppBarTitle(){
    return const Align(
      child: Text('Daily'),
      alignment: Alignment.center,
    );
  }

  Widget _buildAppBarRightButton(){
    return IconButton(
      icon: const Icon(Icons.menu_open),
      onPressed: () => {
        print('Click on open menu button')
      },
    );
  }

}

class TimelineScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _createAppBarTitle(),
        leading: _buildAppBarLeftButton(),
        actions: <Widget> [
          _buildAppBarSearchButton(),
          _buildAppBarNoteButton(),
        ],
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _buildAppBarSearchButton(){
    return IconButton(
      icon: const Icon(Icons.search),
      onPressed: () => {
        print('Click on open menu button')
      },
    );
  }

  Widget _buildAppBarNoteButton(){
    return IconButton(
      icon: const Icon(Icons.note),
      onPressed: () => {
        print('Click on note button')
      },
    );
  }

  Widget _createAppBarTitle(){
    return const Align(
      child: Text('Timeline'),
      alignment: Alignment.center,
    );
  }

}

class ExploreScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _createAppBarTitle(),
        leading: _buildAppBarLeftButton(),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Widget _createAppBarTitle(){
    return const Align(
      child: Text('Explore'),
      alignment: Alignment.topLeft,
    );
  }

}