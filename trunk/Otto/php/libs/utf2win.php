<?php

function utf8_to_ansi_ce($str) {
$ce_utf8 = array (
   "\xc3\x80", "\xc3\x81", "\xc3\x82", "\xc3\x83", "\xc3\x84", "\xc3\x85", "\xc3\x86", "\xc3\x87",
   "\xc3\x88", "\xc3\x89", "\xc3\x8a", "\xc3\x8b", "\xc3\x8c", "\xc3\x8d", "\xc3\x8e", "\xc3\x8f",
   "\xc3\x90", "\xc3\x91", "\xc3\x92", "\xc3\x93", "\xc3\x94", "\xc3\x95", "\xc3\x96", "\xc3\x97",
   "\xc3\x98", "\xc3\x99", "\xc3\x9a", "\xc3\x9b", "\xc3\x9c", "\xc3\x9d", "\xc3\x9e", "\xc3\x9f",
   
   "\xc3\xa0", "\xc3\xa1", "\xc3\xa2", "\xc3\xa3", "\xc3\xa4", "\xc3\xa5", "\xc3\xa6", "\xc3\xa7",
   "\xc3\xa8", "\xc3\xa9", "\xc3\xaa", "\xc3\xab", "\xc3\xac", "\xc3\xad", "\xc3\xae", "\xc3\xaf",
   "\xc3\xb0", "\xc3\xb1", "\xc3\xb2", "\xc3\xb3", "\xc3\xb4", "\xc3\xb5", "\xc3\xb6", "\xc3\xb7",
   "\xc3\xb8", "\xc3\xb9", "\xc3\xba", "\xc3\xbb", "\xc3\xbc", "\xc3\xbd", "\xc3\xbe", "\xc3\xbf",
   
   "\xc4\x80", "\xc4\x81", "\xc4\x82", "\xc4\x83", "\xc4\x84", "\xc4\x85", "\xc4\x86", "\xc4\x87",
   "\xc4\x88", "\xc4\x89", "\xc4\x8a", "\xc4\x8b", "\xc4\x8c", "\xc4\x8d", "\xc4\x8e", "\xc4\x8f",
   "\xc4\x90", "\xc4\x91", "\xc4\x92", "\xc4\x93", "\xc4\x94", "\xc4\x95", "\xc4\x96", "\xc4\x97",
   "\xc4\x98", "\xc4\x99", "\xc4\x9a", "\xc4\x9b", "\xc4\x9c", "\xc4\x9d", "\xc4\x9e", "\xc4\x9f",

   "\xc4\xa0", "\xc4\xa1", "\xc4\xa2", "\xc4\xa3", "\xc4\xa4", "\xc4\xa5", "\xc4\xa6", "\xc4\xa7",
   "\xc4\xa8", "\xc4\xa9", "\xc4\xaa", "\xc4\xab", "\xc4\xac", "\xc4\xad", "\xc4\xae", "\xc4\xaf",
   "\xc4\xb0", "\xc4\xb1", "\xc4\xb2", "\xc4\xb3", "\xc4\xb4", "\xc4\xb5", "\xc4\xb6", "\xc4\xb7",
   "\xc4\xb8", "\xc4\xb9", "\xc4\xba", "\xc4\xbb", "\xc4\xbc", "\xc4\xbd", "\xc4\xbe", "\xc4\xbf",
   
   "\xc5\x80", "\xc5\x81", "\xc5\x82", "\xc5\x83", "\xc5\x84", "\xc5\x85", "\xc5\x86", "\xc5\x87",
   "\xc5\x88", "\xc5\x89", "\xc5\x8a", "\xc5\x8b", "\xc5\x8c", "\xc5\x8d", "\xc5\x8e", "\xc5\x8f",
   "\xc5\x90", "\xc5\x91", "\xc5\x92", "\xc5\x93", "\xc5\x94", "\xc5\x95", "\xc5\x96", "\xc5\x97",
   "\xc5\x98", "\xc5\x99", "\xc5\x9a", "\xc5\x9b", "\xc5\x9c", "\xc5\x9d", "\xc5\x9e", "\xc5\x9f",
   
   "\xc5\xa0", "\xc5\xa1", "\xc5\xa2", "\xc5\xa3", "\xc5\xa4", "\xc5\xa5", "\xc5\xa6", "\xc5\xa7",
   "\xc5\xa8", "\xc5\xa9", "\xc5\xaa", "\xc5\xab", "\xc5\xac", "\xc5\xad", "\xc5\xae", "\xc5\xaf",
   "\xc5\xb0", "\xc5\xb1", "\xc5\xb2", "\xc5\xb3", "\xc5\xb4", "\xc5\xb5", "\xc5\xb6", "\xc5\xb7",
   "\xc5\xb8", "\xc5\xb9", "\xc5\xba", "\xc5\xbb", "\xc5\xbc", "\xc5\xbd", "\xc5\xbe", "\xc5\xbf");
   

$ce_ansi = array(
   "A",  "A",  "A",  "A",  "A",  "A",  "AE", "C",
   "E",  "E",  "E",  "E",  "I",  "I",  "I",  "I",
   "D",  "N",  "O",  "O",  "O",  "O",  "O",  "x",
   "O",  "U",  "U",  "U",  "U",  "Y",  "P",  "ss",
   
   "a",  "a",  "a",  "a",  "a",  "a",  "ae", "c",
   "e",  "e",  "e",  "e",  "i",  "i",  "i",  "i",
   "th", "n",  "o",  "o",  "o",  "o",  "o",  "-",
   "o",  "u",  "u",  "u",  "u",  "y",  "p",  "y",
   
   "A",  "a",  "A",  "a",  "A",  "a",  "C",  "c",
   "C",  "c",  "C",  "c",  "C",  "c",  "D",  "d",
   "D",  "d",  "E",  "e",  "E",  "e",  "E",  "e",
   "E",  "e",  "E",  "e",  "G",  "g",  "G",  "g",
   
   "G",  "g",  "G",  "g",  "H",  "h",  "H",  "h",
   "I",  "i",  "I",  "i",  "I",  "i",  "I",  "i",
   "I",  "i",  "IJ", "ij", "J",  "j",  "K",  "k",
   "k",  "L",  "l",  "L",  "l",  "L",  "l",  "L",
   
   "l",  "L",  "l",  "N",  "n",  "N",  "n",  "N",
   "n",  "n",  "N",  "n",  "O",  "o",  "O",  "o",
   "O",  "o",  "OE", "oe", "R",  "r",  "R",  "r",
   "R",  "r",  "S",  "s",  "S",  "s",  "S",  "s",
   
   "S",  "s",  "T",  "t",  "T",  "t",  "T",  "t",
   "U",  "u",  "U",  "u",  "U",  "u",  "U",  "u",
   "U",  "u",  "U",  "u",  "W",  "w",  "Y",  "y",
   "Y",  "Z",  "z",  "Z",  "z",  "Z",  "z",  "l");

  return str_replace($ce_utf8, $ce_ansi, $str);
}

