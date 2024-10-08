class_name BuildingManger
extends Node

@export var object_layer: TileMapLayer
@export var tile_checker_texture: Texture2D
@export var tile_size: Vector2i
@export var UI_root: CanvasLayer
@export var object_root: Node2D
@export var build_object_scene: PackedScene
@export_range(1, 32) var building_collision_layer: int = 1

var hovered_cell: Vector2i = Vector2i(0, 0)
var build_preview: PlaceableObject

func _ready():
	BuildingAutoload.tile_size = tile_size
	BuildingAutoload.tile_checker_texture = tile_checker_texture
	BuildingAutoload.building_collision_layer = building_collision_layer
	connect_signals()
	update_build_preview_scene(build_object_scene)
	

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		update_build_preview_position()
	elif event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_LEFT:
				attempt_build()

func connect_signals():
	InventoryAutoload.hand_slot_changed.connect(_on_hand_slot_changed.bind())

func attempt_build():
	if build_preview == null:
		return
	var err: Error = build_preview.place_object()
	if err == OK:
		place_build()
		print("Build Success!")
		#update_build_preview_scene(build_object_scene)
	else:
		print("Build Failed.")

func place_build():
	build_preview = null
	var hand_slot: HandSlot = InventoryAutoload.hand_slot
	var hand_slot_data: InventorySlotData = hand_slot.data
	hand_slot_data.amount -= 1
	if hand_slot_data.amount <= 0:
		hand_slot_data = null
	hand_slot.data = hand_slot_data
	InventoryAutoload.hand_slot = hand_slot

func update_build_preview_scene(new_build_scene: PackedScene):
	#print("update build scene: ", new_build_scene)
	build_object_scene = new_build_scene
	if build_preview != null:
			object_root.remove_child(build_preview)
			build_preview = null
	if new_build_scene == null:
		return
	build_preview = new_build_scene.instantiate()
	object_root.add_child(build_preview)
	build_preview.generate_tile_checkers()
	if build_preview != null:
		set_build_preview_position(find_hovered_cell(object_layer))

func update_build_preview_position():
	var new_hovered_cell = find_hovered_cell(object_layer)
	if new_hovered_cell == hovered_cell:
		return
	hovered_cell = new_hovered_cell
	set_build_preview_position(hovered_cell)

func set_build_preview_position(cell_position: Vector2i):
	if build_preview != null:
		build_preview.position = Vector2i(object_layer.map_to_local(cell_position)) - tile_size/2

func find_hovered_cell(tile_layer: TileMapLayer) -> Vector2i:
	#var new_hovered_cell = object_layer.local_to_map(object_layer.get_local_mouse_position())
	return tile_layer.local_to_map(tile_layer.get_global_mouse_position())

func _on_hand_slot_changed(hand_slot: HandSlot):
	if hand_slot.data == null:
		update_build_preview_scene(null)
		return
	if hand_slot.data.item is PlaceableInventoryItem:
		update_build_preview_scene(hand_slot.data.item.placeable_object_scene)
	else:
		update_build_preview_scene(null)
