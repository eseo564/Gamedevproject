extends Control


var item_textures = {
	"bucket": preload("res://assets/items/bucket.png"),
	"filled_water_bucket": preload("res://assets/items/cheese.png"),
	"matches": preload("res://assets/items/crowbar.png"),
	"stick": preload("res://assets/items/key.png"),
	"cheese": preload("res://assets/items/match.png"),
	"padlock_dial": preload("res://assets/items/padlockdial.png"),
	"key": preload("res://assets/items/stick.png"),
	"uv_light": preload("res://assets/items/UV_light.png"),
	"crowbar": preload("res://assets/items/water_bucket.png")
}


func _ready():
	Inventory.inventory_changed.connect(update_inventory)
	Inventory.selection_changed.connect(update_inventory)

	for slot in get_children():
		slot.gui_input.connect(_on_slot_input.bind(slot))

	update_inventory()


func update_inventory():
	var slots = get_children()

	for slot in slots:
		var icon = slot.get_node("Icon")
		var selection = slot.get_node("Selection")

		icon.texture = null
		selection.hide()

	for i in range(min(Inventory.items.size(), slots.size())):
		var item_name = Inventory.items[i]
		var slot = slots[i]
		var icon = slot.get_node("Icon")
		var selection = slot.get_node("Selection")

		if item_textures.has(item_name):
			icon.texture = item_textures[item_name]

		if Inventory.is_selected(item_name):
			selection.show()

func _on_slot_input(event, slot):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var slot_index = slot.get_index()

			if slot_index < Inventory.items.size():
				var item = Inventory.items[slot_index]

				if Inventory.is_selected(item):
					Inventory.clear_selection()
				else:
					Inventory.select_item(item)
