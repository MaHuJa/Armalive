<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1410980050572" ID="ID_142879548" MODIFIED="1411257087521" TEXT="Armalive sqf requirements">
<node CREATED="1411246710059" ID="ID_229996467" MODIFIED="1411269638290" POSITION="right" TEXT="How to read this mindmap">
<node CREATED="1411246733255" ID="ID_1525291828" MODIFIED="1411246773229" TEXT="DB function definitions include a first parameter &quot;sessionid&quot; which scripts shall pretend does not exist"/>
<node CREATED="1411250047072" ID="ID_751023744" MODIFIED="1411250064083" TEXT="Not implemented in database side">
<icon BUILTIN="closed"/>
</node>
<node CREATED="1411252484035" ID="ID_529082041" MODIFIED="1411252683953" TEXT="Example string">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1411252886453" ID="ID_1282277908" MODIFIED="1411252890013" TEXT="Commentary">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1411254309438" ID="ID_124785962" MODIFIED="1411254321989" TEXT="Not quite decided">
<icon BUILTIN="help"/>
</node>
</node>
<node CREATED="1411189292156" ID="ID_638219901" MODIFIED="1411189308553" POSITION="right" TEXT="There should be exactly one message per event"/>
<node CREATED="1411248645565" ID="ID_1045708319" MODIFIED="1411256730183" POSITION="right" TEXT="Common Database calls">
<node CREATED="1411251384304" ID="ID_1658327242" MODIFIED="1411269820301" TEXT="Common parameters">
<node CREATED="1411249546958" ID="ID_1062947714" MODIFIED="1411249739385" TEXT="When: time in seconds since mission start.">
<node CREATED="1411249740017" ID="ID_1786737069" MODIFIED="1411249742332" TEXT="https://community.bistudio.com/wiki/time"/>
</node>
<node CREATED="1411249625778" ID="ID_1618748304" MODIFIED="1411250091837" TEXT="victim_uid, killer_uid">
<node CREATED="1411249762422" ID="ID_1168308256" MODIFIED="1411249763021" TEXT="https://community.bistudio.com/wiki/getPlayerUID"/>
</node>
<node CREATED="1411260395053" ID="ID_701316146" MODIFIED="1411267840951" TEXT="victim_position, killer_position, other positions">
<node CREATED="1411260409508" ID="ID_1256015893" MODIFIED="1411260416707" TEXT="ASL positions"/>
</node>
</node>
<node CREATED="1411248651473" ID="ID_973020385" MODIFIED="1411269816346" TEXT="infkilled1">
<node CREATED="1411249538002" ID="ID_907165344" MODIFIED="1411249539327" TEXT="inf_killed1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text)"/>
<node CREATED="1411250538108" ID="ID_1768384659" MODIFIED="1411250557181" TEXT="victim_class is always the unit type"/>
<node CREATED="1411250558246" ID="ID_1179813714" MODIFIED="1411250578103" TEXT="killer_class is always the &quot;typeof vehicle _killer&quot;">
<node CREATED="1411250582299" ID="ID_1028805907" MODIFIED="1411251665728" TEXT="meaning vehicle if he&apos;s in one"/>
</node>
<node CREATED="1411251461737" ID="ID_82184398" MODIFIED="1411251467151" TEXT="killer_weapon">
<node CREATED="1411250603175" ID="ID_663337398" MODIFIED="1411251475887" TEXT="If by shot, a valid entry in cfgweapons (given the correct mods)"/>
<node CREATED="1411250828883" ID="ID_1013774991" MODIFIED="1411250838858" TEXT="If by explosive, the cfgMagazines name">
<node CREATED="1411251486767" ID="ID_335448416" MODIFIED="1411251582007" TEXT="Scripted explosives may use slightly different names"/>
</node>
<node CREATED="1411251337221" ID="ID_1936115207" MODIFIED="1411251344541" TEXT="Else, it should remain empty"/>
</node>
<node CREATED="1411249807394" ID="ID_1510884345" MODIFIED="1411252549359" TEXT="istk (&quot;is teamkill&quot;) must be one of">
<node CREATED="1411249867204" ID="ID_317352450" MODIFIED="1411252159964" TEXT="not"/>
<node CREATED="1411250021494" ID="ID_1493797330" MODIFIED="1411252129566" TEXT="roe_violation">
<icon BUILTIN="closed"/>
<node CREATED="1411251802174" ID="ID_620785641" MODIFIED="1411252225866" TEXT="Shooting a non-target combatant">
<node CREATED="1411252226560" ID="ID_793566281" MODIFIED="1411252264229" TEXT="Blufor kills greenfor while they&apos;re supposed to be friendly"/>
</node>
<node CREATED="1411251768914" ID="ID_894466482" MODIFIED="1411251787707" TEXT="The mission should clearly have said you&apos;re not to open fire."/>
</node>
<node CREATED="1411249869364" ID="ID_1922053209" MODIFIED="1411249871386" TEXT="teamkill"/>
<node CREATED="1411249952634" ID="ID_1125408677" MODIFIED="1411249955353" TEXT="civilian"/>
<node CREATED="1411249955811" ID="ID_11673347" MODIFIED="1411249960957" TEXT="potential warcrime"/>
<node CREATED="1411249967871" ID="ID_177102107" MODIFIED="1411252133664" TEXT="Only with proper manual review should anything be flagged &quot;definite warcrime&quot;.">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
<node CREATED="1411250285269" ID="ID_641735279" MODIFIED="1411269651993" TEXT="Blocked at db input">
<icon BUILTIN="closed"/>
</node>
</node>
</node>
<node CREATED="1411248659328" ID="ID_1803157399" MODIFIED="1411252478235" TEXT="inf_killed1;677.047;76561197970503377;[16031.8,16985.8,0.00146198];B_engineer_F;WEST;76561198002768758;[16031.9,16981.4,0.0014267];O_Soldier_AAR_F;EAST;arifle_Katiba_ACO_pointer_F;not">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1411251998507" ID="ID_782296840" MODIFIED="1411252000644" TEXT="suicide1">
<node CREATED="1411256786286" ID="ID_1266598245" MODIFIED="1411256787306" TEXT="suicide1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text)"/>
</node>
<node CREATED="1411257795502" ID="ID_1070986450" MODIFIED="1411257796683" TEXT="died1">
<node CREATED="1411257797792" ID="ID_366157584" MODIFIED="1411257799009" TEXT="died1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text)"/>
</node>
</node>
<node CREATED="1411246519253" ID="ID_107950699" MODIFIED="1411248988265" POSITION="right" TEXT="Session/Player accounting">
<node CREATED="1411246590491" ID="ID_290973949" MODIFIED="1411246592801" TEXT="New session"/>
<node CREATED="1411246572031" ID="ID_1508408840" MODIFIED="1411249590221" TEXT="Player joined">
<node CREATED="1411246694432" ID="ID_610564600" MODIFIED="1411246696083" TEXT="newplayer1(sessionid integer, playeruid text, playerside text, jointime numeric, VARIADIC playername_p text[])"/>
<node CREATED="1411246799799" ID="ID_1153877399" MODIFIED="1411246891942" TEXT="playerside is assumed to be constant until leaving">
<icon BUILTIN="messagebox_warning"/>
<node CREATED="1411253083019" ID="ID_88266992" MODIFIED="1411253201498" TEXT="Affects side balancing etc"/>
</node>
<node CREATED="1411246900631" ID="ID_1987653379" MODIFIED="1411253050788" TEXT="playername_p shall be passed as a plain unquoted string of the players name. ">
<node CREATED="1411247806602" ID="ID_1570962258" MODIFIED="1411247819561" TEXT="A name containing a ; will work correctly."/>
</node>
<node CREATED="1411247127960" ID="ID_357791315" MODIFIED="1411252917952" TEXT="newplayer1;76561197970503377;WEST;0;Vlad">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1411246575541" ID="ID_1780633635" MODIFIED="1411246577839" TEXT="Player left"/>
<node CREATED="1411246593790" ID="ID_1287542351" MODIFIED="1411253152195" TEXT="End of session">
<node CREATED="1411246599431" ID="ID_1716485836" MODIFIED="1411257478568" TEXT="Depends on mission; stats system cannot handle this purely on its own"/>
<node CREATED="1411257448674" ID="ID_399214735" MODIFIED="1411257449549" TEXT="endsession1(sessionid integer, duration numeric, outcome text)"/>
</node>
</node>
<node CREATED="1411246526682" ID="ID_1157462138" MODIFIED="1411269872215" POSITION="right" TEXT="Kill/Death registration">
<node CREATED="1411249601144" ID="ID_627582656" MODIFIED="1411249607937" TEXT="Killed by shot">
<node CREATED="1411249173058" ID="ID_1214812846" LINK="#ID_973020385" MODIFIED="1411251635776" TEXT="infkilled1"/>
<node CREATED="1411257557771" ID="ID_1943215810" MODIFIED="1411257595555" TEXT="It may be possible to get hit by your own ricochet">
<node CREATED="1411257576952" ID="ID_1293675892" LINK="#ID_782296840" MODIFIED="1411257586068" TEXT="suicide1"/>
</node>
<node CREATED="1411265994273" ID="ID_573944941" MODIFIED="1411266001831" TEXT="kill/suicide/teamkill"/>
<node CREATED="1411266005084" ID="ID_985018267" MODIFIED="1411266017556" TEXT="by infantry/vehicle"/>
<node CREATED="1411420801532" ID="ID_119882297" MODIFIED="1411420813893" TEXT="Should register for the correct gunner in a multigunner vehicle">
<node CREATED="1411420815194" ID="ID_662243782" MODIFIED="1411420822866" TEXT="Tank gunner and commander"/>
<node CREATED="1411420823339" ID="ID_674614468" MODIFIED="1411420831827" TEXT="Helicopter with door guns on each side"/>
</node>
</node>
<node CREATED="1411188897898" ID="ID_1445224943" MODIFIED="1411253284971" TEXT="Killed by a bomb (vanilla)">
<node CREATED="1411249173058" ID="ID_1901952982" LINK="#ID_973020385" MODIFIED="1411251633626" TEXT="infkilled1"/>
<node CREATED="1411242849615" ID="ID_824827446" LINK="#ID_782296840" MODIFIED="1411253341827" TEXT="suicide1"/>
<node CREATED="1411243210127" ID="ID_1236087480" MODIFIED="1411243228751" TEXT="For req purposes grenades fall under this."/>
</node>
<node CREATED="1411188994871" ID="ID_1276141249" MODIFIED="1411253333401" TEXT="Killed by a bomb (scripted)">
<node CREATED="1411249173058" ID="ID_476686163" LINK="#ID_973020385" MODIFIED="1411251633626" TEXT="infkilled1"/>
<node CREATED="1411242849615" ID="ID_168075294" LINK="#ID_782296840" MODIFIED="1411253341827" TEXT="suicide1"/>
<node CREATED="1411189011491" ID="ID_475136480" MODIFIED="1411189025242" TEXT="Requires support from the script"/>
<node CREATED="1411242849615" ID="ID_1067097159" MODIFIED="1411242859632" TEXT="Suicide if you did it yourself"/>
</node>
<node CREATED="1411079817699" ID="ID_1266935527" MODIFIED="1411257367000" TEXT="Roadkill">
<node CREATED="1411256859476" ID="ID_1039798979" MODIFIED="1411256860195" TEXT="roadkill1(sessionid integer, victimid text, killerid text, vehicle_used text, score integer, &quot;position&quot; text)"/>
</node>
<node CREATED="1411189056930" ID="ID_968515743" MODIFIED="1411420855560" TEXT="Player dies long after injury">
<node CREATED="1411189165221" ID="ID_599775576" MODIFIED="1411420848413" TEXT="Appropriate message needs to be sent">
<node CREATED="1411242958453" ID="ID_860332593" MODIFIED="1411243849703" TEXT="Unless sent at the time it happened&#xa;Which is appropriate for some medic/revival scripts."/>
</node>
<node CREATED="1411189076061" ID="ID_831501880" MODIFIED="1411189110778" TEXT="Bleeding out, revival script timeout, etc"/>
</node>
<node CREATED="1410980066323" ID="ID_38876002" MODIFIED="1411257125688" TEXT="Infantry Kills">
<node CREATED="1410980118479" ID="ID_44946867" MODIFIED="1411088593201" TEXT="Should elicit exactly one kill message"/>
<node CREATED="1411081146558" ID="ID_1848479244" MODIFIED="1411081171120" TEXT="Detect teamkills, report them as such"/>
</node>
<node CREATED="1411243011214" ID="ID_341649347" MODIFIED="1411274286554" TEXT="Death by falling">
<icon BUILTIN="help"/>
<node CREATED="1411254005448" ID="ID_10833575" MODIFIED="1411254009706" TEXT="suicide1"/>
<node CREATED="1411253656368" ID="ID_1551882923" MODIFIED="1411253786178" TEXT="Appears as a suicide?"/>
<node CREATED="1411253845593" ID="ID_918103929" MODIFIED="1411253849821" TEXT="Should be treated as suicide"/>
</node>
<node CREATED="1411243029394" ID="ID_132054614" MODIFIED="1411257134823" TEXT="Death by car crash">
<node CREATED="1411246102416" ID="ID_694363659" MODIFIED="1411254178150" TEXT="In essence similar to aircraft crashes">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
<node CREATED="1411254141294" ID="ID_223217388" MODIFIED="1411254144992" TEXT="Driver">
<node CREATED="1411242849615" ID="ID_1069337052" LINK="#ID_782296840" MODIFIED="1411253341827" TEXT="suicide1"/>
</node>
<node CREATED="1411257749447" ID="ID_880003531" MODIFIED="1411257769893" TEXT="Passengers">
<node CREATED="1411274323378" ID="ID_703539744" LINK="#ID_1070986450" MODIFIED="1411274329777" TEXT="died1"/>
</node>
</node>
<node CREATED="1410980083475" ID="ID_1067078033" MODIFIED="1411243077757" TEXT="Scripted deaths">
<node CREATED="1411254265337" ID="ID_99590567" MODIFIED="1411254273044" TEXT="death1"/>
</node>
<node CREATED="1411243237545" ID="ID_1045419302" MODIFIED="1411268619310" TEXT="Drowning">
<node CREATED="1411256892075" ID="ID_1590035241" MODIFIED="1411256893080" TEXT="drowned1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text)"/>
</node>
<node CREATED="1411081180736" ID="ID_1613880427" MODIFIED="1411254574230" TEXT="Vehicle kills">
<node CREATED="1411267893876" ID="ID_1062147332" MODIFIED="1411267895045" TEXT="server.veh_killed1(sessionid integer, &quot;when&quot; numeric, severity text, vehicleclass text, vehicle_position text,  last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text,  killer_class text, killer_weapon text, killer_side text )"/>
<node CREATED="1411267924329" ID="ID_3410161" MODIFIED="1411267927359" TEXT="Severity">
<node CREATED="1411081419579" ID="ID_1122652404" MODIFIED="1411267962941" TEXT="Scrapped is mandatory, the rest is just a quality of implementation issue">
<font ITALIC="true" NAME="Arial" SIZE="12"/>
</node>
<node CREATED="1411081186378" ID="ID_579096371" MODIFIED="1411267978208" TEXT="Mobility">
<node CREATED="1411081224244" ID="ID_1001432065" MODIFIED="1411084200819" TEXT="It has been hit such that it can no longer move effectively"/>
<node CREATED="1411084182246" ID="ID_1448682386" MODIFIED="1411084196547" TEXT="Sufficient number of wheels taken out"/>
</node>
<node CREATED="1411081208618" ID="ID_824965025" MODIFIED="1411081214038" TEXT="Evacuated">
<node CREATED="1411081368922" ID="ID_283984935" MODIFIED="1411084208382" TEXT="The crew decided to get out after getting hit"/>
</node>
<node CREATED="1411081214356" ID="ID_1091587026" MODIFIED="1411254563516" TEXT="Decrewed">
<node CREATED="1411081381243" ID="ID_1142736689" MODIFIED="1411255079826" TEXT="The crew was killed">
<node CREATED="1411254349911" ID="ID_1423853345" MODIFIED="1411254360225" TEXT="Don&apos;t have to kill passengers"/>
</node>
</node>
<node CREATED="1411081217620" ID="ID_574106719" MODIFIED="1411084174404" TEXT="Scrapped">
<node CREATED="1411081387473" ID="ID_1009081452" MODIFIED="1411081416445" TEXT="It went boom!"/>
</node>
</node>
<node CREATED="1411244255369" ID="ID_1892036136" MODIFIED="1411244268392" TEXT="Side of the vehicle, side of last users of vehicle"/>
<node CREATED="1411081472957" ID="ID_710542502" MODIFIED="1411267950580" TEXT="Try to send only one message">
<icon BUILTIN="help"/>
<node CREATED="1411081650944" ID="ID_631644036" MODIFIED="1411081701290" TEXT="you hit the tires, the crew gets out, &#xa;and the whole thing blows up 5 seconds later:&#xa;we really only want the scrapped message. "/>
</node>
</node>
<node CREATED="1411243372884" ID="ID_192433780" MODIFIED="1411254477331" TEXT="Vehicle explosion kills surrounding stuff">
<icon BUILTIN="help"/>
<node CREATED="1411243454862" ID="ID_686441370" MODIFIED="1411243478831" TEXT="Should count as kills to the one credited with the initial kill"/>
<node CREATED="1411254435833" ID="ID_998325642" MODIFIED="1411254445544" TEXT="What does the various eventhandlers give us?">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1410980086928" ID="ID_1948730664" MODIFIED="1410980113866" TEXT="Aircraft Crashes">
<node CREATED="1411257407564" ID="ID_1272228758" MODIFIED="1411257408299" TEXT="accrash1(sessionid integer, &quot;when&quot; numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text)"/>
</node>
</node>
<node CREATED="1411243301478" ID="ID_288797497" MODIFIED="1411255288529" POSITION="right" TEXT="Unit Vehicle Weapon statistics">
<node CREATED="1411255157468" ID="ID_1701642190" MODIFIED="1411255175444" TEXT="Send updates periodically"/>
<node CREATED="1411243625603" ID="ID_104631808" MODIFIED="1411243711202" TEXT="One message for each uvw combo whose counts have changed"/>
<node CREATED="1411256841694" ID="ID_181118575" MODIFIED="1411256842544" TEXT="server.uvwstats(IN sessionid integer, IN &quot;when&quot; numeric, IN playerid text, IN unitclass text, IN vehicleclass text, IN weaponclass text, IN weapontime numeric, VARIADIC hits text[])"/>
</node>
<node CREATED="1411243542252" ID="ID_737534664" MODIFIED="1411256539832" POSITION="right" TEXT="Transportation">
<icon BUILTIN="pencil"/>
<node CREATED="1411243861985" ID="ID_999191678" MODIFIED="1411244142068" TEXT="Who provided the transport"/>
<node CREATED="1411244142478" ID="ID_1049682278" MODIFIED="1411244144399" TEXT="What vehicle"/>
<node CREATED="1411244144687" ID="ID_301443479" MODIFIED="1411244147231" TEXT="Who was transported"/>
<node CREATED="1411247907544" ID="ID_1538023174" MODIFIED="1411247912955" TEXT="What was transported (cargo)"/>
<node CREATED="1411255664267" ID="ID_215043465" MODIFIED="1411255671402" TEXT="Distance from destination (if applicable)"/>
<node CREATED="1411244174929" ID="ID_668636325" MODIFIED="1411244279078" TEXT="ATLAS: Ties into giving points for vehicle crew, pilots">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1411243979107" ID="ID_1176768800" MODIFIED="1411256418138" POSITION="right" TEXT="Damage but not kill of friendly">
<icon BUILTIN="pencil"/>
<node CREATED="1411255709951" ID="ID_476874666" MODIFIED="1411255764245" TEXT="Griefer detector"/>
<node CREATED="1411257832110" ID="ID_1533171003" MODIFIED="1411257857884" TEXT="friendlydmg1(...) "/>
</node>
<node CREATED="1411244819430" ID="ID_1457276037" MODIFIED="1411255819459" POSITION="right" TEXT="Randomly report positions">
<icon BUILTIN="pencil"/>
<node CREATED="1411244848835" ID="ID_1025410739" MODIFIED="1411244856833" TEXT="More work needs to go into this"/>
<node CREATED="1411244857250" ID="ID_362940804" MODIFIED="1411244874529" TEXT="Every 60-300 seconds, send a db report on where the player is"/>
</node>
<node CREATED="1411244916068" ID="ID_464897636" MODIFIED="1411256212845" POSITION="right" TEXT="Shot reports">
<icon BUILTIN="pencil"/>
<node CREATED="1411244921154" ID="ID_1879609824" MODIFIED="1411244938645" TEXT="Report from where and what direction a player shoots"/>
<node CREATED="1411244941078" ID="ID_1337826126" MODIFIED="1411244967657" TEXT="Do not send further reports for 30 seconds after previous message"/>
</node>
<node CREATED="1411245441833" ID="ID_1051322261" MODIFIED="1411256211132" POSITION="right" TEXT="Medical/healing">
<node CREATED="1411245482148" ID="ID_419922949" MODIFIED="1411245488412" TEXT="Will depend on medical system in use"/>
</node>
<node CREATED="1411244230047" FOLDED="true" ID="ID_1113245109" MODIFIED="1411525853179" POSITION="left" TEXT="Bstats feature list">
<node CREATED="1411244602977" ID="ID_43480712" MODIFIED="1411244602977" TEXT="">
<node CREATED="1411244586034" FOLDED="true" ID="ID_130987651" MODIFIED="1411244647509" TEXT="Combat:">
<node CREATED="1411244627549" ID="ID_28318494" MODIFIED="1411244641264" TEXT="inf kills"/>
<node CREATED="1411244629267" ID="ID_646300282" MODIFIED="1411244632883" TEXT="veh kills"/>
<node CREATED="1411244633125" ID="ID_229078993" MODIFIED="1411244634122" TEXT="deaths"/>
<node CREATED="1411244634389" ID="ID_1866906703" MODIFIED="1411244637285" TEXT="roadkill"/>
</node>
<node CREATED="1411244649766" FOLDED="true" ID="ID_161186209" MODIFIED="1411244676179" TEXT="objectives">
<node CREATED="1411244654017" ID="ID_389203958" MODIFIED="1411244658100" TEXT="destroy"/>
<node CREATED="1411244663149" ID="ID_1191813804" MODIFIED="1411244665968" TEXT="capture"/>
<node CREATED="1411244666386" ID="ID_283334355" MODIFIED="1411244668254" TEXT="defend"/>
<node CREATED="1411244668723" ID="ID_345315169" MODIFIED="1411244670399" TEXT="attempt"/>
<node CREATED="1411244671089" ID="ID_1134509466" MODIFIED="1411244673056" TEXT="assist"/>
</node>
<node CREATED="1411244687558" FOLDED="true" ID="ID_345043270" MODIFIED="1411244747560" TEXT="ROE">
<node CREATED="1411244689617" ID="ID_1644781775" MODIFIED="1411244729471" TEXT="inf teamkills"/>
<node CREATED="1411244729709" ID="ID_1059648050" MODIFIED="1411244732113" TEXT="veh teamkills"/>
<node CREATED="1411244734009" ID="ID_1932312381" MODIFIED="1411244735772" TEXT="suicides"/>
<node CREATED="1411244736019" ID="ID_197083051" MODIFIED="1411244737445" TEXT="drowning"/>
<node CREATED="1411244737702" ID="ID_292410946" MODIFIED="1411244739551" TEXT="team damage"/>
<node CREATED="1411244739794" ID="ID_893225740" MODIFIED="1411244743926" TEXT="ac crash"/>
</node>
<node CREATED="1411244748428" FOLDED="true" ID="ID_81132403" MODIFIED="1411244765850" TEXT="Teamwork">
<node CREATED="1411244750709" ID="ID_921122865" MODIFIED="1411244757609" TEXT="Medical treatment"/>
<node CREATED="1411244758118" ID="ID_1616543782" MODIFIED="1411244759589" TEXT="repair"/>
<node CREATED="1411244759963" ID="ID_1743177045" MODIFIED="1411244763117" TEXT="build"/>
<node CREATED="1411244763630" ID="ID_993161948" MODIFIED="1411244765077" TEXT="transport"/>
</node>
<node CREATED="1411244767378" FOLDED="true" ID="ID_1864669560" MODIFIED="1411244799544" TEXT="Weapons stats">
<node CREATED="1411244781258" ID="ID_919534212" MODIFIED="1411244796061" TEXT="Time used&#xa;Shots&#xa;Head hits&#xa;Torso hits&#xa;L Arm hits&#xa;R Arm hits&#xa;L leg hits&#xa;R Leg hits&#xa;"/>
</node>
</node>
</node>
</node>
</map>
