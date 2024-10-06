class_name InventoryManager
extends Control

@export_group("Inventory Positioning")
@export var player_inventory_slot: Control
@export var accessed_inventory_slot: Control
@export_group("PackedScenes")
@export var player_inventory_scene: PackedScene
@export var hand_slot_scene: PackedScene
@export_group("Resources")
@export var player_inventory_resource: Inventory

var accessed_inventory: InventoryContainer
var hand_slot: HandSlot
var player_inventory: InventoryContainer
var is_open: bool = false

func _init():
	mouse_filter = MOUSE_FILTER_PASS
	set_anchors_preset(Control.PRESET_FULL_RECT)

func _ready():
	hand_slot = hand_slot_scene.instantiate()
	hand_slot.data = InventoryAutoload.hand_slot
	add_child(hand_slot)
	player_inventory = player_inventory_scene.instantiate()
	player_inventory.inventory = player_inventory_resource
	InventoryAutoload.player_inventory = player_inventory
	player_inventory_slot.add_child(player_inventory)
	
	connect_signals()

func _input(event):
	if event.is_action_pressed("ui_down"):
		if is_open:
			close_inventories()
		else:
			open_inventories()

func open_inventories():
	is_open = true
	if player_inventory != null:
		if not player_inventory.visible:
			player_inventory.open()
	if accessed_inventory != null:
		if not accessed_inventory.visible:
			accessed_inventory.open()

func close_inventories():
	is_open = false
	if player_inventory != null:
		player_inventory.close()
	InventoryAutoload.accessed_inventory = null

func connect_signals():
	InventoryAutoload.hand_slot_changed.connect(_on_hand_slot_changed.bind())
	InventoryAutoload.accessed_inventory_changed.connect(_on_accessed_inventory_changed.bind())

func _on_hand_slot_changed(data: InventorySlotData):
	hand_slot.data = data

func _on_accessed_inventory_changed(inventory: InventoryContainer):
	for inv: InventoryContainer in accessed_inventory_slot.get_children():
		accessed_inventory_slot.remove_child(inv)
		inv.queue_free()
	accessed_inventory = inventory
	if accessed_inventory != null:
		accessed_inventory_slot.add_child(accessed_inventory)
		if is_open:
			accessed_inventory.open()
		else:
			open_inventories()
	#accessed_inventory.inventory = inventory
