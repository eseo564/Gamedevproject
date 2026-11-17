extends Node2D

@onready var background = $Background
@onready var toilet = $Interactables/Toilet

var bg_start = preload("res://assets/backgrounds/toiletroom/toiletroom_start.png")
var bg_key_flushed = preload("res://assets/backgrounds/toiletroom/toiletroom_key_flushed.png")
var bg_key_collected = preload("res://assets/backgrounds/toiletroom/toiletroom_key_collected.png")

@onready var key_glow = $Interactables/Toilet/KeyGlow
@onready var flush_sfx = $FlushSfx

func _ready():
	toilet.input_event.connect(_on_toilet_clicked)
	
	setup_glow(key_glow)
	
	toilet.mouse_entered.connect(_on_toilet_hover_entered)
	toilet.mouse_exited.connect(_on_toilet_hover_exited)
	
	
	update_room()


func _on_toilet_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			interact_with_toilet()


func interact_with_toilet():
	if GameManager.key_acquired:
		return

	if GameManager.toilet_flushed:
		GameManager.key_acquired = true
		await Dialogue.show_text("A key!")
		Inventory.add_item("key")
		update_room()
		return

	if Inventory.selected_item == "filled_water_bucket":
		GameManager.toilet_flushed = true
		Inventory.remove_item("filled_water_bucket")
		flush_sfx.play()
		update_room()
		await Dialogue.show_text("Something got flushed out!")
		return

	if Inventory.selected_item == "stick":
		await Dialogue.show_text("Argh, I can't reach it!")
		await Dialogue.show_text("The stick is too short!")
		return

	if Inventory.selected_item != "":
		await Dialogue.wrong_item()
		return

	await Dialogue.show_text("A dirty toilet... There's no way I'm using that")
	await Dialogue.show_text("There's something shining in there...")

func setup_glow(glow):
	var outline = glow.get_node_or_null("Outline")

	if outline == null:
		push_error("Missing Outline under " + glow.name)
		return

	glow.color = Color(1.0, 1.0, 1.0, 0.0)
	glow.z_index = 10

	outline.position = Vector2.ZERO
	outline.points = glow.polygon
	outline.closed = true
	outline.width = 3.0
	outline.default_color = Color(1.0, 1.0, 1.0, 0.3)
	outline.antialiased = true
	outline.visible = true


func update_hover_glow(glow, hovered, available):
	glow.visible = hovered and available


func _on_toilet_hover_entered():
	if GameManager.toilet_flushed and not GameManager.key_acquired:
		key_glow.show()


func _on_toilet_hover_exited():
	key_glow.hide()


func update_room():
	if GameManager.key_acquired:
		background.texture = bg_key_collected

	elif GameManager.toilet_flushed:
		background.texture = bg_key_flushed

	else:
		background.texture = bg_start
		
	key_glow.hide()
