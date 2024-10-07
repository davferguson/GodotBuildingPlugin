#@tool
class_name InventoryContainer
extends Control

@export_group("Properties")
@export var inventory: Inventory:
	set(value):
		#print("inv container: set_inventory")
		# Disconnect the signal if the previous resource was not null.
		#if inventory != null:
			#inventory.changed.disconnect(_on_inventory_changed)
		
		inventory = value
		_on_inventory_changed()
		#if inventory != null:
			#inventory.changed.connect(_on_inventory_changed)
		#if not Engine.is_editor_hint():
			#_on_inventory_changed()

@export_group("Nodes")
@export var grid_container: GridContainer

@export_group("Templates")
@export var slot_scene: PackedScene
	#set(value):
		#slot_scene = value
		#_on_inventory_changed()

func _init():
	mouse_filter = MOUSE_FILTER_PASS
	hide()

func _on_inventory_changed() -> void:
	#print("_on_inventory_changed")
	if slot_scene == null:
		push_error("Slot scene is undefined")
		return
	if grid_container == null:
		push_error("grid_container is undefined")
		return
	for slot: InventorySlot in grid_container.get_children():
		grid_container.remove_child(slot)
		slot.queue_free()
	if inventory == null:
		return
	for index in range(inventory.items.size()):
		var slot: InventorySlot = slot_scene.instantiate()
		#if inventory.items[index] != null:
		slot.data = inventory.items[index]
		slot.index = index
		connect_slot_signals(slot)
		#slot.slot_interacted.connect(_on_slot_interacted.bind())
		#slot.update_slot()
		grid_container.add_child(slot)
		#if Engine.is_editor_hint() and is_inside_tree():
		#slot.owner = get_tree().edited_scene_root

#func _enter_tree():
	#_on_inventory_changed()

#func _ready():
	#print("inv container _ready")
	#if not Engine.is_editor_hint():
			#_on_inventory_changed()

func connect_slot_signals(slot: InventorySlot):
	slot.slot_changed.connect(_on_slot_changed.bind())
	slot.slot_double_clicked.connect(_on_slot_double_clicked.bind())
	slot.slot_shift_clicked.connect(_on_slot_shift_clicked.bind())

func close():
	for slot: InventorySlot in grid_container.get_children():
		grid_container.remove_child(slot)
		slot.queue_free()
	visible = false

func open():
	_on_inventory_changed()
	visible = true

func _on_slot_changed(index: int, slot_data: InventorySlotData):
	#print("inv container _on_slot_changed")
	inventory.items[index] = slot_data
	#var slot: InventorySlot = grid_container.get_child(index)
	#slot.data = inventory.items[index]

func _on_slot_double_clicked(index: int):
	inventory.combine_slot(index)
	_on_inventory_changed()

func _on_slot_shift_clicked(index: int):
	if InventoryAutoload.accessed_inventory == null or InventoryAutoload.player_inventory == null:
		return
	if inventory == InventoryAutoload.accessed_inventory.inventory:
		var returned_items: InventorySlotData
		returned_items = InventoryAutoload.player_inventory.inventory.add_item(inventory.items[index])
		inventory.items[index] = returned_items
		InventoryAutoload.player_inventory._on_inventory_changed()
		_on_inventory_changed()
		#InventoryAutoload.player_inventory.inventory.items[0] = inventory.items[index]
		#InventoryAutoload.player_inventory._on_inventory_changed()
	if inventory == InventoryAutoload.player_inventory.inventory:
		var returned_items: InventorySlotData
		returned_items = InventoryAutoload.accessed_inventory.inventory.add_item(inventory.items[index])
		inventory.items[index] = returned_items
		InventoryAutoload.accessed_inventory._on_inventory_changed()
		_on_inventory_changed()

#func _on_slot_interacted(index: int):
	##print("slot: " + str(index))
	#var hand_data: InventorySlotData = InventoryAutoload.hand_slot
	#var slot_data: InventorySlotData = inventory.items[index]
	#inventory.items[index] = InventorySlotData.new()
	#
	#if slot_data == null and hand_data != null:
		#inventory.items[index] = hand_data
		#hand_data = null
	##if slot_data != null and hand_data == null:
		##hand_data = slot_data
		##inventory.items[index] = null
		##print("swap: ", inventory.items[index])
	#
	#var slot: InventorySlot = grid_container.get_children()[index]
	#slot.data = inventory.items[index]
	#slot.update_slot()
	#print("slot interacted: ", inventory.items[index])
	#ResourceSaver.save(inventory)
