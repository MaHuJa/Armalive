<?php
$dbhost = 'master1.armalive.com';
$dbname = 'armalive_master';
$name = 'armalive.com';
$pass = 'armalive.com'; // will be changed at some point

// DBCONNECTION
$db = 0;
try {
    $db = new PDO("pgsql:host=$dbhost;dbname=$dbname;user=$name;password=$pass");
} catch (PDOException $e) {
    die("Error!: " . $e->getMessage() . "<br/>");
}

// Form for changing your search
$name = $_GET['name'];
$name_form = htmlentities($name, ENT_QUOTES);
echo <<<HEREDOC
<form action="findplayer.php" method="get">
  Name search: <input type="text" name="name" value="$name_form"> <input type="submit" value="Submit">
</form> 
HEREDOC;
$namesearch = '%';
if ($_GET['name']) {
	$namesearch = '%' . $_GET['name'] . '%';
}

$players_q = <<<HEREDOC
select * from player.playername
where name ILIKE :namesearch
HEREDOC;
$prep = $db->prepare($players_q);
$prep->bindValue(':namesearch', $namesearch);
$prep->execute();
print($players_q);
print($namesearch);
//var_dump ($prep->errorInfo());

print ('<table border="2"><tr>');
$columns = $prep->columnCount();
for ($i = 0; $i < $columns; $i++) {
 $s = $prep->getColumnMeta($i)['name'];
 print ("<td>$s</td>\n");
}
print ("</tr>\n");

$all = $prep->fetchAll(PDO::FETCH_NUM);

foreach ($all as $row) {
 print ("<tr>");
 foreach ($row as $column) { echo "<td>$column</td>"; };
 echo ("</tr>\n");
}
print ("</table>\n");
?>