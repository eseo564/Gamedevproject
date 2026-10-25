extends Node

signal inventory_changed
signal selection_changed

var items = []
var selected_item = ""


func add_item(item):
	if item not in items:
		items.append(item)
		inventory_changed.emit()


func remove_item(item):
	if item in items:
		items.erase(item)

	if selected_item == item:
		selected_item = ""
		selection_changed.emit()

	inventory_changed.emit()


func has_item(item):
	return item in items


func select_item(item):
	if item in items:
		selected_item = item
		selection_changed.emit()


func clear_selection():
	selected_item = ""
	selection_changed.emit()


func is_selected(item):
	return selected_item == item
