<map version="1.0.1">
<!-- To view this file, download free mind mapping software FreeMind from http://freemind.sourceforge.net -->
<node CREATED="1410980050572" ID="ID_142879548" MODIFIED="1411257087521" TEXT="Armalive sqf requirements">
<node CREATED="1411246710059" ID="ID_229996467" MODIFIED="1417896318096" POSITION="right" TEXT="How to read this mindmap">
<node CREATED="1411246733255" ID="ID_1525291828" MODIFIED="1411246773229" TEXT="DB function definitions include a first parameter &quot;sessionid&quot; which scripts shall pretend does not exist"/>
<node CREATED="1417426503642" ID="ID_529498786" MODIFIED="1417426529844" TEXT="DB functions whose last parameter is &quot;variadic&quot; can take any number of parameters">
<node CREATED="1417426539001" ID="ID_865648012" MODIFIED="1417426565125" TEXT="Often simply to handle embedded semicolons"/>
<node CREATED="1417427669466" ID="ID_13713991" MODIFIED="1417427676314" TEXT="Or a list of player uids"/>
</node>
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
<node CREATED="1412013730995" ID="ID_1817445299" MODIFIED="1412013747567" TEXT="At the idea stage">
<icon BUILTIN="pencil"/>
</node>
<node CREATED="1417547526424" ID="ID_910766506" MODIFIED="1417547637113" TEXT="A future version of this spec may require this">
<icon BUILTIN="hourglass"/>
</node>
</node>
<node CREATED="1411189292156" ID="ID_724230088" MODIFIED="1417896317161" POSITION="right" TEXT="There should be one message covering an event.">
<node CREATED="1417551656866" ID="ID_1044625380" MODIFIED="1417551674615" TEXT="As opposed to reporting &quot;I killed someone&quot; and &quot;I got killed&quot; separately"/>
</node>
<node CREATED="1411248645565" ID="ID_1045708319" MODIFIED="1417430401635" POSITION="right" TEXT="Common Database calls">
<node CREATED="1411251384304" ID="ID_1658327242" MODIFIED="1417426738498" TEXT="Common parameters">
<node CREATED="1411249546958" ID="ID_1062947714" MODIFIED="1411249739385" TEXT="When: time in seconds since mission start.">
<node CREATED="1411249740017" ID="ID_1786737069" MODIFIED="1411249742332" TEXT="https://community.bistudio.com/wiki/time"/>
</node>
<node CREATED="1411249625778" ID="ID_1618748304" MODIFIED="1411250091837" TEXT="victim_uid, killer_uid">
<node CREATED="1411249762422" ID="ID_1168308256" MODIFIED="1411249763021" TEXT="https://community.bistudio.com/wiki/getPlayerUID"/>
</node>
<node CREATED="1411260395053" ID="ID_701316146" MODIFIED="1411267840951" TEXT="victim_position, killer_position, other positions">
<node CREATED="1411260409508" ID="ID_1256015893" MODIFIED="1411260416707" TEXT="ASL positions"/>
</node>
<node CREATED="1417552152805" ID="ID_1179968977" MODIFIED="1417552266247" TEXT="vehicleid">
<node CREATED="1417552158112" ID="ID_27558964" MODIFIED="1417552342021" TEXT="Some string that uniquely identifies a vehicle">
<node CREATED="1417552622062" ID="ID_1331227598" MODIFIED="1417552700769" TEXT="We want to know if two events refer to the same vehicle"/>
</node>
<node CREATED="1417552345723" ID="ID_1615139055" MODIFIED="1417552358897" TEXT="In multiplayer, netid is a candidate"/>
<node CREATED="1417552565908" ID="ID_1733811469" MODIFIED="1417552591276" TEXT="Redundant info should be cut away"/>
<node CREATED="1417556577941" ID="ID_172693346" MODIFIED="1417556589180" TEXT="If the script does not (yet) support this, it may be empty"/>
</node>
</node>
<node CREATED="1411248651473" ID="ID_973020385" MODIFIED="1417556070910" TEXT="infkilled1">
<node CREATED="1411249538002" ID="ID_907165344" MODIFIED="1411249539327" TEXT="inf_killed1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_weapon text, istk text)"/>
<node CREATED="1411250538108" ID="ID_1768384659" MODIFIED="1411250557181" TEXT="victim_class is always the unit type"/>
<node CREATED="1411250558246" ID="ID_1179813714" MODIFIED="1411250578103" TEXT="killer_class is always the &quot;typeof vehicle _killer&quot;">
<node CREATED="1411250582299" ID="ID_1028805907" MODIFIED="1411251665728" TEXT="meaning vehicle if he&apos;s in one"/>
</node>
<node CREATED="1411251461737" ID="ID_82184398" MODIFIED="1417552794825" TEXT="killer_weapon">
<node CREATED="1411250603175" ID="ID_663337398" MODIFIED="1411251475887" TEXT="If by shot, a valid entry in cfgweapons (given the correct mods)"/>
<node CREATED="1411250828883" ID="ID_1013774991" MODIFIED="1411250838858" TEXT="If by explosive, the cfgMagazines name">
<node CREATED="1411788678255" ID="ID_103266820" MODIFIED="1411788687406" TEXT="grenade instead of throw"/>
<node CREATED="1411251486767" ID="ID_335448416" MODIFIED="1411251582007" TEXT="Scripted explosives may use slightly different names"/>
</node>
<node CREATED="1411251337221" ID="ID_1936115207" MODIFIED="1411251344541" TEXT="Else, it should remain empty"/>
</node>
<node CREATED="1411249807394" ID="ID_1510884345" MODIFIED="1417552494750" TEXT="istk (&quot;is teamkill&quot;) must be one of">
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
<node CREATED="1411250285269" ID="ID_641735279" MODIFIED="1413862853723" TEXT="Will be blocked at db input">
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
<node CREATED="1417430422108" ID="ID_971450032" MODIFIED="1417430427789" TEXT="getin1">
<node CREATED="1417555691430" ID="ID_66626019" MODIFIED="1417555989704" TEXT="getin1(sessionid integer, &quot;when&quot; numeric, playeruid text, slot text, vehicleposition text, vehicleclass text, vehicleid text)"/>
<node CREATED="1417556490316" ID="ID_236132583" MODIFIED="1417556502297" TEXT="If a person switches position, send an extra getin1"/>
<node CREATED="1417556634948" ID="ID_1953753175" MODIFIED="1417556663900" TEXT="Slot says where in the vehicle the player is"/>
</node>
<node CREATED="1417430428295" ID="ID_180546225" MODIFIED="1417430432876" TEXT="getout1">
<node CREATED="1417555839279" ID="ID_1349950934" MODIFIED="1417556020483" TEXT="getout1(sessionid integer, &quot;when&quot; numeric, playeruid text, slot text, vehicleposition text, vehicleclass text, vehicleid text)"/>
</node>
</node>
<node CREATED="1411246519253" ID="ID_107950699" MODIFIED="1417453995610" POSITION="right" TEXT="Session/Player accounting">
<node CREATED="1411246590491" ID="ID_290973949" MODIFIED="1411246592801" TEXT="New session">
<node CREATED="1415040818948" ID="ID_531729661" MODIFIED="1417426351863" TEXT="server.newsession1(oldsession integer, mission_name text, map_name text, scriptversion text, duplidetect text)"/>
<node CREATED="1415040862257" ID="ID_1657939095" MODIFIED="1415040876584" TEXT="missionname and worldname commands"/>
<node CREATED="1415040877649" ID="ID_567283832" MODIFIED="1415040926905" TEXT="Duplidetect should be fairly unique - and will be used to detect if maybe a dump has already been imported."/>
<node CREATED="1417546383283" ID="ID_1126314459" MODIFIED="1417553026249" TEXT="Scriptversion should reflect what script does the stats, and its version"/>
<node CREATED="1415040821404" ID="ID_1995566041" MODIFIED="1417427233252" TEXT="newsession1;Splendid_testing;Altis;MyStats 1.1;1554329">
<font BOLD="true" NAME="Arial" SIZE="12"/>
</node>
</node>
<node CREATED="1411246572031" ID="ID_1508408840" MODIFIED="1411249590221" TEXT="Player joined">
<node CREATED="1411246694432" ID="ID_610564600" MODIFIED="1417553345701" TEXT="playerjoin1(sessionid integer, jointime numeric, playeruid text, playerside text, VARIADIC playername_p text[])"/>
<node CREATED="1411246799799" ID="ID_1153877399" MODIFIED="1411246891942" TEXT="playerside is assumed to be constant until leaving">
<icon BUILTIN="messagebox_warning"/>
<node CREATED="1411253083019" ID="ID_88266992" MODIFIED="1417553544048" TEXT="For side balancing and similar, issue a leave and join pair."/>
</node>
<node CREATED="1411246900631" ID="ID_1987653379" MODIFIED="1417553400172" TEXT="playername_p shall be passed as a plain unquoted string of the players name. ">
<node CREATED="1411247806602" ID="ID_1570962258" MODIFIED="1411247819561" TEXT="A name containing a ; will work correctly."/>
</node>
<node CREATED="1411247127960" ID="ID_357791315" MODIFIED="1417553358843" TEXT="playerjoin1;0;76561197970503377;WEST;Vlad">
<font BOLD="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1411246575541" ID="ID_1780633635" MODIFIED="1417430560411" TEXT="Player left">
<node CREATED="1417430562327" ID="ID_1368950879" MODIFIED="1417553324620" TEXT="playerleave1(sessionid integer, when numeric, playeruid text)"/>
</node>
<node CREATED="1411788484749" ID="ID_1436157511" MODIFIED="1411788489393" TEXT="Mission Events">
<node CREATED="1411788491892" ID="ID_1940404401" MODIFIED="1411788497277" TEXT="Stuff like zone captures etc"/>
<node CREATED="1417553419059" ID="ID_1660371594" MODIFIED="1417553447931" TEXT="The mission specifies what qualifies as an event"/>
<node CREATED="1411788499196" ID="ID_645774660" MODIFIED="1411788517271" TEXT="missionevent1(sessionid integer, &quot;when&quot; numeric, what text, VARIADIC playerlist text[])"/>
<node CREATED="1411788518075" ID="ID_1690524188" MODIFIED="1411788536326" TEXT="What MUST NOT contain any ; semicolons "/>
<node CREATED="1411788545149" ID="ID_212476609" MODIFIED="1411788637827" TEXT="playerlist should be the players involved in this">
<node CREATED="1411788570517" ID="ID_933994725" MODIFIED="1417427461914" TEXT="exactly what &quot;involved&quot; means is up to the mission maker"/>
<node CREATED="1417427475116" ID="ID_1597993762" MODIFIED="1417427500340" TEXT="a sequence of player UIDs separated by ;"/>
</node>
</node>
<node CREATED="1411246593790" ID="ID_1287542351" MODIFIED="1411253152195" TEXT="End of session">
<node CREATED="1411246599431" ID="ID_1716485836" MODIFIED="1411257478568" TEXT="Depends on mission; stats system cannot handle this purely on its own"/>
<node CREATED="1411257448674" ID="ID_399214735" MODIFIED="1411257449549" TEXT="endsession1(sessionid integer, duration numeric, outcome text)"/>
</node>
</node>
<node CREATED="1411246526682" ID="ID_1157462138" MODIFIED="1417554019179" POSITION="right" TEXT="Kill/Death registration">
<node CREATED="1411249601144" ID="ID_627582656" MODIFIED="1417554264505" TEXT="Killed by shot">
<node CREATED="1411249173058" ID="ID_1214812846" LINK="#ID_973020385" MODIFIED="1411251635776" TEXT="infkilled1"/>
<node CREATED="1411257557771" ID="ID_1943215810" MODIFIED="1411257595555" TEXT="It may be possible to get hit by your own ricochet">
<node CREATED="1411257576952" ID="ID_1293675892" LINK="#ID_782296840" MODIFIED="1411257586068" TEXT="suicide1"/>
</node>
<node CREATED="1411265994273" ID="ID_573944941" MODIFIED="1411788958958" TEXT="kill/teamkill"/>
<node CREATED="1411266005084" ID="ID_985018267" MODIFIED="1411266017556" TEXT="by infantry/vehicle"/>
<node CREATED="1413862435467" ID="ID_1885334961" MODIFIED="1413862442517" TEXT="Killed by UAV/UGV">
<node CREATED="1413862445520" ID="ID_1516082374" MODIFIED="1413862524950" TEXT="killer uid, side,  should be that of controller">
<node CREATED="1413862593753" ID="ID_1643468915" MODIFIED="1413862597492" TEXT="AI if uncontrolled"/>
</node>
<node CREATED="1413862466867" ID="ID_1917238011" MODIFIED="1413862560491" TEXT="killer position, class, (weapon) should be that of the uav"/>
</node>
<node CREATED="1411420801532" ID="ID_119882297" MODIFIED="1411420813893" TEXT="Should register for the correct gunner in a multigunner vehicle">
<node CREATED="1411420815194" ID="ID_662243782" MODIFIED="1411420822866" TEXT="Tank gunner and commander"/>
<node CREATED="1411420823339" ID="ID_674614468" MODIFIED="1411420831827" TEXT="Helicopter with door guns on each side"/>
</node>
</node>
<node CREATED="1411188897898" ID="ID_1445224943" MODIFIED="1417554266151" TEXT="Killed by a bomb (vanilla)">
<node CREATED="1411249173058" ID="ID_1901952982" LINK="#ID_973020385" MODIFIED="1411251633626" TEXT="infkilled1"/>
<node CREATED="1411242849615" ID="ID_824827446" LINK="#ID_782296840" MODIFIED="1411253341827" TEXT="suicide1"/>
<node CREATED="1411243210127" ID="ID_1236087480" MODIFIED="1417554528263" TEXT="Grenades"/>
<node CREATED="1417554528532" ID="ID_1422602641" MODIFIED="1417554530720" TEXT="Artillery"/>
</node>
<node CREATED="1411188994871" ID="ID_1276141249" MODIFIED="1417554278324" TEXT="Killed by a bomb (scripted)">
<node CREATED="1411249173058" ID="ID_476686163" LINK="#ID_973020385" MODIFIED="1411251633626" TEXT="infkilled1"/>
<node CREATED="1411242849615" ID="ID_168075294" LINK="#ID_782296840" MODIFIED="1411253341827" TEXT="suicide1"/>
<node CREATED="1411189011491" ID="ID_475136480" MODIFIED="1411189025242" TEXT="Requires support from the script"/>
<node CREATED="1411242849615" ID="ID_1067097159" MODIFIED="1411242859632" TEXT="Suicide if you did it yourself"/>
<node CREATED="1417554558970" ID="ID_123824757" MODIFIED="1417554640680" TEXT="If done by scripted artillery, consider it killed by ai (i.e. blank )"/>
</node>
<node CREATED="1411079817699" ID="ID_1266935527" MODIFIED="1411789213307" TEXT="Traffic &quot;accident&quot;">
<node CREATED="1411788381717" ID="ID_50082741" MODIFIED="1411788410961" TEXT="Applies when a unit drives a vehicle, colliding with a unit such that it is killed"/>
<node CREATED="1411788419647" ID="ID_1511026558" MODIFIED="1411788926270" TEXT="If a vehicle was never occupied, it should instead call died1">
<node CREATED="1411788802454" ID="ID_1334552351" MODIFIED="1411788869424" TEXT="E.g. it spawned on top of you"/>
</node>
<node CREATED="1411256859476" ID="ID_1039798979" MODIFIED="1411788729081" TEXT="roadkill1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text, killer_uid text, killer_position text, killer_class text, killer_side text, killer_vehicle text, istk text) "/>
<node CREATED="1411788730736" ID="ID_641439708" MODIFIED="1411788756672" TEXT="Same parameter layout as inf_killed1 except weapon turns into killer_vehicle"/>
</node>
<node CREATED="1411189056930" ID="ID_968515743" MODIFIED="1417554313138" TEXT="Player dies long after injury">
<node CREATED="1411189165221" ID="ID_599775576" MODIFIED="1411420848413" TEXT="Appropriate message needs to be sent"/>
<node CREATED="1417554367114" ID="ID_1989211455" MODIFIED="1417554729153" TEXT="If he was shot, the data of the shooter at the time of the shot needs to be retained"/>
<node CREATED="1411189076061" ID="ID_831501880" MODIFIED="1411189110778" TEXT="Bleeding out, revival script timeout, etc"/>
</node>
<node CREATED="1411243011214" ID="ID_341649347" MODIFIED="1411789287176" TEXT="Death by falling">
<node CREATED="1411254005448" ID="ID_10833575" MODIFIED="1411254009706" TEXT="suicide1"/>
<node CREATED="1411789101407" ID="ID_1501483264" MODIFIED="1417554418406" TEXT="If the &quot;fall&quot; results from being bumped by a vehicle, it is a roadkill/traffic accident">
<icon BUILTIN="help"/>
</node>
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
<node CREATED="1410980086928" ID="ID_1948730664" MODIFIED="1417554436033" TEXT="Aircraft Crashes">
<node CREATED="1411257407564" ID="ID_1272228758" MODIFIED="1411257408299" TEXT="accrash1(sessionid integer, &quot;when&quot; numeric, playerid text, playerpos text, passengercount integer, vehiclename text, vehiclepos text)"/>
<node CREATED="1417554466133" ID="ID_151251054" MODIFIED="1417554487476" TEXT="May want to change to a list of passengers">
<icon BUILTIN="hourglass"/>
</node>
</node>
<node CREATED="1410980083475" ID="ID_1067078033" MODIFIED="1411243077757" TEXT="Scripted deaths">
<node CREATED="1411254265337" ID="ID_99590567" MODIFIED="1411788930510" TEXT="died1"/>
</node>
<node CREATED="1411243237545" ID="ID_1045419302" MODIFIED="1411789317070" TEXT="Drowning">
<node CREATED="1411256892075" ID="ID_1590035241" MODIFIED="1411256893080" TEXT="drowned1(sessionid integer, &quot;when&quot; numeric, victim_uid text, victim_position text, victim_class text, victim_side text)"/>
</node>
<node CREATED="1411081180736" ID="ID_1613880427" MODIFIED="1417555508199" TEXT="Vehicle kills">
<node CREATED="1411267893876" ID="ID_1062147332" MODIFIED="1417556568818" TEXT="server.veh_killed1(sessionid integer, &quot;when&quot; numeric, severity text, vehicleclass text, vehicleid text, vehicle_position text,  last_used_by_side text, last_used_by_player text, killer_uid text, killer_position text,  killer_class text, killer_weapon text, killer_side text )"/>
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
<node CREATED="1411243979107" ID="ID_1176768800" MODIFIED="1411789564817" TEXT="Damage but not kill of friendly">
<icon BUILTIN="pencil"/>
<node CREATED="1411255709951" ID="ID_476874666" MODIFIED="1411255764245" TEXT="Griefer detector"/>
<node CREATED="1411257832110" ID="ID_1533171003" MODIFIED="1411257857884" TEXT="friendlydmg1(...) "/>
</node>
</node>
<node CREATED="1411243301478" ID="ID_288797497" MODIFIED="1417454046031" POSITION="right" TEXT="Unit Vehicle Weapon statistics">
<node CREATED="1411255157468" ID="ID_1701642190" MODIFIED="1411255175444" TEXT="Send updates periodically"/>
<node CREATED="1411243625603" ID="ID_104631808" MODIFIED="1411243711202" TEXT="One message for each uvw combo whose counts have changed"/>
<node CREATED="1413852534333" ID="ID_1825469394" MODIFIED="1414337053000" TEXT="server.uvwstats1 (IN sessionid integer, IN &quot;when&quot; numeric, IN playerid text, &#xa;IN unitclass text, IN vehicleclass text, IN weaponclass text, &#xa;IN weapontime numeric, IN shotsfired integer, VARIADIC hits text[])"/>
<node CREATED="1412015215559" ID="ID_901584314" MODIFIED="1412015280112" TEXT="hits should have the format  class:selection">
<node CREATED="1412015256275" ID="ID_1047285598" MODIFIED="1412015262013" TEXT="Note colon rather than semicolon"/>
<node CREATED="1417454014958" ID="ID_85628452" MODIFIED="1417454032698" TEXT="Then semicolon and the next hit done in that time"/>
</node>
<node CREATED="1417454059714" ID="ID_1610916892" MODIFIED="1417454073930" TEXT="TODO: class:selection:count">
<node CREATED="1417454138522" ID="ID_1255301048" MODIFIED="1417454169333" TEXT="Accept json?"/>
</node>
</node>
<node CREATED="1411243542252" ID="ID_737534664" MODIFIED="1417864938887" POSITION="right" TEXT="Transportation">
<icon BUILTIN="pencil"/>
<node CREATED="1417557912365" ID="ID_1489265990" MODIFIED="1417557939514" TEXT="I introduced vehicle IDs especially for this feature.">
<font ITALIC="true" NAME="Arial" SIZE="12"/>
</node>
<node CREATED="1417557989131" ID="ID_1483375683" MODIFIED="1417557997994" TEXT="getin1 getout1"/>
<node CREATED="1417558003274" ID="ID_336024760" MODIFIED="1417558027250" TEXT="Using vehicle IDs we can correlate who was where in that particular vehicle at any given time."/>
<node CREATED="1417558072807" ID="ID_539542054" MODIFIED="1417558076097" TEXT="Not yet covered:">
<node CREATED="1417558047371" ID="ID_635918074" MODIFIED="1417558081154" TEXT="Cargo transport"/>
<node CREATED="1411255664267" ID="ID_215043465" MODIFIED="1411255671402" TEXT="Distance from destination (if applicable)">
<node CREATED="1417558089376" ID="ID_904173691" MODIFIED="1417558101378" TEXT="Did the pilot land at the designated LZ?"/>
</node>
</node>
<node CREATED="1411244174929" ID="ID_668636325" MODIFIED="1411244279078" TEXT="ATLAS: Ties into giving points for vehicle crew, pilots">
<font ITALIC="true" NAME="SansSerif" SIZE="12"/>
</node>
</node>
<node CREATED="1411244819430" ID="ID_1457276037" MODIFIED="1415042228052" POSITION="right" TEXT="Randomly report positions">
<node CREATED="1415041776195" ID="ID_530867136" MODIFIED="1415042196584" TEXT="server.playerpos(sessionid int, when numeric, playeruid text, position text, vehicle text, status text"/>
<node CREATED="1415041838721" ID="ID_228537817" MODIFIED="1415041892299" TEXT="status is optional">
<node CREATED="1415041892300" ID="ID_1111924602" MODIFIED="1415041907404" TEXT="Integration with medical system -&gt; unconscious?"/>
<node CREATED="1415041907998" ID="ID_410780591" MODIFIED="1415041912009" TEXT="Dead, waiting for respawn?"/>
</node>
<node CREATED="1415041546923" ID="ID_1115444975" MODIFIED="1415041753853" TEXT="After sending one message, wait for 90 to 300 seconds before sending another message for that player."/>
<node CREATED="1415042079215" ID="ID_1932459428" MODIFIED="1415042107639" TEXT="Optionally, 90 seconds could be changed to numplayers/90 ONLY WHEN &gt;90 players."/>
<node CREATED="1415042143564" ID="ID_1201145061" MODIFIED="1415042289648" TEXT="A mission designer will be interested in a heatmap for where players are spending their time."/>
</node>
<node CREATED="1411244916068" ID="ID_464897636" MODIFIED="1417896323719" POSITION="right" TEXT="Shot reports">
<icon BUILTIN="pencil"/>
<node CREATED="1411244921154" ID="ID_1879609824" MODIFIED="1411244938645" TEXT="Report from where and what direction a player shoots"/>
<node CREATED="1411244941078" ID="ID_1337826126" MODIFIED="1411244967657" TEXT="Do not send further reports for 30 seconds after previous message"/>
</node>
<node CREATED="1415042504868" ID="ID_577364655" MODIFIED="1417896322517" POSITION="right" TEXT="Item names loading">
<icon BUILTIN="pencil"/>
<node CREATED="1415042528454" ID="ID_633310394" MODIFIED="1415042568303" TEXT="Special mission that exists only to read the game&apos;s config and upload to the db"/>
<node CREATED="1415042571990" ID="ID_1364621973" MODIFIED="1415042599574" TEXT="No code for this should be in the regular mission runtime"/>
<node CREATED="1415042614572" ID="ID_1077173574" MODIFIED="1415042634598" TEXT="DB access to doing this will be restricted to members of db role &quot;armalive_admin&quot;"/>
<node CREATED="1415042648107" ID="ID_1421315635" MODIFIED="1415042685479" TEXT="Will be used to provide &quot;friendly names&quot; for weapons, rather than displaying classnames on the webpages"/>
</node>
<node CREATED="1411245441833" ID="ID_1051322261" MODIFIED="1417864806677" POSITION="right" TEXT="Plugins">
<node CREATED="1411245482148" ID="ID_419922949" MODIFIED="1417864832438" TEXT="The following functions need to be provided by the script"/>
<node CREATED="1417864833223" ID="ID_652090765" MODIFIED="1417864853530" TEXT="&quot;message&quot; call armalive_send"/>
<node CREATED="1417864854845" ID="ID_471239876" MODIFIED="1417864893616" TEXT="string = object call armalive_vehicleid"/>
</node>
</node>
</map>
