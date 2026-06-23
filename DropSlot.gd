extends Panel
class_name DropSlot
## Espaço de uma conta onde a criança solta o operador.
## Aceita o drag de um OperatorChip e guarda o operador escolhido.

var op: String = ""
var _label: Label

const SLOT_SIZE := Vector2(55, 55)

func _ready() -> void:
	custom_minimum_size = SLOT_SIZE
	_label = Label.new()
	_label.add_theme_font_size_override("font_size", 32)
	_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_label)

## O Godot pergunta se este Control aceita a carga sob o cursor.
func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	return typeof(data) == TYPE_DICTIONARY and data.has("op")

## O Godot entrega a carga quando o usuário solta aqui.
func _drop_data(_at_position: Vector2, data: Variant) -> void:
	set_op(data["op"])

func set_op(new_op: String) -> void:
	op = new_op
	_label.text = op

func clear_op() -> void:
	op = ""
	_label.text = ""
