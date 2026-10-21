extends Node2D

@onready var safe = $Interactables/Safe
@onready var wall_code = $Interactables/WallCode
@onready var bucket = $Interactables/Bucket
@onready var rat_hole = $Interactables/RatHole


func _ready():
	safe.input_event.connect(_on_safe_clicked)
	wall_code.input_event.connect(_on_wall_code_clicked)
	bucket.input_event.connect(_on_bucket_clicked)
	rat_hole.input_event.connect(_on_rat_hole_clicked)


func _on_safe_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_safe()


func _on_wall_code_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_wall_code()


func _on_bucket_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_bucket()


func _on_rat_hole_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_rat_hole()


func interact_with_safe():
	print("The safe is locked.")


func interact_with_wall_code():
	print("There's something written on the wall.")


func interact_with_bucket():
	print("It's an empty bucket.")


func interact_with_rat_hole():
	print("There's a hole in the wall.")
