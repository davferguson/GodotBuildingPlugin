class_name BuildTileChecker
extends Area2D

var texture: Texture2D
var size: Vector2
var sprite: Sprite2D
var is_open: bool = true

func _init(p_texture: Texture2D, p_size: Vector2, p_position: Vector2):
	texture = p_texture
	size = p_size - Vector2.ONE
	z_index = 1
	var collision_shape: CollisionShape2D = CollisionShape2D.new()
	var rectangle_shape: RectangleShape2D = RectangleShape2D.new()
	rectangle_shape.size = size
	collision_shape.shape = rectangle_shape
	add_child(collision_shape)
	sprite = Sprite2D.new()
	sprite.texture = texture
	add_child(sprite)
	position = p_position
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	set_collision_mask_value(BuildingAutoload.building_collision_layer, true)

func _ready():
	area_shape_entered.connect(_on_area_shape_entered.bind())
	area_shape_exited.connect(_on_area_shape_exited.bind())
	body_shape_entered.connect(_on_body_shape_entered.bind())
	body_shape_exited.connect(_on_body_shape_exited.bind())


func _on_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int):
	await get_tree().process_frame
	var other_shape_owner = area.shape_find_owner(area_shape_index)
	var other_shape_node = area.shape_owner_get_owner(other_shape_owner)
	#print("other shape owner: ", other_shape_node.owner)
	if other_shape_node.owner == owner:
		return
	is_open = false
	sprite.self_modulate = Color(0.94, 0, 0)
	#print("area entered: ", area)

func _on_area_shape_exited(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int):
	is_open = true
	sprite.self_modulate = Color(1, 1, 1)
	#print("area shape exited")

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int):
	await get_tree().process_frame
	is_open = false
	sprite.self_modulate = Color(0.94, 0, 0)
	#print("body shape entered: ", body)

func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int):
	is_open = true
	sprite.self_modulate = Color(1, 1, 1)
	#print("body shape exited")
