@tool
extends EditorPlugin

const AUTOLOAD_NAME = "BuildingAutoload"
const MainPanel = preload("res://addons/building_plugin/scenes/main_panel.tscn")

var main_panel_instance
#var dock

func _enter_tree():
	# Initialization of the plugin goes here.
	if not EditorInterface.is_plugin_enabled("inventory_base"):
		push_error("missing dependency. please enable inventory_base plugin")
	
	main_panel_instance = MainPanel.instantiate()
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)
	
	#dock = preload("res://addons/building_plugin/scenes/building_dock.tscn").instantiate()
	#add_control_to_dock(DOCK_SLOT_LEFT_UL, dock)
	
	add_autoload_singleton(AUTOLOAD_NAME, "res://addons/building_plugin/scripts/building_autoload.gd")
	add_custom_type("BuildingManger", "Node", preload("res://addons/building_plugin/scripts/building_manager.gd"), preload("res://addons/building_plugin/icons/icon.svg"))
	add_custom_type("PlaceableObject", "Node2D", preload("res://addons/building_plugin/scripts/placeable_object.gd"), preload("res://addons/building_plugin/icons/icon.svg"))
	add_custom_type("BuildTileChecker", "Area2D", preload("res://addons/building_plugin/scripts/build_tile_checker.gd"), preload("res://addons/building_plugin/icons/icon.svg"))
	add_custom_type("PlaceableInventoryItem", "Resource", preload("res://addons/building_plugin/scripts/placeable_inventory_item.gd"), preload("res://addons/building_plugin/icons/icon.svg"))


func _exit_tree():
	# Clean-up of the plugin goes here.
	if main_panel_instance:
		main_panel_instance.queue_free()
	
	#remove_control_from_docks(dock)
	#dock.free()
	
	remove_autoload_singleton(AUTOLOAD_NAME)
	remove_custom_type("BuildingManger")
	remove_custom_type("PlaceableObject")
	remove_custom_type("BuildTileChecker")
	remove_custom_type("PlaceableInventoryItem")

func _has_main_screen():
	return true

func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible

func _get_plugin_name():
	return "Building Plugin"

func _get_plugin_icon():
	# Must return some kind of Texture for the icon.
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
