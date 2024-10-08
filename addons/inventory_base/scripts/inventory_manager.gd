class_name InventoryManager
extends Control

@export_group("Inventory Positioning")
@export var player_inventory_slot: Control
@export var accessed_inventory_slot: Control
@export var hotbar_slot: Control
@export_group("PackedScenes")
@export var player_inventory_scene: PackedScene
@export var hand_slot_scene: PackedScene
@export var hotbar_scene: PackedScene
@export_group("Resources")
@export var player_inventory_resource: Inventory
@export var hotbar_inventory_resource: Inventory
@export_group("Key Binds")
@export var inventory_key_bind: InputEventKey

var accessed_inventory: InventoryContainer
var hand_slot: HandSlot
var player_inventory: InventoryContainer
var is_open: bool = false

func _init():
	mouse_filter = MOUSE_FILTER_PASS
	#set_anchors_preset(Control.PRESET_FULL_RECT)

func _ready():
	set_key_binds()
	initialize_children()
	
	InventoryAutoload.hand_slot = hand_slot
	InventoryAutoload.player_inventory = player_inventory
	
	connect_signals()

func _input(event):
	if event.is_action_pressed("inventory"):
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
	InventoryAutoload.accessed_inventory_changed.connect(_on_accessed_inventory_changed.bind())

func set_key_binds():
	if InputMap.has_action("inventory"):
		InputMap.action_erase_events("inventory")
	else:
		InputMap.add_action("inventory")
	InputMap.action_add_event("inventory", inventory_key_bind)

func initialize_children():
	hand_slot = hand_slot_scene.instantiate()
	add_child(hand_slot)
	
	player_inventory = player_inventory_scene.instantiate()
	player_inventory.inventory = player_inventory_resource
	player_inventory_slot.add_child(player_inventory)
	
	var hotbar: Hotbar = hotbar_scene.instantiate()
	hotbar.inventory = hotbar_inventory_resource
	hotbar_slot.add_child(hotbar)

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
