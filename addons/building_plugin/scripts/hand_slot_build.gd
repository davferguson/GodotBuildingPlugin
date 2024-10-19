class_name HandSlotBuild
extends HandSlot

func _input(event):
	if data != null:
		if event is InputEventMouseMotion:
			self.global_position = event.position - center_offset
			
			if data.item is PlaceableInventoryItem:
				var hovered_control = get_viewport().gui_get_hovered_control()
				icon_texture.visible = hovered_control != null

func update_slot():
	super()
	if data == null:
		icon_texture.visible = true
