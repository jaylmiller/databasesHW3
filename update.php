 <head>
  <title>List Raw Scores Form</title>
 </head>
 <body>

 
 
 <?php
// PHP code just started

ini_set('error_reporting', E_ALL);
ini_set('display_errors', true);
// display errors

$db = mysql_connect("dbase.cs.jhu.edu", "cs41515_taron1", "QVEVBREM");
// ********* Remember to use your MySQL username and password here ********* //

if (!$db) {

  echo "Connection failed!";

} else {

  $password = $_POST['password'];
  $ssn = $_POST['ssn'];
  $new_score = $_POST['new_score'];

  mysql_select_db("cs41515_taron1_db",$db);
  // ********* Remember to use the name of your database here ********* //

  $result = mysql_query("CALL UpdateMidterm('$password', $ssn, $new_score)",$db);
  // check if password exists

  if (!$result) {

    echo "Query Failed!.\n";
    print mysql_error();

  } else {
    while ($myrow = mysql_fetch_array($result)) {
        printf("<b>%s</b>\n", $myrow["Output"]);
    }

  }

}

// PHP code about to end

 ?>



 </body>
