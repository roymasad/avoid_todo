import 'dart:math';

import 'package:flutter/material.dart';

import '../model/break_session.dart';
import '../model/todo.dart';

class BreakTriviaPrompt {
  final String question;
  final List<String> options;
  final int answerIndex;
  final String insight;

  const BreakTriviaPrompt({
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.insight,
  });
}

class BreakActivityDefinition {
  final BreakActivityType type;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const BreakActivityDefinition({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}

class BreakHelper {
  BreakHelper._();

  static const int xpHelpfulBreak = 5;
  static const String sourceHelpfulBreak = 'helpful_break';

  static const List<BreakActivityDefinition> _definitions = [
    BreakActivityDefinition(
      type: BreakActivityType.defuse,
      title: 'Defuse',
      subtitle: 'Burn off the edge by disarming the moment.',
      icon: Icons.bolt_rounded,
      color: Color(0xFFE85D04),
    ),
    BreakActivityDefinition(
      type: BreakActivityType.pairMatch,
      title: 'Pair Match',
      subtitle: 'Shift your mind into a tiny memory challenge.',
      icon: Icons.grid_view_rounded,
      color: Color(0xFF2A9D8F),
    ),
    BreakActivityDefinition(
      type: BreakActivityType.stackSweep,
      title: 'Stack Sweep',
      subtitle: 'Peel away the exposed tiles until the pile is gone.',
      icon: Icons.view_quilt_rounded,
      color: Color(0xFF8D6E63),
    ),
    BreakActivityDefinition(
      type: BreakActivityType.triviaPivot,
      title: 'Trivia Pivot',
      subtitle: 'Give your brain something else to chew on.',
      icon: Icons.lightbulb_outline_rounded,
      color: Color(0xFF6A4C93),
    ),
    BreakActivityDefinition(
      type: BreakActivityType.zenRoom,
      title: 'Zen Room',
      subtitle: 'Slow the scene down and reset the tone.',
      icon: Icons.spa_outlined,
      color: Color(0xFF4D908E),
    ),
  ];

  static const List<BreakTriviaPrompt> triviaPrompts = [
    BreakTriviaPrompt(
      question: 'Which planet has the shortest day?',
      options: ['Earth', 'Jupiter', 'Mars'],
      answerIndex: 1,
      insight: 'Jupiter spins so fast its day is roughly 10 hours.',
    ),
    BreakTriviaPrompt(
      question: 'How many hearts does an octopus have?',
      options: ['One', 'Two', 'Three'],
      answerIndex: 2,
      insight: 'Three. Two for the gills and one for the body.',
    ),
    BreakTriviaPrompt(
      question: 'What is the only mammal that can truly fly?',
      options: ['Flying squirrel', 'Bat', 'Sugar glider'],
      answerIndex: 1,
      insight: 'Bats are the only mammals capable of sustained flight.',
    ),
    BreakTriviaPrompt(
      question: 'Which ocean is the deepest?',
      options: ['Atlantic', 'Indian', 'Pacific'],
      answerIndex: 2,
      insight: 'The Mariana Trench is in the Pacific Ocean.',
    ),
    BreakTriviaPrompt(
      question: 'How many bones does an adult human usually have?',
      options: ['206', '186', '226'],
      answerIndex: 0,
      insight: '206 is the standard count after bones fuse in adulthood.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is known for sleeping upside down?',
      options: ['Bat', 'Koala', 'Otter'],
      answerIndex: 0,
      insight: 'Bats roost upside down to launch into flight quickly.',
    ),
    BreakTriviaPrompt(
      question: 'What gas do plants mostly absorb from the air?',
      options: ['Oxygen', 'Carbon dioxide', 'Helium'],
      answerIndex: 1,
      insight: 'Plants use carbon dioxide during photosynthesis.',
    ),
    BreakTriviaPrompt(
      question: 'Which instrument usually has 88 keys?',
      options: ['Violin', 'Piano', 'Flute'],
      answerIndex: 1,
      insight: 'A standard piano has 88 keys.',
    ),
    BreakTriviaPrompt(
      question: 'How many sides does a hexagon have?',
      options: ['5', '6', '8'],
      answerIndex: 1,
      insight: 'Hex means six.',
    ),
    BreakTriviaPrompt(
      question: 'Which bird is often associated with delivering messages?',
      options: ['Pigeon', 'Parrot', 'Owl'],
      answerIndex: 0,
      insight:
          'Carrier pigeons were used to send messages over long distances.',
    ),
    BreakTriviaPrompt(
      question: 'What is the largest organ in the human body?',
      options: ['Skin', 'Liver', 'Lungs'],
      answerIndex: 0,
      insight: 'Your skin is the body’s largest organ.',
    ),
    BreakTriviaPrompt(
      question: 'Which chess piece can move in an L shape?',
      options: ['Bishop', 'Knight', 'Rook'],
      answerIndex: 1,
      insight: 'The knight is the only chess piece that jumps in an L pattern.',
    ),
    BreakTriviaPrompt(
      question: 'How many continents are there?',
      options: ['5', '6', '7'],
      answerIndex: 2,
      insight: 'The standard model counts seven continents.',
    ),
    BreakTriviaPrompt(
      question: 'What do bees collect from flowers?',
      options: ['Nectar', 'Pebbles', 'Salt'],
      answerIndex: 0,
      insight: 'Bees collect nectar and pollen from flowers.',
    ),
    BreakTriviaPrompt(
      question: 'Which month has the fewest days?',
      options: ['February', 'April', 'November'],
      answerIndex: 0,
      insight: 'February is shortest, with 28 days in most years.',
    ),
    BreakTriviaPrompt(
      question: 'Which sport uses a shuttlecock?',
      options: ['Tennis', 'Badminton', 'Squash'],
      answerIndex: 1,
      insight: 'Badminton uses a shuttlecock instead of a ball.',
    ),
    BreakTriviaPrompt(
      question: 'What color do you get by mixing blue and yellow?',
      options: ['Green', 'Purple', 'Orange'],
      answerIndex: 0,
      insight: 'Blue and yellow combine to make green.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet is famous for its rings?',
      options: ['Saturn', 'Venus', 'Mercury'],
      answerIndex: 0,
      insight: 'Saturn’s rings are its most recognizable feature.',
    ),
    BreakTriviaPrompt(
      question: 'How many minutes are in two hours?',
      options: ['90', '120', '180'],
      answerIndex: 1,
      insight: 'Two hours equals 120 minutes.',
    ),
    BreakTriviaPrompt(
      question: 'Which sea creature has eight arms?',
      options: ['Squid', 'Starfish', 'Octopus'],
      answerIndex: 2,
      insight: 'Octopuses have eight arms; squid have ten appendages.',
    ),
    BreakTriviaPrompt(
      question: 'What is frozen water called?',
      options: ['Steam', 'Mist', 'Ice'],
      answerIndex: 2,
      insight: 'Ice is water in solid form.',
    ),
    BreakTriviaPrompt(
      question: 'Which direction does the sun rise from?',
      options: ['North', 'East', 'West'],
      answerIndex: 1,
      insight: 'The sun appears to rise in the east.',
    ),
    BreakTriviaPrompt(
      question: 'Which mammal spends most of its life in the ocean?',
      options: ['Whale', 'Camel', 'Fox'],
      answerIndex: 0,
      insight: 'Whales are marine mammals.',
    ),
    BreakTriviaPrompt(
      question: 'What shape has three sides?',
      options: ['Triangle', 'Circle', 'Rectangle'],
      answerIndex: 0,
      insight: 'A triangle has exactly three sides.',
    ),
    BreakTriviaPrompt(
      question: 'Which fruit is dried to make a raisin?',
      options: ['Plum', 'Grape', 'Cherry'],
      answerIndex: 1,
      insight: 'Raisins are dried grapes.',
    ),
    BreakTriviaPrompt(
      question: 'What is the main star at the center of our solar system?',
      options: ['Polaris', 'The Sun', 'Sirius'],
      answerIndex: 1,
      insight: 'The Sun is the star our planets orbit.',
    ),
    BreakTriviaPrompt(
      question: 'How many days are in a leap year?',
      options: ['365', '366', '364'],
      answerIndex: 1,
      insight: 'Leap years add one day to February for a total of 366.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is known for changing color to blend in?',
      options: ['Chameleon', 'Rabbit', 'Penguin'],
      answerIndex: 0,
      insight: 'Chameleons are famous for changing color.',
    ),
    BreakTriviaPrompt(
      question: 'What do you call molten rock after it reaches the surface?',
      options: ['Magma', 'Lava', 'Quartz'],
      answerIndex: 1,
      insight: 'Underground it is magma; on the surface it is lava.',
    ),
    BreakTriviaPrompt(
      question: 'Which hand on a clock moves fastest?',
      options: ['Hour hand', 'Minute hand', 'Second hand'],
      answerIndex: 2,
      insight: 'The second hand completes a full circle every minute.',
    ),
    BreakTriviaPrompt(
      question: 'Which season comes after spring in the northern hemisphere?',
      options: ['Winter', 'Summer', 'Autumn'],
      answerIndex: 1,
      insight: 'Summer follows spring.',
    ),
    BreakTriviaPrompt(
      question: 'How many legs does a spider have?',
      options: ['6', '8', '10'],
      answerIndex: 1,
      insight: 'Spiders are arachnids with eight legs.',
    ),
    BreakTriviaPrompt(
      question: 'Which ocean lies between Africa and Australia?',
      options: ['Pacific Ocean', 'Indian Ocean', 'Arctic Ocean'],
      answerIndex: 1,
      insight: 'The Indian Ocean sits between Africa, Asia, and Australia.',
    ),
    BreakTriviaPrompt(
      question: 'What do caterpillars become?',
      options: ['Butterflies', 'Dragonflies', 'Beetles'],
      answerIndex: 0,
      insight: 'Many caterpillars transform into butterflies or moths.',
    ),
    BreakTriviaPrompt(
      question: 'Which household object tells you temperature?',
      options: ['Thermometer', 'Compass', 'Scale'],
      answerIndex: 0,
      insight: 'A thermometer measures temperature.',
    ),
    BreakTriviaPrompt(
      question: 'How many strings does a standard violin have?',
      options: ['4', '5', '6'],
      answerIndex: 0,
      insight: 'Violins normally have four strings.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet is closest to the Sun?',
      options: ['Mercury', 'Mars', 'Neptune'],
      answerIndex: 0,
      insight: 'Mercury is the closest planet to the Sun.',
    ),
    BreakTriviaPrompt(
      question: 'What is the boiling point of water at sea level in Celsius?',
      options: ['90', '100', '110'],
      answerIndex: 1,
      insight: 'At sea level, water boils at 100°C.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is famous for building dams?',
      options: ['Beaver', 'Otter', 'Mole'],
      answerIndex: 0,
      insight: 'Beavers build dams from branches and mud.',
    ),
    BreakTriviaPrompt(
      question: 'What is the opposite of north on a compass?',
      options: ['East', 'South', 'West'],
      answerIndex: 1,
      insight: 'South is opposite north.',
    ),
    BreakTriviaPrompt(
      question: 'Which shape has no corners?',
      options: ['Circle', 'Square', 'Triangle'],
      answerIndex: 0,
      insight: 'Circles have no corners or edges.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet is known as the Red Planet?',
      options: ['Venus', 'Mars', 'Uranus'],
      answerIndex: 1,
      insight: 'Mars appears red because of iron oxide on its surface.',
    ),
    BreakTriviaPrompt(
      question: 'How many hours are in one full day?',
      options: ['12', '24', '36'],
      answerIndex: 1,
      insight: 'A full day has 24 hours.',
    ),
    BreakTriviaPrompt(
      question: 'What do you use to write on a blackboard?',
      options: ['Chalk', 'Ink', 'Crayon'],
      answerIndex: 0,
      insight: 'Chalk is the classic blackboard writing tool.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is the tallest on land?',
      options: ['Elephant', 'Giraffe', 'Camel'],
      answerIndex: 1,
      insight: 'Giraffes are the tallest land animals.',
    ),
    BreakTriviaPrompt(
      question: 'Which sense is most tied to your nose?',
      options: ['Taste', 'Smell', 'Touch'],
      answerIndex: 1,
      insight: 'Your nose handles the sense of smell.',
    ),
    BreakTriviaPrompt(
      question: 'Which kitchen tool is used to flip pancakes?',
      options: ['Spatula', 'Whisk', 'Ladle'],
      answerIndex: 0,
      insight: 'A spatula is commonly used to flip pancakes.',
    ),
    BreakTriviaPrompt(
      question: 'Which number comes after 999?',
      options: ['1000', '1001', '990'],
      answerIndex: 0,
      insight: '999 is followed by 1000.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet is farthest from the Sun?',
      options: ['Neptune', 'Saturn', 'Earth'],
      answerIndex: 0,
      insight:
          'Neptune is currently the farthest recognized planet from the Sun.',
    ),
    BreakTriviaPrompt(
      question:
          'What do you call a word that means the opposite of another word?',
      options: ['Synonym', 'Antonym', 'Acronym'],
      answerIndex: 1,
      insight: 'An antonym is a word with the opposite meaning.',
    ),
    BreakTriviaPrompt(
      question: 'Which metal is liquid at room temperature?',
      options: ['Mercury', 'Iron', 'Silver'],
      answerIndex: 0,
      insight:
          'Mercury is one of the few metals that is liquid at room temperature.',
    ),
    BreakTriviaPrompt(
      question: 'What is the hardest natural substance on Earth?',
      options: ['Gold', 'Diamond', 'Quartz'],
      answerIndex: 1,
      insight: 'Diamond is the hardest naturally occurring material.',
    ),
    BreakTriviaPrompt(
      question: 'Which blood type is known as the universal donor?',
      options: ['O negative', 'AB positive', 'A positive'],
      answerIndex: 0,
      insight:
          'O negative blood can typically be given in emergencies to most people.',
    ),
    BreakTriviaPrompt(
      question: 'What do you call animals that are active at night?',
      options: ['Nocturnal', 'Aquatic', 'Migratory'],
      answerIndex: 0,
      insight: 'Nocturnal animals are most active during nighttime.',
    ),
    BreakTriviaPrompt(
      question: 'Which language has the most native speakers worldwide?',
      options: ['English', 'Spanish', 'Mandarin Chinese'],
      answerIndex: 2,
      insight: 'Mandarin Chinese has the highest number of native speakers.',
    ),
    BreakTriviaPrompt(
      question: 'Which country is famous for the maple leaf symbol?',
      options: ['Canada', 'Sweden', 'New Zealand'],
      answerIndex: 0,
      insight: 'The maple leaf is one of Canada’s best-known national symbols.',
    ),
    BreakTriviaPrompt(
      question: 'What is the main ingredient in guacamole?',
      options: ['Cucumber', 'Avocado', 'Pea'],
      answerIndex: 1,
      insight: 'Guacamole is primarily made from mashed avocado.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet rotates on its side more than the others?',
      options: ['Uranus', 'Earth', 'Jupiter'],
      answerIndex: 0,
      insight:
          'Uranus has an extreme axial tilt and appears to rotate on its side.',
    ),
    BreakTriviaPrompt(
      question:
          'How many teeth does a typical adult human have, including wisdom teeth?',
      options: ['28', '30', '32'],
      answerIndex: 2,
      insight: 'A full adult set usually includes 32 teeth.',
    ),
    BreakTriviaPrompt(
      question: 'Which desert is the largest hot desert on Earth?',
      options: ['Sahara', 'Gobi', 'Mojave'],
      answerIndex: 0,
      insight: 'The Sahara is the world’s largest hot desert.',
    ),
    BreakTriviaPrompt(
      question: 'What is the name for a scientist who studies rocks?',
      options: ['Biologist', 'Geologist', 'Astronomer'],
      answerIndex: 1,
      insight: 'Geologists study rocks, minerals, and Earth’s structure.',
    ),
    BreakTriviaPrompt(
      question: 'Which organ pumps blood through the body?',
      options: ['Liver', 'Heart', 'Kidney'],
      answerIndex: 1,
      insight: 'The heart pumps blood through the circulatory system.',
    ),
    BreakTriviaPrompt(
      question: 'Which fruit has seeds on the outside?',
      options: ['Blueberry', 'Strawberry', 'Apple'],
      answerIndex: 1,
      insight:
          'Strawberries are unusual because their seeds are on the outside.',
    ),
    BreakTriviaPrompt(
      question:
          'What is the process of water vapor turning into liquid called?',
      options: ['Evaporation', 'Condensation', 'Freezing'],
      answerIndex: 1,
      insight:
          'Condensation happens when water vapor cools into liquid droplets.',
    ),
    BreakTriviaPrompt(
      question: 'Which famous wall was built to protect northern China?',
      options: ['Berlin Wall', 'Great Wall', 'Hadrian’s Wall'],
      answerIndex: 1,
      insight: 'The Great Wall of China was built and expanded over centuries.',
    ),
    BreakTriviaPrompt(
      question:
          'How many players are on a soccer team on the field at one time?',
      options: ['9', '10', '11'],
      answerIndex: 2,
      insight: 'A soccer team fields 11 players including the goalkeeper.',
    ),
    BreakTriviaPrompt(
      question: 'Which bird cannot fly but is famous for living in Antarctica?',
      options: ['Penguin', 'Seagull', 'Falcon'],
      answerIndex: 0,
      insight:
          'Penguins are flightless birds strongly associated with Antarctica.',
    ),
    BreakTriviaPrompt(
      question: 'What is 12 multiplied by 12?',
      options: ['124', '144', '154'],
      answerIndex: 1,
      insight: '12 times 12 equals 144.',
    ),
    BreakTriviaPrompt(
      question: 'Which gas do humans need to breathe to live?',
      options: ['Nitrogen', 'Oxygen', 'Hydrogen'],
      answerIndex: 1,
      insight: 'Humans rely on oxygen for respiration.',
    ),
    BreakTriviaPrompt(
      question: 'What is the largest planet in our solar system?',
      options: ['Saturn', 'Jupiter', 'Neptune'],
      answerIndex: 1,
      insight: 'Jupiter is the largest planet in our solar system.',
    ),
    BreakTriviaPrompt(
      question: 'Which part of the body contains the femur?',
      options: ['Arm', 'Leg', 'Skull'],
      answerIndex: 1,
      insight: 'The femur is the thigh bone in the leg.',
    ),
    BreakTriviaPrompt(
      question: 'Which famous tower leans in Italy?',
      options: ['Eiffel Tower', 'Leaning Tower of Pisa', 'CN Tower'],
      answerIndex: 1,
      insight:
          'The Leaning Tower of Pisa is one of Italy’s best-known landmarks.',
    ),
    BreakTriviaPrompt(
      question: 'How many zeros are in one million?',
      options: ['5', '6', '7'],
      answerIndex: 1,
      insight: 'One million is written as 1,000,000.',
    ),
    BreakTriviaPrompt(
      question:
          'Which sea animal is known for having a shell and moving slowly on land?',
      options: ['Turtle', 'Seal', 'Dolphin'],
      answerIndex: 0,
      insight: 'Sea turtles have shells and move slowly on land.',
    ),
    BreakTriviaPrompt(
      question: 'What do you call the colored part of the eye?',
      options: ['Iris', 'Retina', 'Pupil'],
      answerIndex: 0,
      insight: 'The iris is the colored ring around the pupil.',
    ),
    BreakTriviaPrompt(
      question: 'Which instrument is used to look at stars and planets?',
      options: ['Microscope', 'Telescope', 'Periscope'],
      answerIndex: 1,
      insight: 'A telescope is designed for viewing distant objects in space.',
    ),
    BreakTriviaPrompt(
      question: 'Which holiday is known for pumpkins and costumes?',
      options: ['Halloween', 'Easter', 'Valentine’s Day'],
      answerIndex: 0,
      insight: 'Halloween is associated with costumes, candy, and pumpkins.',
    ),
    BreakTriviaPrompt(
      question: 'What is 100 divided by 4?',
      options: ['20', '25', '40'],
      answerIndex: 1,
      insight: '100 divided by 4 equals 25.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is known as the king of the jungle?',
      options: ['Tiger', 'Lion', 'Wolf'],
      answerIndex: 1,
      insight: 'The lion is commonly called the king of the jungle.',
    ),
    BreakTriviaPrompt(
      question: 'What do magnets attract?',
      options: ['Wood', 'Plastic', 'Iron'],
      answerIndex: 2,
      insight: 'Magnets strongly attract iron and some other metals.',
    ),
    BreakTriviaPrompt(
      question: 'Which day comes after Friday?',
      options: ['Thursday', 'Saturday', 'Sunday'],
      answerIndex: 1,
      insight: 'Saturday follows Friday.',
    ),
    BreakTriviaPrompt(
      question: 'What is the tallest mountain above sea level?',
      options: ['K2', 'Mount Everest', 'Kilimanjaro'],
      answerIndex: 1,
      insight: 'Mount Everest is the tallest mountain above sea level.',
    ),
    BreakTriviaPrompt(
      question: 'Which insect glows in the dark?',
      options: ['Firefly', 'Ant', 'Grasshopper'],
      answerIndex: 0,
      insight: 'Fireflies produce light through bioluminescence.',
    ),
    BreakTriviaPrompt(
      question: 'How many months are in a year?',
      options: ['10', '12', '14'],
      answerIndex: 1,
      insight: 'A standard year has 12 months.',
    ),
    BreakTriviaPrompt(
      question: 'Which tool is used to cut paper in crafts?',
      options: ['Scissors', 'Spoon', 'Brush'],
      answerIndex: 0,
      insight: 'Scissors are commonly used to cut paper.',
    ),
    BreakTriviaPrompt(
      question: 'Which planet is known for having a giant red storm?',
      options: ['Mars', 'Jupiter', 'Venus'],
      answerIndex: 1,
      insight: 'Jupiter’s Great Red Spot is a massive long-lasting storm.',
    ),
    BreakTriviaPrompt(
      question: 'What is the main job of roots in a plant?',
      options: ['Absorb water', 'Make flowers sing', 'Catch sunlight'],
      answerIndex: 0,
      insight: 'Roots help anchor the plant and absorb water and nutrients.',
    ),
    BreakTriviaPrompt(
      question: 'Which shape has four equal sides and four right angles?',
      options: ['Triangle', 'Square', 'Oval'],
      answerIndex: 1,
      insight: 'A square has four equal sides and four right angles.',
    ),
    BreakTriviaPrompt(
      question: 'Which country is famous for the pyramids of Giza?',
      options: ['Egypt', 'Mexico', 'India'],
      answerIndex: 0,
      insight: 'The pyramids of Giza are in Egypt.',
    ),
    BreakTriviaPrompt(
      question: 'What do you call frozen rain that falls in pellets?',
      options: ['Fog', 'Sleet', 'Steam'],
      answerIndex: 1,
      insight: 'Sleet is frozen precipitation that falls as small pellets.',
    ),
    BreakTriviaPrompt(
      question: 'Which body of water separates Europe and Africa near Spain?',
      options: ['English Channel', 'Strait of Gibraltar', 'Bering Strait'],
      answerIndex: 1,
      insight:
          'The Strait of Gibraltar lies between southern Spain and northern Africa.',
    ),
    BreakTriviaPrompt(
      question: 'How many wheels does a standard bicycle have?',
      options: ['1', '2', '3'],
      answerIndex: 1,
      insight: 'A standard bicycle has two wheels.',
    ),
    BreakTriviaPrompt(
      question: 'Which animal is known for carrying its house on its back?',
      options: ['Snail', 'Lizard', 'Hedgehog'],
      answerIndex: 0,
      insight: 'A snail carries its shell on its back.',
    ),
    BreakTriviaPrompt(
      question: 'What is the main color of chlorophyll?',
      options: ['Green', 'Red', 'Blue'],
      answerIndex: 0,
      insight: 'Chlorophyll is the green pigment plants use to capture light.',
    ),
    BreakTriviaPrompt(
      question: 'Which continent is the driest inhabited one?',
      options: ['Africa', 'Australia', 'Europe'],
      answerIndex: 1,
      insight: 'Australia is the driest inhabited continent.',
    ),
    BreakTriviaPrompt(
      question: 'What do you call a group of lions?',
      options: ['Pack', 'Pride', 'Herd'],
      answerIndex: 1,
      insight: 'A group of lions is called a pride.',
    ),
    BreakTriviaPrompt(
      question:
          'Which instrument has pedals and is commonly found in churches?',
      options: ['Organ', 'Trumpet', 'Drum'],
      answerIndex: 0,
      insight: 'Pipe organs often have both keyboards and pedals.',
    ),
    BreakTriviaPrompt(
      question: 'Which common kitchen ingredient makes bread rise?',
      options: ['Salt', 'Yeast', 'Pepper'],
      answerIndex: 1,
      insight: 'Yeast produces gas that helps bread dough rise.',
    ),
    BreakTriviaPrompt(
      question: 'What is 7 multiplied by 8?',
      options: ['54', '56', '58'],
      answerIndex: 1,
      insight: '7 times 8 equals 56.',
    ),
    BreakTriviaPrompt(
      question: 'Which part of Earth is made mostly of molten metal?',
      options: ['Crust', 'Core', 'Ocean'],
      answerIndex: 1,
      insight: 'Earth’s core is mostly metal, and its outer core is molten.',
    ),
  ];

  static const List<String> zenFortunes = [
    'Pause first. Momentum is not destiny.',
    'The urge is loud. It is not in charge.',
    'Give this moment 10 more breaths before you decide anything.',
    'Small detours count. You already interrupted the spiral.',
    'If your mind is storming, shrink the horizon to the next minute.',
    'Nothing permanent needs to be decided inside a temporary wave.',
    'You do not need to obey the first impulse that shows up.',
    'Try making this minute smaller, softer, and slower.',
    'You are allowed to delay the urge without defeating it forever.',
    'The win is not perfection. The win is creating space.',
    'A calmer next step beats a dramatic one.',
    'Notice the urge. Name it. Do not feed it a story.',
    'Your nervous system is asking for care, not punishment.',
    'One gentle interruption can reroute the whole moment.',
    'Breathe like you are helping a friend, not scolding yourself.',
    'If this feels sharp, answer with softness and structure.',
    'You can be uncomfortable without being in danger.',
    'The moment is intense. It is still movable.',
    'Give the craving less theater and more distance.',
    'A delayed yes often turns into a peaceful no.',
    'The body settles faster when you stop arguing with it.',
    'Choose the next minute, not the whole future.',
    'Catch your breath before you catch your thoughts.',
    'Your progress is built out of tiny interruptions like this.',
    'A pause is not weakness. It is steering.',
    'Let the wave pass through; you do not have to build it a home.',
    'The urge can knock. It does not get to move in.',
    'Lower the stakes of this minute and it becomes easier to carry.',
    'You are not behind. You are practicing the pause in real time.',
    'A softer nervous system makes wiser decisions.',
    'You can delay without denying your humanity.',
    'The craving wants speed. Answer with steadiness.',
    'This is a checkpoint, not a verdict on your character.',
    'Stay with the body for a breath before following the story.',
    'A little space right now is a real form of progress.',
    'You have survived strong urges before without obeying them.',
    'The next kind action can be very small and still count.',
    'Calm is often built by repetition, not revelation.',
    'Interruptions like this teach your brain a new route.',
    'A minute of distance can save an hour of regret.',
    'You are allowed to want relief and still choose wisely.',
    'Do less. Slow down. Let the heat drop first.',
    'The mind gets quieter when the body feels safer.',
    'You can honor the feeling without acting it out.',
    'This moment does not need drama; it needs room.',
    'Try loosening your jaw, your shoulders, and the timeline.',
    'You are steering now, even if the turn is gentle.',
    'Breathe low and slow; let the urgency miss its cue.',
    'Cravings often peak quickly and fade when not fed.',
    'This pause is already changing the ending.',
    'You do not need a perfect plan to take a better next step.',
    'Give the impulse a little boredom and it often weakens.',
    'There is strength in becoming less available to the urge.',
    'A calm body can hold a loud mind more safely.',
    'Let this be a reset, not a debate.',
    'The future you are protecting is built in moments exactly like this.',
    'If all you do is postpone the spiral, that still matters.',
    'Settle the nervous system first; meaning can wait.',
    'A wise pause often feels ordinary while it is happening.',
    'You are teaching yourself that urgency is not authority.',
    'Small clean choices build quiet confidence.',
    'The fastest relief is not always the truest relief.',
    'Make the next breath your whole assignment.',
    'Reduce the noise, then decide.',
    'You can meet this moment with less force.',
    'The urge is asking for attention; give it observation instead.',
    'There is no rule that says you must continue the old pattern.',
    'Even a partial slowdown is a meaningful win.',
    'You are not trapped inside the first feeling.',
    'A better decision often starts with a slower body.',
    'Gentleness is allowed here.',
    'You can stay curious instead of reactive for one more minute.',
    'Let your breathing become the pace setter.',
    'The storm in your head does not have to become weather in your life.',
    'Stability is often just a few quieter seconds repeated.',
  ];

  static BreakActivityDefinition definitionFor(BreakActivityType type) {
    return _definitions.firstWhere((definition) => definition.type == type);
  }

  static List<BreakActivityType> poolFor(AvoidType type) {
    switch (type) {
      case AvoidType.generic:
        return BreakActivityType.values;
      case AvoidType.people:
        return const [
          BreakActivityType.defuse,
          BreakActivityType.stackSweep,
          BreakActivityType.zenRoom,
          BreakActivityType.triviaPivot,
        ];
      case AvoidType.event:
        return const [
          BreakActivityType.triviaPivot,
          BreakActivityType.stackSweep,
          BreakActivityType.zenRoom,
          BreakActivityType.pairMatch,
        ];
      case AvoidType.place:
        return const [
          BreakActivityType.defuse,
          BreakActivityType.pairMatch,
          BreakActivityType.stackSweep,
          BreakActivityType.triviaPivot,
          BreakActivityType.zenRoom,
        ];
    }
  }

  static BreakActivityType pickActivity(
    AvoidType type, {
    Random? random,
    BreakActivityType? previous,
  }) {
    final generator = random ?? Random();
    final pool = List<BreakActivityType>.from(poolFor(type));
    if (previous != null && pool.length > 1) {
      pool.remove(previous);
    }
    return pool[generator.nextInt(pool.length)];
  }

  static bool isHelpful(BreakOutcome? outcome) =>
      outcome == BreakOutcome.passed || outcome == BreakOutcome.weaker;

  static String xpSourceFor(String todoId, DateTime when) {
    final day = when.toIso8601String().substring(0, 10);
    return '$sourceHelpfulBreak:$todoId:$day';
  }

  static String labelForOutcome(BreakOutcome outcome) {
    switch (outcome) {
      case BreakOutcome.passed:
        return 'Urge passed';
      case BreakOutcome.weaker:
        return 'Urge weaker';
      case BreakOutcome.stillStrong:
        return 'Still strong';
    }
  }
}
