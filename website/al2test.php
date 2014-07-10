<?php
$dbhost = 'master1.armalive.com';
$dbname = 'bstats_master';
$name = 'hidden';
$pass = 'hidden';	// will be changed at some point

// DBCONNECTION
$db = 0;
try {
    $db = new PDO("pgsql:host=$dbhost;dbname=$dbname;user=$name;password=$pass");
} catch (PDOException $e) {
    die("Error!: " . $e->getMessage() . "<br/>");
}

$weapon_q = <<<HEREDOC
with kills as 
(
SELECT killer,
	count(killer) as killcount, 
	first_value(weapon) over (partition by killer order by count(victim) desc) as weapon
  FROM event.deathevent
GROUP BY killer,weapon
--order by killcount,weapon
)
select last_name_seen as "Name", sum(killcount) as "Killcount", weapon as "Favorite Weapon"
from kills 
left join player.player on player.player.id = kills.killer
group by player.last_name_seen, weapon
order by "Killcount" desc
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
