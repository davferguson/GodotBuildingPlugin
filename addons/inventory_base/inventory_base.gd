@tool
extends EditorPlugin

const AUTOLOAD_NAME = "InventoryAutoload"

func _enter_tree():
	# Initialization of the plugin goes here.
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/inventory_base/scripts/inventory_autoload.gd")
	
	add_custom_type("Inventory", "Resource", preload("res://addons/inventory_base/scripts/inventory.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventoryItem", "Resource", preload("res://addons/inventory_base/scripts/inventory_item.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventoryContainer", "Control", preload("res://addons/inventory_base/scripts/inventory_container.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventorySlot", "Control", preload("res://addons/inventory_base/scripts/inventory_slot.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventorySlotData", "Resource", preload("res://addons/inventory_base/scripts/inventory_slot_data.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("HandSlot", "Control", preload("res://addons/inventory_base/scripts/hand_slot.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventoryManager", "Control", preload("res://addons/inventory_base/scripts/inventory_manager.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("InventoryComponent2D", "Node", preload("res://addons/inventory_base/scripts/inventory_component.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	add_custom_type("Hotbar", "Control", preload("res://addons/inventory_base/scripts/hotbar.gd"), preload("res://addons/inventory_base/icons/inventory_icon.svg"))
	
	add_custom_inputs()


func _exit_tree():
	# Clean-up of the plugin goes here.
	remove_autoload_singleton(AUTOLOAD_NAME)
	
	remove_custom_type("Inventory")
	remove_custom_type("InventoryItem")
	remove_custom_type("InventoryContainer")
	remove_custom_type("InventorySlot")
	remove_custom_type("InventorySlotData")
	remove_custom_type("HandSlot")
	remove_custom_type("InventoryManager")
	remove_custom_type("InventoryComponent2D")
	remove_custom_type("Hotbar")
	
	remove_custom_inputs()


func add_custom_inputs():
	var input_event = InputEventMouseButton.new()
	input_event.shift_pressed = true
	input_event.button_index = MOUSE_BUTTON_LEFT
	var input = {
		"deadzone": 0.5,
		"events": [input_event]
	}
	ProjectSettings.set_setting('input/shift_click', input)
	ProjectSettings.save()

func remove_custom_inputs():
	ProjectSettings.set_setting('input/shift_click', null)
	ProjectSettings.save()
