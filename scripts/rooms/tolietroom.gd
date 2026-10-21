extends Node2D

@onready var toilet = $Interactables/Toilet

func _ready():
	toilet.input_event.connect(_on_toilet_clicked)


func _on_toilet_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			use_toilet()


func use_toilet():
	if Inventory.has_item("filled_water_bucket"):
		print("You use the filled water bucket on the toilet.")
	else:
		print("You need a filled water bucket.")
