extends Control
## Cérebro do jogo: monta a tela, cria as contas e avalia os resultados.

## Lista fixa de contas (Fase 1). Cada conta: a OP b = result.
## Mais tarde trocamos por geração aleatória.
const EQUATIONS := [
	{"a": 5, "b": 3, "result": 8},
	{"a": 9, "b": 1, "result": 10},
	{"a": 7, "b": 3, "result": 4},
	{"a": 4, "b": 3, "result": 12},
	{"a": 15, "b": 3, "result": 5},
	{"a": 12, "b": 6, "result": 2},
]

const OPERATORS := ["+", "−", "×", "÷"]

var _slots: Array[DropSlot] = []
var _result_labels: Array[Label] = []
var _action_button: Button
var _status_label: Label
var _checked := false  ## false = esperando "Executar"; true = mostrando resultado

func _ready() -> void:
	_build_ui()

# --------------------------------------------------------------------------
# Construção da interface
# --------------------------------------------------------------------------

func _build_ui() -> void:
	# Imagem de fundo.
	var bg := TextureRect.new()
	bg.texture = load("res://FundoJogo (2).png")
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	bg.stretch_mode = TextureRect.STRETCH_SCALE
	bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(bg)

	# Margem geral em volta de tudo.
	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 32)
	margin.add_theme_constant_override("margin_right", 32)
	margin.add_theme_constant_override("margin_top", 24)
	margin.add_theme_constant_override("margin_bottom", 24)
	add_child(margin)

	# Duas colunas: esquerda (contas) e direita (painel de operadores).
	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 32)
	margin.add_child(columns)

	var left = _build_left_column()
	left.position = Vector2(20, 5)
	add_child(left)

	var ops = _build_operators_panel()
	ops.position = Vector2(960, 20)
	add_child(ops)

## Coluna da esquerda: título, contas e botão de ação.
func _build_left_column() -> Control:
	var col := VBoxContainer.new()
	col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	col.add_theme_constant_override("separation", 16)

	var title := Label.new()
	title.text = "Arraste a operação correta:"
	title.add_theme_font_size_override("font_size", 28)
	col.add_child(title)

	# Uma linha por conta.
	for i in EQUATIONS.size():
		col.add_child(_build_equation_row(i))

	_status_label = Label.new()
	_status_label.add_theme_font_size_override("font_size", 22)
	col.add_child(_status_label)
	
	var spacer := Control.new()
	spacer.custom_minimum_size = Vector2(0, 25) # 100 pixels de altura
	col.add_child(spacer)

	_action_button = Button.new()
	_action_button.text = "Executar"
	_action_button.add_theme_font_size_override("font_size", 24)
	_action_button.custom_minimum_size = Vector2(880, 50)
	_action_button.pressed.connect(_on_action_pressed)
	col.add_child(_action_button)

	return col

## Monta a linha "a [slot] b = result   <selo>".
func _build_equation_row(index: int) -> Control:
	var eq = EQUATIONS[index]
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 12)
	row.alignment = BoxContainer.ALIGNMENT_BEGIN

	row.add_child(_make_number_label(str(eq["a"])))

	var slot := DropSlot.new()
	_slots.append(slot)
	row.add_child(slot)

	row.add_child(_make_number_label(str(eq["b"])))
	row.add_child(_make_number_label("= " + str(eq["result"])))

	var result_label := Label.new()
	result_label.add_theme_font_size_override("font_size", 24)
	result_label.custom_minimum_size = Vector2(120, 0)
	_result_labels.append(result_label)
	row.add_child(result_label)

	return row

func _make_number_label(text: String) -> Label:
	var lbl := Label.new()
	lbl.text = text
	lbl.add_theme_font_size_override("font_size", 30)
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return lbl

## Painel da direita com as peças arrastáveis.
func _build_operators_panel() -> Control:
	# Estrutura: PanelContainer -> MarginContainer -> VBoxContainer (inner)
	var panel := PanelContainer.new()
	panel.size_flags_horizontal = Control.SIZE_SHRINK_END

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 16)
	margin.add_theme_constant_override("margin_bottom", 16)
	panel.add_child(margin)

	var inner := VBoxContainer.new()
	inner.add_theme_constant_override("separation", 14)
	margin.add_child(inner)

	var header := Label.new()
	header.text = "Operações"
	header.add_theme_font_size_override("font_size", 24)
	header.add_theme_color_override("font_color", Color(1, 1, 1, 0))
	inner.add_child(header)

	for op in OPERATORS:
		var chip := OperatorChip.new()
		chip.op = op
		inner.add_child(chip)

	return panel

# --------------------------------------------------------------------------
# Lógica do jogo
# --------------------------------------------------------------------------

func _on_action_pressed() -> void:
	if _checked:
		_reset_round()
	else:
		_check_answers()

func _check_answers() -> void:
	var acertos := 0
	for i in EQUATIONS.size():
		var eq = EQUATIONS[i]
		var slot := _slots[i]
		var label := _result_labels[i]
		var value = _apply(eq["a"], eq["b"], slot.op)
		if value != null and value == eq["result"]:
			label.text = "correto"
			label.add_theme_color_override("font_color", Color("1a9e4b"))
			acertos += 1
		else:
			label.text = "errada"
			label.add_theme_color_override("font_color", Color("d62b2b"))

	_status_label.text = "Você acertou %d de %d!" % [acertos, EQUATIONS.size()]
	_action_button.text = "Tentar novamente"
	_checked = true

func _reset_round() -> void:
	for slot in _slots:
		slot.clear_op()
	for label in _result_labels:
		label.text = ""
	_status_label.text = ""
	_action_button.text = " "
	_checked = false

## Aplica o operador. Retorna null se a operação não dá um inteiro válido.
func _apply(a: int, b: int, op: String) -> Variant:
	match op:
		"+": return a + b
		"−": return a - b
		"×": return a * b
		"÷":
			if b != 0 and a % b == 0:
				return a / b
			return null
		_:
			return null  # nenhum operador encaixado ainda
