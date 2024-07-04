tool
extends Control

onready var select_button: Button = $SelectButton
onready var bg: ColorRect = $SelectButton/ColorRect
onready var vbox: VBoxContainer = $SelectButton/ColorRect/ScrollContainer/VBoxContainer
onready var scroll_container: ScrollContainer = $SelectButton/ColorRect/ScrollContainer
onready var custom_button_scene: PackedScene = preload("res://custom_button.tscn")

export var default_select_text: String = ""
export(Array, String) var Options = []

var selected_node: Button = null

func _ready() -> void:
	select_button.text = default_select_text
	_on_ready_buttons()
	call_deferred("_set_container_properties")

func _set_container_properties() -> void:
	var set_size_x: float = select_button.rect_size.x
	bg.rect_size.x = set_size_x
	vbox.rect_size.x = set_size_x
	scroll_container.rect_size.x = set_size_x

func _on_ready_buttons() -> void:
	for option in Options:
		var button = custom_button_scene.instance()
		button.name = option
		button.text = option
		vbox.add_child(button)  
		button.connect("pressed", self, "_selected", [option])

func _add_new_button() -> void:
	if custom_button_scene:
		var custom_button_instance = custom_button_scene.instance() as Button
		if custom_button_instance:
			vbox.add_child(custom_button_instance)
			custom_button_instance.text = custom_button_instance.name
			custom_button_instance.connect("pressed", self, "_selected", [custom_button_instance.text])
		else:
			print("Failed to instance the scene.")
	else:
		print("Failed to load the scene.")

func _find_selected_node(selected_name: String) -> void:
	selected_node = vbox.get_node(selected_name) as Button

func _selected(button_text: String) -> void:
	_find_selected_node(button_text)
	select_button.text = selected_node.text
	select_button.pressed = false
	bg.visible = false
	_handle_button_action(button_text)
	
func _handle_button_action(button_text: String) -> void:
	match button_text:
		"Option1":
			print("Option1 selected")
		"Option2":
			print("Option2 selected")
		"Option3":
			print("Option3 selected!!!!!!!!!!!!!!!")
		_:
			# Default action for non specified options.
			print("Default action selected")

func _remove_selected() -> void:
	if is_instance_valid(selected_node):
		selected_node.queue_free()
		select_button.text = default_select_text

func _on_select_button_pressed() -> void:
	bg.visible = select_button.pressed

func _on_add_button_pressed() -> void:
	_add_new_button()
	
func _on_remove_button_pressed() -> void:
	_remove_selected()
