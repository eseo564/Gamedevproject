extends Node2D

@onready var door = $Interactables/Door
@onready var toolbox = $Interactables/Toolbox
@onready var sewer = $Interactables/Sewer


func _ready():
	door.input_event.connect(_on_door_clicked)
	toolbox.input_event.connect(_on_toolbox_clicked)
	sewer.input_event.connect(_on_sewer_clicked)


func _on_door_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_door()


func _on_toolbox_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_toolbox()


func _on_sewer_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_sewer()


func interact_with_door():
	print("I don't want to go up there.")


func interact_with_toolbox():
	if Inventory.has_item("padlock"):
		Inventory.remove_item("padlock")
		GameManager.toolbox_has_padlock = true
		print("There I fixed it, but I have no idea what the code is")
	else:
		print("The toolbox is missing a padlock.")


func interact_with_sewer():
	print("Weird, a basement with a manhole.")
