class_name HandSlot
extends Control

@export_category("Nodes")
@export var icon_texture: TextureRect
@export var amount_label: Label

var data: InventorySlotData = null:
	set(value):
		data = value
		update_slot()

var center_offset: Vector2

func _ready():
	mouse_filter = MOUSE_FILTER_IGNORE
	icon_texture.mouse_filter = MOUSE_FILTER_IGNORE
	amount_label.mouse_filter = MOUSE_FILTER_IGNORE
	center_offset = size/2

func update_slot():
	if data != null:
		global_position = get_viewport().get_mouse_position() - size/2
		if data.item != null and data.amount > 0:
			icon_texture.texture = data.item.icon
			amount_label.text = str(data.amount)
		else:
			icon_texture.texture = null
			amount_label.text = ""
	else:
		icon_texture.texture = null
		amount_label.text = ""

func _input(event):
	if data != null:
		if event is InputEventMouseMotion:
			self.global_position = event.position - center_offset
