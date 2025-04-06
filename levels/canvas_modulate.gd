extends CanvasModulate

@export var gradient: GradientTexture1D

const max_darkness_depth: float = 8000.0
const max_modulation: float = 0.60

# pass a value of 0 to 1 to set gradient
func set_gradient(depth: float):
	if depth > max_darkness_depth:
		depth = max_darkness_depth

	var total_modulation = depth/max_darkness_depth
	if total_modulation > max_modulation:
		total_modulation = max_modulation

	self.color = gradient.gradient.sample(total_modulation)
