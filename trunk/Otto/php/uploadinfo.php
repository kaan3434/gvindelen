<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta http-equiv="content-language" content="ru">
</head>
<body>
<?php
  require "libs/utf2win.php"; 
  require_once "settings/mysql.inc";

$config = array(
	# User password (the one which you enter in the clien)
	'password' => 'pass'
);

function quote($str){
  if ($str <> 'NULL') {
	  return "'".$str."'";
  } else {
    return $str;
  }
}

if (strtolower($_SERVER['REQUEST_METHOD']) == 'post')
{
	ensurePassword($config['password']);
  
  if ($_FILES['txt1']['error'] == 1) {
    echo 'Uploaded file1 too big';
    exit;
  }
  if ($_FILES['txt2']['error'] == 1) {
    echo 'Uploaded file2 too big';
    exit;
  }
  
  $dblink = db_connect();
  mysql_query('drop table if exists sendinet', $dblink);
  mysql_query('CREATE TABLE sendinet (
  `NUMZAK` VARCHAR(6) CHARACTER SET utf8 ,
  `DATEDO` DATE,
  `FAMILY` VARCHAR(40) CHARACTER SET utf8 ,
  `STREET` VARCHAR(30) CHARACTER SET utf8 ,
  `HOME` VARCHAR(15) CHARACTER SET utf8 ,
  `CITY` VARCHAR(26) CHARACTER SET utf8 ,
  `REGION` VARCHAR(41) CHARACTER SET utf8 ,
  `INDEXCITY` VARCHAR(6) CHARACTER SET utf8 ,
  `EMAIL` VARCHAR(30) CHARACTER SET utf8 ,
  `VALUEEUR` DECIMAL(9,2),
  `DATERUN` DATE,
  `ARTICUL` VARCHAR(10) CHARACTER SET utf8 ,
  `SIZE` VARCHAR(6) CHARACTER SET utf8 ,
  `SUMEUR` DECIMAL(19,2),
  `SUMRUB` DOUBLE,
  `NAMEZAK` VARCHAR(30) CHARACTER SET utf8 ,
  `STATUSNAME` VARCHAR(20) CHARACTER SET utf8 ,
  `DATEPI3` VARCHAR(40) CHARACTER SET utf8 ,
  `SENDING` VARCHAR(13) CHARACTER SET utf8 ,
  `SBOR` VARCHAR(6) CHARACTER SET utf8 ,
  `DATECALC` DATE,
  `SUMRUNEUR` DECIMAL(7,2),
  `SUMRUN` INT,
  `DATEPAY` DATE,
  `SUMPAY` INT,
  `SUMCOUNT` DECIMAL(16,2),
  `WEIGHT` DECIMAL(6,3),
  `NULLFLAGS` VARCHAR(50) CHARACTER SET utf8
) ENGINE=MyISAM DEFAULT CHARSET=utf8', $dblink);
   mysql_query('DROP TABLE IF EXISTS `status`', $dblink);
   mysql_query('CREATE TABLE `status` (
  `status_code` tinyint(4) NOT NULL,
  `status_name` varchar(20) NOT NULL,
  PRIMARY KEY  (`status_code`),
  UNIQUE KEY `status_code` (`status_code`),
  UNIQUE KEY `status_name` (`status_name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8', $dblink);
   mysql_query('INSERT INTO `status` (`status_code`, `status_name`) VALUES 
  (1, \'принят\'),
  (2, \'протокол\'),
  (3, \'задержка\'),
  (4, \'оформлен\'),
  (5, \'на складе 2 этап\'),
  (6, \'состояние в паклисте\'),
  (7, \'упаков\'),
  (-1, \'аннулирован НЕМЦАМИ\'),
  (-3, \'возврат\'),
  (-2, \'аннулирован\'),
  (-4, \'отпр на аннул\'),
  (-5, \'отказ\'),
  (8, \'зак отпр в Фр\')', $dblink);
  mysql_query('LOCK TABLES sendinet WRITE', $dblink);

  $txt = file_get_contents($_FILES['txt1']['tmp_name']).file_get_contents($_FILES['txt2']['tmp_name']);

	function error($errno, $errstr, $f, $l)
	{
		global $dblink;
		echo '<title>Error in txt database upload</title>';
		echo 'Error happened.<br>';
		echo '<br><br>Error code: <strong>' . $errno.'</strong>;<br>';
		echo 'Error message: '. $errstr.';<br>';
		echo 'On line <strong>' . $l . '</strong>.<br>';
		exit();
		return true;
	}

  function to_date($entry) {
    if (($entry == '') or ($entry == 'NULL')) {
      return 'NULL';
    } elseif (strpos($entry, '-') > 0) {
      return substr($entry, 6, 4) . '-' . substr($entry, 3, 2) . '-' . substr($entry, 0, 2);
    } else {
      return $entry;
    }
  }
  
	set_error_handler('error');

  $txt = win1251_to_utf8($txt);

  $txt = str_replace('";"', ';', $txt);
  $txt = str_replace('"', '', $txt);
  list($head, $txt) = explode("\r\n", $txt, 2);
  
  $txt = str_replace(';.  .;', ';;', $txt);
  $txt = str_replace(';;', ';NULL;', $txt);

	$lines = explode("\r\n", $txt);

  $order_no = null;
	foreach ($lines as $line)
	{
		$line = trim($line);
		if (empty($line))
			continue;
		$entry = explode(';', $line);

		$entry[1] = to_date($entry[1]);
		$entry[9] = (int) $entry[9];
    $entry[10] = to_date($entry[10]);
		$entry[17] = 'NULL';
    $entry[20] = to_date($entry[20]);
		$entry[23] = 'NULL';
		$entry[24] = (int) $entry[24];
    $entry[27] = 'NULL';
    unset($entry[28]);

		// Quote items
		$max = count($entry);
		for ($i=0; $i<$max; ++$i)
		{
			if (!in_array($i, array(9, 13, 14, 21, 22,23, 24, 25, 26)))
			{
				$entry[$i] = quote($entry[$i]);
			}
      if ($entry[$i] == '') $entry[$i] = 'NULL';
		}

    if ($order_no <> $entry[0]) {
      $order_no = $entry[0];
      echo $order_no."; ";
    }

		// In the end there is a place for _nullFields field.
		$sql = 'INSERT INTO `sendinet` VALUES (' . implode(', ', $entry) . ');';

		if (!mysql_query($sql, $dblink))
		{
			echo 'Error with SQL <small>'.$sql.'</small>: ' . mysql_error($dblink).'<br>';
		}
	}

  mysql_query('UNLOCK TABLES', $dblink);
	mysql_close($dblink);
	echo '<title>Txt database upload is finished.</title>Done!';
}
else
{
	echo '<title>Upload txt database</title>';
	echo '<style type="text/css">html { font-size: 18px }form { margin: 50px auto; width: 300px; border: 3px solid #781D54; border-radius:15px; padding: 2em; } input { display: block; margin-top: 7px; margin-bottom: 10px; font-size: 100%; width: 100% } input:focus:invalid { background-color: #F5CBCA}</style>';
	echo '<form action="" method="post" enctype="multipart/form-data">';
	echo '<p><label>File1 to upload:<input type="file" name="txt1" autofocus tabindex="1"></label></p>';
  echo '<p><label>File2 to upload:<input type="file" name="txt2" autofocus tabindex="1"></label></p>';
	echo '<p><label>Password to modify database:<input type="password" name="password" placeholder="Password" tabindex="2" required></label></p>';
	echo '<p><input type="submit" value="Upload the file" tabindex="3"></p>';
	echo '</form>';
}

function ensurePassword($password)
{
	if (empty($_POST['password'])
		|| $_POST['password'] <> $password)
	{
		header(' ', true, 403);
		echo 'Incorrect password.';
		exit();
	}
}

function ensureMethod($method)
{
	if (strtolower($_SERVER['REQUEST_METHOD']) <> strtolower($method))
	{
		header(' ', true, 405);
		echo 'Wrong method used.';
		exit();
	}
}

?>
</body>
</html>