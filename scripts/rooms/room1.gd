extends Node2D

@onready var bucket = $Interactables/Bucket
@onready var cheese = $Interactables/Cheese
@onready var web = $Interactables/Web
@onready var matches = $Interactables/Matches
@onready var background = $Background

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

	GameManager.bucket_acquired = true
	Inventory.add_item("bucket")

	update_room()


func interact_with_cheese():
	if GameManager.cheese_acquired:
		return

	if Inventory.selected_item == "stick":
		GameManager.cheese_acquired = true

		Inventory.remove_item("stick")
		Inventory.add_item("cheese")

		update_room()
		return


func interact_with_web():
	if GameManager.web_burned:
		if not GameManager.stick_acquired:
			GameManager.stick_acquired = true
			Inventory.add_item("stick")


			update_room()

		return


	if Inventory.selected_item == "matches":
		GameManager.web_burned = true

		Inventory.remove_item("matches")
		Inventory.clear_selection()

		update_room()
		return


func interact_with_matches():
	if GameManager.matches_acquired:
		return

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
