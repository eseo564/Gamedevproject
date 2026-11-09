extends Node2D

@onready var bucket = $Interactables/Bucket
@onready var cheese = $Interactables/Cheese
@onready var web = $Interactables/Web
@onready var matches = $Interactables/Matches
@onready var background = $Background 

# setting spider jumpscare
@onready var spider = $Spider
var spider_final_scale = Vector2.ONE
var spider_start_pos = Vector2.ZERO

var bg_start = preload("res://assets/backgrounds/room1/room1_start.png")
var bg_bucket = preload("res://assets/backgrounds/room1/room1_bucket_collected.png")
var bg_matches = preload("res://assets/backgrounds/room1/room1_matches_collected.png")
var bg_matches_bucket = preload("res://assets/backgrounds/room1/room1_matches_bucket_collected.png")
var bg_cheese = preload("res://assets/backgrounds/room1/room1_cheese_collected.png")
var bg_cheese_bucket_not = preload("res://assets/backgrounds/room1/room1_cheese_collected_bucket_not.png")
var bg_web_burnt = preload("res://assets/backgrounds/room1/room1_web_burnt.png")
var bg_web_burnt_bucket_not = preload("res://assets/backgrounds/room1/room1_web_burnt_bucket_not_collected.png")
var bg_stick = preload("res://assets/backgrounds/room1/room1_stick_collected.png")
var bg_bucket_not_stick_not = preload("res://assets/backgrounds/room1/room1_bucket_not_collected_stick_not_collected.png")

func _ready():
	bucket.input_event.connect(_on_bucket_clicked)
	cheese.input_event.connect(_on_cheese_clicked)
	web.input_event.connect(_on_web_clicked)
	matches.input_event.connect(_on_matches_clicked) 
	# setting spider jumpscare
	spider_final_scale = spider.scale
	spider_start_pos = spider.position

	update_room()


func _on_bucket_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_bucket()


func _on_cheese_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_cheese()


func _on_web_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_web()


func _on_matches_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_matches()


func interact_with_bucket():
	if GameManager.bucket_acquired:
		return 
		
	await Dialogue.show_text("A bucket")
	await Dialogue.show_text("Maybe I can use this for something")
	GameManager.bucket_acquired = true
	Inventory.add_item("bucket")

	update_room()


func interact_with_cheese():
	if GameManager.cheese_acquired:
		return

	if Inventory.selected_item == "stick":
		GameManager.cheese_acquired = true
		await Dialogue.show_text("Now I can safely get the cheese!")
		Inventory.remove_item("stick")
		Inventory.add_item("cheese")

		update_room()
		return

	GameManager.cheese_clicks += 1

	if GameManager.cheese_clicks == 1:
		await Dialogue.show_text("Weird way to set a mouse trap")
		await Dialogue.show_text("And the cheese is molded...")
		await Dialogue.show_text("Gross.")
	else:
		await Dialogue.show_text("I wouldn't want that to snap my fingers")
		await Dialogue.show_text("There has to be another way around this")


func interact_with_web():
	if GameManager.web_burned:
		if not GameManager.stick_acquired:
			GameManager.stick_acquired = true
			await Dialogue.show_text("A stick!")
			Inventory.add_item("stick")
			update_room()
		return

	if Inventory.selected_item == "matches":
		await Dialogue.show_text("Begone Spiders!")
		await Dialogue.show_text("Burn in the treacherous pits of hell!")
		GameManager.web_burned = true
		Inventory.remove_item("matches")
		Inventory.clear_selection()
		update_room()
		return

	GameManager.web_clicks += 1

	if GameManager.web_clicks == 1:
		await Dialogue.show_text("I hate spiders")
		await Dialogue.show_text("But there's something behind that web")
	elif GameManager.web_clicks == 2:
		play_spider_jumpscare()
		await Dialogue.show_text("Ah!")
		spider_slide_away()
		await Dialogue.show_text("Shoo! shoo!")
		await Dialogue.show_text("There has to be some other way to remove that spider web")
	else:
		await Dialogue.show_text("I'm not touching that")
		await Dialogue.show_text("There has to be another way")

func play_spider_jumpscare():
	spider.position = spider_start_pos
	spider.scale = Vector2(0.05, 0.05)
	spider.show()
	var tween = create_tween()
	tween.tween_property(spider, "scale", spider_final_scale, 0.15).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	await tween.finished


func spider_slide_away():
	var off_screen_x = -spider.texture.get_width() * spider_final_scale.x
	var tween = create_tween()
	tween.tween_property(spider, "position:x", off_screen_x, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	spider.hide()


func interact_with_matches():
	if GameManager.matches_acquired:
		return
		
	await Dialogue.show_text("There's a singular match in here")
	await Dialogue.show_text("Might come in use")
	GameManager.matches_acquired = true
	Inventory.add_item("matches")

	update_room()


func update_room():
	if GameManager.cheese_acquired and GameManager.bucket_acquired:
		background.texture = bg_cheese

	elif GameManager.cheese_acquired:
		background.texture = bg_cheese_bucket_not

	elif GameManager.stick_acquired and not GameManager.bucket_acquired:
		background.texture = bg_web_burnt_bucket_not

	elif GameManager.stick_acquired:
		background.texture = bg_stick

	elif GameManager.web_burned and not GameManager.bucket_acquired:
		background.texture = bg_bucket_not_stick_not

	elif GameManager.web_burned:
		background.texture = bg_web_burnt

	elif GameManager.matches_acquired and GameManager.bucket_acquired:
		background.texture = bg_matches_bucket

	elif GameManager.matches_acquired:
		background.texture = bg_matches

	elif GameManager.bucket_acquired:
		background.texture = bg_bucket

	else:
		background.texture = bg_start

	bucket.visible = not GameManager.bucket_acquired
	matches.visible = not GameManager.matches_acquired
	cheese.visible = not GameManager.cheese_acquired
	web.visible = not GameManager.stick_acquired
