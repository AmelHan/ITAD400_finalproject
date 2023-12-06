import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MaterialApp(
  title: 'Adventure Game',
  home: AdventureGame(),
));

class Room {
  final String name;
  final String description;
  final String directionNorth;
  final String directionEast;
  final String directionSouth;
  final String directionWest;
  final String item;
  bool isItemPickedUp;

  Room({
    required this.name,
    required this.description,
    required this.directionNorth,
    required this.directionEast,
    required this.directionSouth,
    required this.directionWest,
    this.item = '',
    this.isItemPickedUp = false,
  });
}

class AdventureGame extends StatefulWidget {
  @override
  _AdventureGameState createState() => _AdventureGameState();
}

class _AdventureGameState extends State<AdventureGame> {
  int _currentRoomIndex = 0;
  List<String> _pickedUpItems = [];
  final List<Room> _rooms = [
    Room(
      name: 'Entry Hall',
      description:
      'You are in the Entry Hall. You find yourself in a grand space with a chandelier hanging from the ceiling. You hear the sound of silverware clinking in the east and a faint aroma of old books wafts from the south.',
      directionEast: 'Dining Room',
      directionSouth: 'Library',
      directionNorth: '',
      directionWest: '',
      item: 'key',
    ),
    Room(
      name: 'Dining Room',
      description:
      'You are in the Dining Room. This room is elegantly set for a formal dinner, but there is no one in sight. For culinary secrets, venture south. West is where the story began.',
      directionNorth: '',
      directionWest: 'Entry Hall',
      directionSouth: 'Kitchen',
      directionEast: '',
      item: 'Lantern',
    ),
    Room(
      name: 'Library',
      description:
      'You are in the Library. Shelves upon shelves of old books line the walls. A room of dusty papers and intriguing revelations going east. A draft of cold air comes from the south.',
      directionNorth: 'Entry Hall',
      directionEast: 'Study',
      directionSouth: 'Garden',
      directionWest: '',
      item: 'Book',
    ),
    Room(
      name: 'Kitchen',
      description:
      'You are in the Kitchen. This room smells of freshly baked bread, but there is no one here.The sound of clinking silverware grows louder to the north, suggesting a place where meals might be enjoyed. ',
      directionNorth: 'Dining Room',
      directionEast: '',
      directionSouth: '',
      directionWest: '',
    ),
    Room(
      name: 'Study',
      description:
      'You are in the Study room. A desk covered in dusty papers and a large leather chair dominates the room. To uncover more mysteries, seek the knowledge hidden in the door going west.',
      directionNorth: '',
      directionEast: '',
      directionSouth: '',
      directionWest: 'Library',
    ),
    Room(
      name: 'Garden',
      description:
      'You step into a serene garden with a beautiful fountain in the center. A room full of adventures going north.',
      directionNorth: 'Library',
      directionEast: 'Exit Room',
      directionSouth: '',
      directionWest: '',
      item: 'Map',
    ),
    Room(
      name: 'Exit Room',
      description:
      'Congratulations! You have reached the Exit Room. To win the game, make sure you have picked up all the items before leaving.',
      directionNorth: '',
      directionEast: '',
      directionSouth: '',
      directionWest: 'Garden',
    ),
  ];

  void _navigate(String direction) {
    setState(() {
      String nextRoomDirection;
      switch (direction) {
        case 'North':
          nextRoomDirection = _rooms[_currentRoomIndex].directionNorth;
          break;
        case 'East':
          nextRoomDirection = _rooms[_currentRoomIndex].directionEast;
          break;
        case 'South':
          nextRoomDirection = _rooms[_currentRoomIndex].directionSouth;
          break;
        case 'West':
          nextRoomDirection = _rooms[_currentRoomIndex].directionWest;
          break;
        default:
          nextRoomDirection = '';
          break;
      }

      int nextRoomIndex =
      _rooms.indexWhere((room) => room.name == nextRoomDirection);

      if (nextRoomIndex != -1) {
        _currentRoomIndex = nextRoomIndex;

        if (_rooms[_currentRoomIndex].name == 'Kitchen') {
          _showGameOverDialog();
        }

        if (_rooms[_currentRoomIndex].name == 'Exit Room' &&
            _pickedUpItems.length == 4) {
          _showWinDialog();
        }
      }
    });
  }

  void _pickUpItem() {
    setState(() {
      Room currentRoom = _rooms[_currentRoomIndex];
      if (currentRoom.item.isNotEmpty &&
          !currentRoom.isItemPickedUp &&
          currentRoom.name != 'Kitchen' &&
          currentRoom.name != 'Exit Room' &&
          currentRoom.name != 'Study') {
        _pickedUpItems.add(currentRoom.item);
        currentRoom.isItemPickedUp = true;
      }
    });
  }
  void _showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content: const Text(
              'You have reached the Trap Room. Unfortunately, you lost the game.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Congratulations!'),
          content: const Text(
              'Great job on picking up the 4 items ! you reached the Exit Room. You win!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _resetGame();
              },
              child: const Text('Restart'),
            ),
          ],
        );
      },
    );
  }

  void _resetGame() {
    setState(() {
      _currentRoomIndex = 0;
      _pickedUpItems = [];
      for (Room room in _rooms) {
        room.isItemPickedUp = false;
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    Room currentRoom = _rooms[_currentRoomIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adventure Game'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              'Room: ${currentRoom.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              currentRoom.description,
              style: const TextStyle(fontSize: 16),
            ),
            if (currentRoom.item.isNotEmpty && !currentRoom.isItemPickedUp)
              const SizedBox(height: 20),
            ElevatedButton(
              onPressed: currentRoom.isItemPickedUp ||
                  currentRoom.name == 'Kitchen' ||
                  currentRoom.name == 'Study' ||
                  currentRoom.name == 'Exit Room'
                  ? null
                  : () {
                _pickUpItem();
              },
              child: Text('Pick Up ${currentRoom.item}'),
            ),
            if (_pickedUpItems.isNotEmpty) const SizedBox(height: 20),
            Text(
              'Picked Up Items: ${_pickedUpItems.join(', ')}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                if (currentRoom.directionNorth.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _navigate('North');
                    },
                    child: const Text('Go North'),
                  ),
                if (currentRoom.directionEast.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _navigate('East');
                    },
                    child: const Text('Go East'),
                  ),
                if (currentRoom.directionSouth.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _navigate('South');
                    },
                    child: const Text('Go South'),
                  ),
                if (currentRoom.directionWest.isNotEmpty)
                  ElevatedButton(
                    onPressed: () {
                      _navigate('West');
                    },
                    child: const Text('Go West'),
                  ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (Platform.isAndroid) {
                  SystemNavigator.pop();
                } else {
                  exit(0);
                }
              },
              child: const Text('Exit The Game'),
            ),
          ],
        ),
      ),
    );
  }
}