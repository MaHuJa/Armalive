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
$sessionid = intval($_GET['armasessionid']);

$weapon_q = <<<HEREDOC
SELECT eventid, "time", victims.last_name_seen as Victimname, how, killers.last_name_seen as Killername, round(point(victim_position[1], victim_position[2]) <-> point(killer_position[1],killer_position[2]),1) as distance,
       killer_weapon, teamkill
  FROM event.deathevent
join player.player victims on victim = victims.id
join player.player killers on killer = killers.id
where session = $sessionid
order by eventid asc
;
HEREDOC;

$prep = $db->prepare($weapon_q);
//$prep->bindValue(':id', $id);
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
print ("</table>\n");
?>