function utf8_to_ansi_ru($str) {
$ru_ansi = array (
  chr(208), chr(192), chr(193), chr(194),
  chr(195), chr(196), chr(197), chr(168),
  chr(198), chr(199), chr(200), chr(201),
  chr(202), chr(203), chr(204), chr(205),
  chr(206), chr(207), chr(209), chr(210),
  chr(211), chr(212), chr(213), chr(214),
  chr(215), chr(216), chr(217), chr(218),
  chr(219), chr(220), chr(221), chr(222),
  chr(223), chr(224), chr(225), chr(226),
  chr(227), chr(228), chr(229), chr(184),
  chr(230), chr(231), chr(232), chr(233),
  chr(234), chr(235), chr(236), chr(237),
  chr(238), chr(239), chr(240), chr(241),
  chr(242), chr(243), chr(244), chr(245),
  chr(246), chr(247), chr(248), chr(249),
  chr(250), chr(251), chr(252), chr(253),
  chr(254), chr(255)
);  
 
$ru_utf8 = array (
  chr(208).chr(160), chr(208).chr(144), chr(208).chr(145),
  chr(208).chr(146), chr(208).chr(147), chr(208).chr(148),
  chr(208).chr(149), chr(208).chr(129), chr(208).chr(150),
  chr(208).chr(151), chr(208).chr(152), chr(208).chr(153),
  chr(208).chr(154), chr(208).chr(155), chr(208).chr(156),
  chr(208).chr(157), chr(208).chr(158), chr(208).chr(159),
  chr(208).chr(161), chr(208).chr(162), chr(208).chr(163),
  chr(208).chr(164), chr(208).chr(165), chr(208).chr(166),
  chr(208).chr(167), chr(208).chr(168), chr(208).chr(169),
  chr(208).chr(170), chr(208).chr(171), chr(208).chr(172),
  chr(208).chr(173), chr(208).chr(174), chr(208).chr(175),
  chr(208).chr(176), chr(208).chr(177), chr(208).chr(178),
  chr(208).chr(179), chr(208).chr(180), chr(208).chr(181),
  chr(209).chr(145), chr(208).chr(182), chr(208).chr(183),
  chr(208).chr(184), chr(208).chr(185), chr(208).chr(186),
  chr(208).chr(187), chr(208).chr(188), chr(208).chr(189),
  chr(208).chr(190), chr(208).chr(191), chr(209).chr(128),
  chr(209).chr(129), chr(209).chr(130), chr(209).chr(131),
  chr(209).chr(132), chr(209).chr(133), chr(209).chr(134),
  chr(209).chr(135), chr(209).chr(136), chr(209).chr(137),
  chr(209).chr(138), chr(209).chr(139), chr(209).chr(140),
  chr(209).chr(141), chr(209).chr(142), chr(209).chr(143)
);  

  return str_replace($ru_utf8, $ru_ansi, $str);
//  return (iconv('utf-8', 'Windows-1251', $Html));
}

