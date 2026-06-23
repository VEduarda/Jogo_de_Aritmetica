extends Panel
class_name OperatorChip
## Peça arrastável que representa um operador (+, −, ×, ÷).
## Implementa _get_drag_data para o sistema nativo de drag & drop do Godot.

@export var op: String = "+"

const CHIP_SIZE := Vector2(70, 60)

func _ready() -> void:
	custom_minimum_size = CHIP_SIZE
	_add_label(self, op)
	mouse_default_cursor_shape = Control.CURSOR_DRAG

## Chamado pelo Godot quando o usuário começa a arrastar este Control.
## O dicionário retornado é "a carga" que chega no DropSlot.
func _get_drag_data(_at_position: Vector2) -> Variant:
	var preview := Panel.new()
	preview.size = CHIP_SIZE
	_add_label(preview, op)
	set_drag_preview(preview)
	return {"op": op}

## Cria um Label centralizado dentro de um nó pai.
func _add_label(parent: Control, text: String) -> void:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 36)
	lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(lbl)
