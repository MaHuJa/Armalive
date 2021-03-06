<?php

function printresult ($prep) {
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
}

//$dbhost = 'master1.armalive.com';
$dbhost = 'localhost';
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

// PARAMETERS
$playeruid = $_GET['playeruid'];
if (is_null($playeruid)) {$playeruid = '76561198080819113'; }
// the following will be implemented later
$server = $_GET['onlyserver'];
$mission = $_GET['missionname'];

// Users names
$names_q = <<<HEREDOC
SELECT 
  playername.name as "Name", 
  to_char(playername.lastseen at time zone 'UTC', 'YYYY-MM-DD HHMMz') as "Last seen", 
  to_char(playername.firstseen at time zone 'UTC', 'YYYY-MM-DD HHMMz') as "First seen"
FROM 
  player.playername
JOIN player.player on playername.playerid = player.id
WHERE 
  gameuid = :id
ORDER BY
  "Last seen" desc
;
HEREDOC;
$prep = $db->prepare($names_q);
$prep->bindValue(':id', $playeruid);
$prep->execute();
printresult($prep);


// KILLS
$kills_q = <<<HEREDOC
select count(killer) as "Kills", case "teamkill" when 'teamkill' then 'teamkill' else how end as "How"
from event.deathevent
join player.player killers on killers.id = deathevent.killer
where killers.gameuid = :id
group by killer, how, teamkill
;
HEREDOC;
$prep = $db->prepare($kills_q);
$prep->bindValue(':id', $playeruid);
$prep->execute();
printresult($prep);

// Deaths by type
$deaths_q = <<<HEREDOC
select count(victim) as "Deaths", case "teamkill" when 'teamkill' then 'teamkill' else how end as "How"
from event.deathevent
join player.player v on victim = v.id
where v.gameuid = :id
group by victim,how,teamkill
order by "Deaths" desc
;
HEREDOC;
$prep = $db->prepare($deaths_q);
$prep->bindValue(':id', $playeruid);
$prep->execute();
printresult($prep);

// Killed most
$prey_q = <<<HEREDOC
with kills_list as (
SELECT victim, count(eventid) as kills
  FROM event.deathevent
where  killer = util.player_uid_to_id(:id) and teamkill = 'not'
group by victim
order by kills desc
limit 5
)
select last_name_seen as "Favorite prey", kills
from kills_list
join player.player on player.id = victim
order by kills desc
;
HEREDOC;
$prep = $db->prepare($prey_q);
$prep->bindValue(':id', $playeruid);
$prep->execute();
printresult($prep);

// Killed most by
$nemesis_q = <<<HEREDOC
with kills_list as (
SELECT killer, count(eventid) as kills
  FROM event.deathevent
where  victim = util.player_uid_to_id(:id) and teamkill = 'not'
group by killer
order by kills desc
limit 5
)
select last_name_seen as "Greatest nemesis", kills
from kills_list
join player.player on player.id = killer
order by kills desc
;
HEREDOC;
$prep = $db->prepare($nemesis_q);
$prep->bindValue(':id', $playeruid);
$prep->execute();
//var_dump($prep->errorInfo());
printresult($prep);














?>
