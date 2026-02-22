extends Control

@export var code_node: Control
@onready var player: RigidBody3D = %Player
@export var sus_per_second: float = 5.0
var UI_element: Control

var text1: RichTextLabel
var text2: RichTextLabel
var is_player_inside: bool = false


var first_run = true

func _ready():
	UI_element = %TakeKey
	text1 = $MarginContainer/MarginContainer/AspectRatioContainer/MarginContainer/HBoxContainer/Text1
	text2 = $MarginContainer/MarginContainer/AspectRatioContainer/MarginContainer/HBoxContainer/Text2
	var code = randi_range(100000, 999999)
	code_node.code = code
	var digits = str(code)
	
	var my_text1 = """Ulice čpěly spáleným syntetem. Déšť stékal po {0}{1}{2}. chromovaných kostech mrakodrapů, rozmazávaje neonové odlesky na špinavém asfaltu. Já, detektiv Karel "Káča" Veselý, seděl v díře ve zdi, co se vydává za byt, a žužlal umělý špek. Chuť umělé slaniny byla mdlá, ale alespoň zahnala hlad. Klientka, paní Kolářová, elegantní kyborg s očima barvy zrezivělé mosazi, mi před chvílí svěřila případ. Chladný úsměv. Kalkulace, ne emoce.
\"Můj holub, pan Veselý,\" řekla. Hlas jako statické šumy smíchané s ledem. \"Blackbird. Digitální kurýr. Přenáší informace. Informace, které mohou rozvrátit síť. A ty špatné {1}. ruce je chtějí.\"
Černý holub… V hlavě mi zasvítily rudé kontrolky. Kolářová byla z vyšších pater. Tam se o korupci nešeptá, obchoduje s ní. A já se v těch stínech orientoval.
\"Zmizel,\" pokračovala. \"Prostě se odpojil od sítě. Blackbird je unikát. Stealth technologie, můj tým. Schoval se i před systémem. Někdo ho vypnul, někdo, kdo znal jeho frekvenci. A měl přístup do zabezpečených sítí.\"
Realita? V tomhle městě relativní. A po dvou litrech synthpiva ještě víc. Otřel jsem si pot z čela, ruka se mírně třásla. Tohle nebyl jen ztracený dron. Tohle byl {2}. signál. Někoho se dotkli.
\"Kolik za to?\" zeptal jsem se. Slinný pocit v krku. Tlak za spánky. Potřeboval jsem ty peníze. Dva roky jsem splácel dluh za umělé ledviny, a doktor Novák byl neúprosný.
\"Deset tisíc kreditů. A pět, pokud data zůstanou v bezpečí. Není to jen o Blackbirdovi, pane Veselý. Je o tom, kdo ho chtěl umlčet. A proč. Projekt Chiméra je citlivý. Někdo nechce, aby vyšlo najevo, jak daleko jsme zašli.\" Kolářová se na mě upřeně dívala. Její oči, bez emocí, mě pronikaly. \"Byl to riskantní výzkum. A teď, když se někdo pokusil sabotovat naše výsledky, musíme zasáhnout.\""""

	var my_text2 = """Deset tisíc… nové ledviny a splacený dluh u doktora Nováka. Drsný pes, který umí najít ztracené věci. To bylo všechno. Nebyl jsem hrdina. Ale měl jsem dluh.
Vyšel jsem do ulice a aktivoval augmentovaný zrak. Město se rozostřilo do kaleidoskopu, filtrovaného mým starým {3}{4}{5} algoritmem. Hledal jsem digitální otisky. Anomálie.
Našel jsem je v opuštěném továrním komplexu, kdysi kolébce nanobotů. Mohutná hala, zrezivělé stroje, rozpadající se beton. Vzduch nasáklý pachem oleje a zapomnění. Slabý signál, jamming. Někdo Blackbirda umlčel. A věděl, jak na to. Strážili ho. Čtyři kyborgové, těžce ozbrojení, s jizvami na tvářích a prázdnotou v očích. Pracovníci dolů, zocelení těžkou prací.
Vstoupil jsem dovnitř. Tma. Zrezivělé stroje. Náhlý pohyb. Jeden z kyborgů zaútočil. Elektrošok do lýtka. Loket do čelisti. Rána do solar plexu. Rychlý pohyb, využití váhy, otočení, kop do kolena. Druhý se rozeběhl zleva. Blok, úder dlaní do brady. Třetí a čtvrtý se ke mně otočili. Boj byl rychlý, brutální. Krátké, ostré výměny úderů. Využíval jsem každý centimetr prostoru, každou slabinu.  Cítil jsem bolest, adrenalin.  Během patnácti sekund byli na zemi. Dýchal jsem zhluboka, abych potlačil adrenalin. A bolest.
V podzemním serveru jsem našel Blackbirda. Dron, černý mat, vyhořelé obvody. A datový čip, skrytý uvnitř. Ne korupce. Projekt Chiméra. Ilegální výzkum {5}. neuronálních rozhraní. Vytvoření dokonalého bojovníka. Ovládaného vzdáleně. A Kolářová v tom byla. Ale ne jako hlava. Jako sponzor. Finanční záštita pro šíleného doktora Erhardta, který projekt vedl. Erhardt byl vizionář, ale i psychopat. Chtěl vytvořit armádu dokonalých vojáků, ovládanou pouze jím. Kolářová mi lhala. Jen se snažila ochránit své jméno. Ale také své peníze.
Vrátím se k ní. Předám jí čip. A vyjednám si cenu. Ale něco mi říká, že jsem se právě zapletl do hry, kde sázky jsou mnohem vyšší, než jsem si myslel. A že přežít ji nebude snadné. Zvedl jsem se a vydal se zpět do deště. Na tváři mi pohrával vítr. Možná jsem měl zůstat v díře ve zdi. Ale já jsem už v tomhle městě příliš daleko."""
	var result_text1 = my_text1.format({
		"0": digits[0],
		"1": digits[1],
		"2": digits[2],
	})
	
	var result_text2 = my_text2.format({
		"3": digits[3],
		"4": digits[4],
		"5": digits[5],
	})
	
	text1.text = result_text1
	text2.text = result_text2

func _process(delta: float) -> void:
	if first_run:
		UI_element.visible = false
		is_player_inside = false
	if player.player_do_sus:
		player.player_sus += sus_per_second * delta

func _on_close_button_pressed() -> void:
	visible = false
	player.player_do_sus = false
	player.can_move = true


func _on_code_document_body_entered(body: Node3D) -> void:
	print("enter")
	UI_element.visible = true
	is_player_inside = true


func _on_code_document_body_exited(body: Node3D) -> void:
	UI_element.visible = false
	is_player_inside = false
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("action_button") or event.is_action_pressed("move_backward") or event.is_action_pressed("move_forward") or event.is_action_pressed("move_left") or event.is_action_pressed("move_right") or event.is_action_pressed("space"):
		first_run = false
	if is_player_inside:
		if event.is_action_pressed("action_button"):
			visible = !visible
			player.player_do_sus = !player.player_do_sus
			player.can_move = !player.can_move
			
