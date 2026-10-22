extends Node2D

@onready var bucket = $Interactables/Bucket
@onready var cheese = $Interactables/Cheese
@onready var web = $Interactables/Web
@onready var matches = $Interactables/Matches


func _ready():
	bucket.input_event.connect(_on_bucket_clicked)
	cheese.input_event.connect(_on_cheese_clicked)
	web.input_event.connect(_on_web_clicked)
	matches.input_event.connect(_on_matches_clicked)


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
	print("bucket")


func interact_with_cheese():
	print("cheese")


func interact_with_web():
	print("I hate spiders, but there's something behind that web.")


func interact_with_matches():
	print("matches.")
