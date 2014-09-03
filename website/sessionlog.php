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

$kills_q = <<<HEREDOC
SELECT eventid, "time", victims.last_name_seen as Victimname, how, killers.last_name_seen as Killername, round(point(victim_position[1], victim_position[2]) <-> point(killer_position[1],killer_position[2])) as "Distance (m)",
       killer_weapon, teamkill
  FROM event.deathevent
join player.player victims on victim = victims.id
join player.player killers on killer = killers.id
where session = $sessionid
order by eventid asc
;
HEREDOC;

$kprep = $db->prepare($kills_q);
//$prep->bindValue(':id', $id);
$kprep->execute();

$acc_q = <<<HEREDOC
select eventid, "time", playerid, last_name_seen as playername, passengers, vehicle_class, round(point(player_position[1], player_position[2]) <-> point(vehicle_position[1],vehicle_position[2])) as distance
from event.ac_crash
join player.player on playerid = player.id
where session = $sessionid
order by eventid asc
;
HEREDOC;

//var_dump ($prep->errorInfo());

$prep = $kprep; // Just to keep the below display working
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