class_name InventoryComponent2D
extends Node

@export var interact_area: CollisionObject2D
@export var inventory_template: PackedScene
@export var inventory: Inventory

func _ready():
	interact_area.input_event.connect(_on_inventory_input_event.bind())
	#inventory.close()
	#inventory_container = inventory_template.instantiate()
	#inventory_container.inventory = inventory
	#inventory_container.close()
	#print("Inv Comp")

func inventory_pressed():
	if InventoryAutoload.accessed_inventory == null:
		#print("open inventory")
		InventoryAutoload.accessed_inventory = create_inventory()
		return
	
	if InventoryAutoload.accessed_inventory.inventory != inventory:
		#print("open inventory")
		InventoryAutoload.accessed_inventory = create_inventory()
	else:
		#print("close inventory")
		InventoryAutoload.accessed_inventory = null

func create_inventory() -> InventoryContainer:
	var temp_inv: InventoryContainer = inventory_template.instantiate()
	temp_inv.inventory = inventory
	return temp_inv

func _on_inventory_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	if event is InputEventMouseButton:
			if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				inventory_pressed()