function win1251_to_utf8($str)
{
$ansi_utf8 = array (
  "\xC0" => "\xd0\x90", // А
  "\xC1" => "\xd0\x91", // Б
  "\xC2" => "\xd0\x92", // В
  "\xC3" => "\xd0\x93", // Г
  "\xC4" => "\xd0\x94", // Д
  "\xC5" => "\xd0\x95", // E
  "\xC6" => "\xd0\x96", // Ж
  "\xC7" => "\xd0\x97", // З
  "\xC8" => "\xd0\x98", // И
  "\xC9" => "\xd0\x99", // Й
  "\xCA" => "\xd0\x9A", // К
  "\xCB" => "\xd0\x9B", // Л
  "\xCC" => "\xd0\x9C", // М
  "\xCD" => "\xd0\x9D", // Н
  "\xCE" => "\xd0\x9E", // О
  "\xCF" => "\xd0\x9F", // П
  "\xD0" => "\xd0\xA0", // Р
  "\xD1" => "\xd0\xA1", // С
  "\xD2" => "\xd0\xA2", // Т
  "\xD3" => "\xd0\xA3", // У
  "\xD4" => "\xd0\xA4", // Ф
  "\xD5" => "\xd0\xA5", // Х
  "\xD6" => "\xd0\xA6", // Ц
  "\xD7" => "\xd0\xA7", // Ч
  "\xD8" => "\xd0\xA8", // Ш
  "\xD9" => "\xd0\xA9", // Щ
  "\xDA" => "\xd0\xAA", // Ъ
  "\xDB" => "\xd0\xAB", // Ы
  "\xDC" => "\xd0\xAC", // Ь
  "\xDD" => "\xd0\xAD", // Э
  "\xDE" => "\xd0\xAE", // Ю
  "\xDF" => "\xd0\xAF", // Я
  "\xE0" => "\xd0\xB0", // a
  "\xE1" => "\xd0\xB1", // б
  "\xE2" => "\xd0\xB2", // в
  "\xE3" => "\xd0\xB3", // г
  "\xE4" => "\xd0\xB4", // д
  "\xE5" => "\xd0\xB5", // е
  "\xE6" => "\xd0\xB6", // ж
  "\xE7" => "\xd0\xB7", // з
  "\xE8" => "\xd0\xB8", // и
  "\xE9" => "\xd0\xB9", // й
  "\xEA" => "\xd0\xBA", // к
  "\xEB" => "\xd0\xBB", // л
  "\xEC" => "\xd0\xBC", // м
  "\xED" => "\xd0\xBD", // н
  "\xEE" => "\xd0\xBE", // о
  "\xEF" => "\xd0\xBF", // п
  "\xF0" => "\xd1\x80", // р
  "\xF1" => "\xd1\x81", // с
  "\xF2" => "\xd1\x82", // т
  "\xF3" => "\xd1\x83", // у
  "\xF4" => "\xd1\x84", // ф
  "\xF5" => "\xd1\x85", // х
  "\xF6" => "\xd1\x86", // ц
  "\xF7" => "\xd1\x87", // ч
  "\xF8" => "\xd1\x88", // ш
  "\xF9" => "\xd1\x89", // щ
  "\xFA" => "\xd1\x8A", // ъ
  "\xFB" => "\xd1\x8B", // ы
  "\xFC" => "\xd1\x8C", // ь
  "\xFD" => "\xd1\x8D", // э
  "\xFE" => "\xd1\x8E", // ю
  "\xFF" => "\xd1\x8F", // я
  "\xA8" => "\xd0\x81", // Ё
  "\xB8" => "\xd1\x91", // ё
  "\x96" => "\xE2\x80\x93", // короткое тире
  "\x97" => "\xE2\x80\x94" // длинное тире
  );
  
  return strtr($str, $ansi_utf8);
}
?>