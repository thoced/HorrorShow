extends OmniLight

var elapsedTime = 0.0
var timeToStrobe = 0.0
var randomGenerator

# Called when the node enters the scene tree for the first time.
func _ready():
	randomGenerator = RandomNumberGenerator.new()
	
func _process(delta):
	elapsedTime += delta
	if elapsedTime > timeToStrobe:
		visible = !visible
		timeToStrobe = randomGenerator.randf_range(0.05,0.3)
		elapsedTime = 0.0

