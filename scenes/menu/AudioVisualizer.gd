extends Control

@export var max_height: float = 120.0
@export var min_height: float = 3.0
@export var smoothing: float = 0.25
@export var bar_color: Color = Color(1.0, 0.3, 0.5, 0.8)
@export var glow_color: Color = Color(1.0, 0.5, 0.7, 0.3)

var spectrum: AudioEffectSpectrumAnalyzerInstance
var bar_heights: Array = []
var target_heights: Array = []
var bar_count: int = 64
var spectrum_analyzer: AudioEffectSpectrumAnalyzer

# Frequency bands for better visualization
var freq_bands = []
var min_freq = 20.0
var max_freq = 16000.0

func _ready():
	# Add spectrum analyzer to Master bus if not present
	setup_spectrum_analyzer()
	
	# Initialize bar heights
	bar_heights.clear()
	target_heights.clear()
	for i in range(bar_count):
		bar_heights.append(min_height)
		target_heights.append(min_height)
	
	# Create logarithmic frequency bands for better visualization
	freq_bands.clear()
	for i in range(bar_count + 1):
		var t = float(i) / bar_count
		# Logarithmic scale for more musical frequency distribution
		var freq = min_freq * pow(max_freq / min_freq, t)
		freq_bands.append(freq)

func setup_spectrum_analyzer():
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx < 0:
		return
	
	# Check if spectrum analyzer already exists
	for i in range(AudioServer.get_bus_effect_count(bus_idx)):
		var effect = AudioServer.get_bus_effect(bus_idx, i)
		if effect is AudioEffectSpectrumAnalyzer:
			spectrum = AudioServer.get_bus_effect_instance(bus_idx, i)
			return
	
	# Add spectrum analyzer effect
	spectrum_analyzer = AudioEffectSpectrumAnalyzer.new()
	spectrum_analyzer.buffer_length = 0.1
	spectrum_analyzer.fft_size = AudioEffectSpectrumAnalyzer.FFT_SIZE_2048
	AudioServer.add_bus_effect(bus_idx, spectrum_analyzer)
	
	# Get the instance
	var effect_idx = AudioServer.get_bus_effect_count(bus_idx) - 1
	spectrum = AudioServer.get_bus_effect_instance(bus_idx, effect_idx)

func _process(_delta):
	update_bars()
	queue_redraw()

func update_bars():
	if spectrum and freq_bands.size() > bar_count:
		for i in range(bar_count):
			var freq_low = freq_bands[i]
			var freq_high = freq_bands[i + 1]
			var magnitude = spectrum.get_magnitude_for_frequency_range(freq_low, freq_high)
			
			# Convert to decibels and normalize
			var mag = (magnitude.x + magnitude.y) / 2.0
			var db = linear_to_db(mag)
			var normalized = clamp((db + 60) / 60.0, 0.0, 1.0)
			
			# Apply some boost to make it more visible
			normalized = pow(normalized, 0.7) * 1.5
			normalized = clamp(normalized, 0.0, 1.0)
			
			target_heights[i] = min_height + normalized * (max_height - min_height)
	
	# Smooth interpolation with faster attack, slower decay
	for i in range(bar_count):
		if target_heights[i] > bar_heights[i]:
			bar_heights[i] = lerp(bar_heights[i], target_heights[i], smoothing * 2.0)
		else:
			bar_heights[i] = lerp(bar_heights[i], target_heights[i], smoothing * 0.5)

func _draw():
	if bar_heights.size() == 0:
		return
	
	# Calculate bar dimensions to span full width
	var total_gap = 2.0 * (bar_count - 1)
	var bar_width = (size.x - total_gap) / bar_count
	var bar_gap = 2.0
	var base_y = size.y
	
	for i in range(bar_count):
		var x = i * (bar_width + bar_gap)
		var height = bar_heights[i]
		var rect = Rect2(x, base_y - height, bar_width, height)
		
		# Color gradient based on frequency (low = red, high = cyan)
		var t = float(i) / bar_count
		var color = bar_color.lerp(Color(0.3, 0.8, 1.0, 0.8), t * 0.5)
		var glow = glow_color.lerp(Color(0.3, 0.6, 1.0, 0.3), t * 0.5)
		
		# Draw glow
		var glow_rect = Rect2(x - 1, base_y - height - 1, bar_width + 2, height + 2)
		draw_rect(glow_rect, glow)
		
		# Draw main bar
		draw_rect(rect, color)
		
		# Draw highlight at top
		if height > min_height + 2:
			var highlight_rect = Rect2(x, base_y - height, bar_width, 2)
			draw_rect(highlight_rect, Color(1, 1, 1, 0.5))
