#@tool
class_name InventorySlot
extends Control

signal slot_changed(index: int, data: InventorySlotData)
signal slot_double_clicked(index: int)
signal slot_shift_clicked(index: int)

@export_category("Properties")
@export var data: InventorySlotData = null:
	set(value):
		data = value
		update_slot()
#@export var data: InventorySlotData:
	#set(value):
		#if get_parent() is InventoryContainer:
			#get_parent().inventory.items[index] = value
	#get():
		#if not get_parent() is InventoryContainer: return null
		#return get_parent().inventory.items[index]

@export_category("Nodes")
@export var icon_texture: TextureRect
@export var amount_label: Label

var index: int

#func _ready():
	#if not Engine.is_editor_hint():
		#gui_input.connect(_on_gui_input.bind())
		#update_slot()

func update_slot():
	#print("update_slot")
	if data != null:
		if data.item != null and data.amount > 0:
			icon_texture.texture = data.item.icon
			amount_label.text = str(data.amount)
		else:
			icon_texture.texture = null
			amount_label.text = ""
	else:
		icon_texture.texture = null
		amount_label.text = ""

func slot_pressed(button_index: int):
	#print("slot " + str(index) + " pressed.")
	var hand_slot: HandSlot = InventoryAutoload.hand_slot
	var hand_data: InventorySlotData = hand_slot.data
	match button_index:
		MOUSE_BUTTON_LEFT:
			if hand_data == null: ## HAND EMPTY
				if data != null: ## AND INV SLOT HAS ITEM
					#swap_hand_with_inventory_slot(inventory, slot_index, hand_data)
					hand_data = data
					data = null
			else: ## HAND NOT EMPTY
				if data != null: ## AND INV SLOT HAS ITEM
					if hand_data.item == data.item: ## AND ITEMS THE SAME
						#add_from_hand_to_inventory(inventory, slot_index, hand_data, hand_data.amount)
						var total_amount = hand_data.amount + data.amount
						if total_amount > data.item.max_stack:
							data.amount = data.item.max_stack
							hand_data.amount = total_amount - data.item.max_stack
						else:
							data.amount = total_amount
							hand_data = null
					else: ## AND ITEMS ARE DIFFERENT
						#swap_hand_with_inventory_slot(inventory, slot_index, hand_data)
						var temp_data = data
						data = hand_data
						hand_data = temp_data
				else: ## AND INV SLOT IS EMPTY
					data = hand_data
					hand_data = null
		MOUSE_BUTTON_RIGHT:
			if hand_data == null: ## HAND EMPTY
				if data != null: ## AND INV SLOT HAS ITEM
					#split_inventory_slot_into_hand(inventory, slot_index)
					if data.amount >= 2:
						var return_amount = data.amount/2
						data.amount -= return_amount
						if return_amount > 0:
							hand_data = InventorySlotData.new()
							hand_data.item = data.item
							hand_data.amount = return_amount
			else: ## HAND NOT EMPTY
				#add_from_hand_to_inventory(inventory, slot_index, hand_data, 1)
				if data != null: ## AND SLOT HAS ITEM
					if hand_data.item == data.item: ## AND SAME ITEM
						if data.amount < data.item.max_stack: ## SLOT HAS SPACE
							data.amount += 1
							hand_data.amount -= 1
							if hand_data.amount <= 0:
								hand_data = null
				else: ## AND SLOT EMPTY
					data = InventorySlotData.new()
					data.item = hand_data.item
					data.amount = 1
					hand_data.amount -= 1
					if hand_data.amount <= 0:
								hand_data = null
	
	data = data
	hand_slot.data = hand_data
	InventoryAutoload.hand_slot = hand_slot
	slot_changed.emit(index, data)

func _gui_input(event: InputEvent):
	if not Engine.is_editor_hint():
		if event.is_action_pressed("shift_click"):
			slot_shift_clicked.emit(index)
		elif event is InputEventMouseButton:
			if event.pressed:
				slot_pressed(event.button_index)
				get_viewport().set_input_as_handled()
			if event.double_click and event.button_index == MOUSE_BUTTON_LEFT:
				slot_double_clicked.emit(index)
