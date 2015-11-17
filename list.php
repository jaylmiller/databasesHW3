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

  mysql_select_db("cs41515_taron1_db",$db);
  // ********* Remember to use the name of your database here ********* //

  $result = mysql_query("SELECT * from Passwords WHERE CurPasswords like '$password'",$db);
  // check if password exists

  if (mysql_num_rows($result) == 0) {

    echo "ERROR: Invalid Password.\n";

  } else {
    $raw_scores = mysql_query("SELECT * FROM Rawscores WHERE SSN != 0001 and SSN != 0002 ORDER BY Section ASC, LName ASC, FName ASC", $db);
    echo "<table border=1>\n";
    echo "<tr>";
    echo "<td>SSN</td>";
    echo "<td>LName</td>";
    echo "<td>FName</td>";
    echo "<td>Section</td>";
    echo "<td>HW1</td>";
    echo "<td>HW2a</td>";
    echo "<td>HW2b</td>";
    echo "<td>Midterm</td>";
    echo "<td>HW3</td>";
    echo "<td>FExam</td>";
    echo "</tr>\n";

    while ($myrow = mysql_fetch_array($raw_scores)) {
      echo "<tr>";
      printf("<td>%d</td><td>%s</td>", $myrow["SSN"], $myrow["LName"]);
      printf("<td>%s</td><td>%d</td>", $myrow["FName"], $myrow["Section"]);
      printf("<td>%d</td><td>%d</td>", $myrow["HW1"], $myrow["HW2a"]);
      printf("<td>%d</td><td>%d</td>", $myrow["HW2b"], $myrow["Midterm"]);
      printf("<td>%d</td><td>%d</td>", $myrow["HW3"], $myrow["FExam"]);
      echo "</tr>\n";
    }

    echo "</table>\n";

  }

}

// PHP code about to end

 ?>



 </body>
