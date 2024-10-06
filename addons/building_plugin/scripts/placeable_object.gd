class_name PlaceableObject
extends Node2D

@export var sprite: Sprite2D
@export var build_collision_area: Area2D

var tile_checker_container: Node2D
@export var is_placed: bool = false

func _ready():
	build_collision_area.set_collision_layer_value(BuildingAutoload.building_collision_layer, true)
	if not is_placed:
		modulate = Color(1, 1, 1, 0.5)

func generate_tile_checkers():
	tile_checker_container = Node2D.new()
	tile_checker_container.name = "TileCheckerContainer"
	var build_collision_shape: CollisionShape2D = build_collision_area.get_child(0)
	var collision_shape_position: Vector2 = build_collision_shape.position
	var place_pos: Vector2 = Vector2.ZERO
	var tile_size = BuildingAutoload.tile_size
	var num_x_tiles: int = build_collision_shape.shape.size.x/tile_size.x
	var num_y_tiles: int = build_collision_shape.shape.size.y/tile_size.y
	var shape_start_pos: Vector2 = collision_shape_position - build_collision_shape.shape.size/2
	for y_index in num_y_tiles:
		for x_index in num_x_tiles:
			var cur_tile_offset: Vector2 = Vector2(x_index*tile_size.x, y_index*tile_size.y)
			place_pos = shape_start_pos + cur_tile_offset + Vector2(tile_size/2)
			var tile_checker: BuildTileChecker = BuildTileChecker.new(BuildingAutoload.tile_checker_texture, tile_size, place_pos)
			tile_checker_container.add_child(tile_checker)
	add_child(tile_checker_container)
	for tile_checker: BuildTileChecker in tile_checker_container.get_children():
		tile_checker.owner = self

func remove_tile_checkers():
	tile_checker_container.queue_free()

func place_object() -> Error:
	if can_place():
		is_placed = true
		modulate = Color(1, 1, 1)
		remove_tile_checkers()
		return OK
	return FAILED

func can_place() -> bool:
	if tile_checker_container == null:
		push_warning("tile_checker_container was empty when checking can_place")
		return true
	for tile_checker: BuildTileChecker in tile_checker_container.get_children():
		if not tile_checker.is_open:
			return false
	return true
