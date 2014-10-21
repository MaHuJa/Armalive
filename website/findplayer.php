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
$page = intval($_GET['page']);
if ($page==0) $page=1;

$players_q = <<<HEREDOC
select 
	gameuid, 
	playername.name as name, 
	to_char(playername.lastseen at time zone 'UTC', 'YYYY-MM-DD HHMMz') as "Last seen",
	to_char(playername.firstseen at time zone 'UTC', 'YYYY-MM-DD HHMMz') as "First seen"
from player.playername
join player.player on playername.playerid = player.id
where name ILIKE :namesearch
order by playername.lastseen
offset :page
limit 100
HEREDOC;
$prep = $db->prepare($players_q);
$prep->bindValue(':namesearch', $namesearch);
$prep->bindValue(':page',($page-1)*100);
$prep->execute();

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
print ("</table><br>\n");

if ($page > 1) {
	$pageprev = $page-1;
	print ("<a href=\"findplayer.php?name=$name_form&page=$pageprev\">&lt;&lt;</a>");
}
echo ' ';
$pagenext = $page+1;
print ("<a href=\"findplayer.php?name=$name_form&page=$pagenext\">&gt;&gt;</a>");


?>