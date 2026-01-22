extends Control

@export var bar_count: int = 32
@export var bar_width: float = 12.0
@export var bar_gap: float = 4.0
@export var max_height: float = 150.0
@export var min_height: float = 5.0
@export var smoothing: float = 0.15
@export var bar_color: Color = Color(1.0, 0.3, 0.5, 0.8)
@export var glow_color: Color = Color(1.0, 0.5, 0.7, 0.4)

var spectrum: AudioEffectSpectrumAnalyzerInstance
var bar_heights: Array = []
var target_heights: Array = []

func _ready():
	# Initialize bar heights
	for i in range(bar_count):
		bar_heights.append(min_height)
		target_heights.append(min_height)
	
	# Get spectrum analyzer
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx >= 0:
		# Check if spectrum analyzer effect exists, if not we'll just use random visualization
		for i in range(AudioServer.get_bus_effect_count(bus_idx)):
			var effect = AudioServer.get_bus_effect(bus_idx, i)
			if effect is AudioEffectSpectrumAnalyzer:
				spectrum = AudioServer.get_bus_effect_instance(bus_idx, i)
				break

func _process(delta):
	update_bars(delta)
	queue_redraw()

func update_bars(delta):
	if spectrum:
		# Use actual spectrum data
		var freq_range = 20000.0
		for i in range(bar_count):
			var freq_low = (float(i) / bar_count) * freq_range
			var freq_high = (float(i + 1) / bar_count) * freq_range
			var magnitude = spectrum.get_magnitude_for_frequency_range(freq_low, freq_high)
			var energy = clamp((magnitude.x + magnitude.y) * 50.0, 0.0, 1.0)
			target_heights[i] = min_height + energy * (max_height - min_height)
	else:
		# Fallback: react to music player if no spectrum analyzer
		var music_player = get_node_or_null("/root/Main/Music")
		if music_player and music_player.playing:
			for i in range(bar_count):
				# Create pseudo-random reactive bars based on time
				var time_offset = Time.get_ticks_msec() / 1000.0
				var wave = sin(time_offset * (3.0 + i * 0.5) + i * 0.3)
				var wave2 = sin(time_offset * (5.0 + i * 0.3) + i * 0.7)
				var combined = (wave + wave2) * 0.5 + 0.5
				target_heights[i] = min_height + combined * (max_height - min_height) * 0.7
		else:
			for i in range(bar_count):
				target_heights[i] = min_height
	
	# Smooth interpolation
	for i in range(bar_count):
		bar_heights[i] = lerp(bar_heights[i], target_heights[i], smoothing)

func _draw():
	var total_width = bar_count * (bar_width + bar_gap) - bar_gap
	var start_x = (size.x - total_width) / 2.0
	var base_y = size.y
	
	for i in range(bar_count):
		var x = start_x + i * (bar_width + bar_gap)
		var height = bar_heights[i]
		var rect = Rect2(x, base_y - height, bar_width, height)
		
		# Draw glow (larger, more transparent)
		var glow_rect = Rect2(x - 2, base_y - height - 2, bar_width + 4, height + 4)
		draw_rect(glow_rect, glow_color)
		
		# Draw main bar
		draw_rect(rect, bar_color)
		
		# Draw highlight at top
		var highlight_rect = Rect2(x, base_y - height, bar_width, 3)
		draw_rect(highlight_rect, Color(1, 1, 1, 0.6))
