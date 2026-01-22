extends Node

# UI Theme colors for consistent styling across the game
const COLORS = {
	"primary": Color(1, 0.85, 0.3, 1),       # Gold/Yellow - highlights
	"secondary": Color(0.4, 1, 0.4, 1),       # Green - positive feedback
	"warning": Color(1, 0.4, 0.4, 1),         # Red - negative feedback
	"background": Color(0, 0, 0, 0.7),        # Dark transparent BG
	"text": Color(1, 1, 1, 1),                # White text
	"text_dim": Color(0.7, 0.7, 0.7, 1),      # Dimmed text
	"accent": Color(0.3, 0.8, 1, 1)           # Cyan accent
}

# Animation speeds
const ANIM_SPEED = {
	"fast": 0.15,
	"normal": 0.25,
	"slow": 0.4
}

static func create_panel_stylebox() -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = COLORS["background"]
	style.border_color = COLORS["primary"]
	style.set_border_width_all(2)
	style.set_corner_radius_all(4)
	style.set_content_margin_all(10)
	return style

static func animate_button_hover(button: Control, hover: bool) -> void:
	var tween = button.create_tween()
	if hover:
		tween.tween_property(button, "scale", Vector2(1.05, 1.05), ANIM_SPEED["fast"])
	else:
		tween.tween_property(button, "scale", Vector2(1.0, 1.0), ANIM_SPEED["fast"])
