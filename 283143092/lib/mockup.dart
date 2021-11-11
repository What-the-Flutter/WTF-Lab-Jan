import 'package:flutter/material.dart';

import 'message.dart';

/// Class with temporary data and methods
///
/// Will be removed in course of development
class Mockup {
  static List<Message> messages = [
    Message(
      'message1',
      DateTime.parse('2021-11-04 03:27:00'),
    ),
    Message(
      'message2',
      DateTime.parse('2021-11-05 04:45:00'),
    ),
    Message(
      'message3',
      DateTime.parse('2021-11-05 04:48:00'),
      'Food',
    ),
    Message(
      'Long message number four (#4) to test adaptable size of the message block.',
      DateTime.parse('2021-11-06 09:30:00'),
    ),
    Message(
      'Even longer message number five (#5) to test line break in the message block. \n\nLorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus ultricies lacus quis metus aliquam, et finibus velit molestie. Duis vitae massa sem. Ut pellentesque felis non est aliquet viverra. Maecenas id condimentum diam. Donec luctus, lorem vel venenatis commodo, odio nisl gravida tellus, id sodales tellus est ullamcorper ex. Pellentesque erat nibh, tristique ultricies varius a, vestibulum at quam. Curabitur lacinia, ante vel lobortis rhoncus, purus mi faucibus mauris, vel euismod ex lorem eu dui. Vestibulum luctus elit id viverra mollis. Etiam sed justo ut orci ultrices luctus. Nulla facilisi. Donec sed sollicitudin purus. Proin commodo, arcu et sagittis vulputate, tellus orci malesuada massa, eget egestas dolor purus vel sapien. Praesent leo velit, facilisis ut metus non, pretium vulputate metus. Donec tempus tincidunt tellus, sed hendrerit orci efficitur eget. Aliquam non ex nec justo sollicitudin laoreet. Pellentesque efficitur consequat tortor.',
      DateTime.parse('2021-11-06 03:19:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
    Message(
      'message',
      DateTime.parse('2021-11-07 04:48:00'),
    ),
  ];

  static void mockup(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
