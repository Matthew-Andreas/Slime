extends WorldEnvironment
@onready var player: CharacterBody3D = $"../Player"

func  _process(delta: float) -> void:
	if GameManager.current_player_height > 175:
		self.environment.sky = GameManager.SPACE_SKY
	
	if(player.position.y < 174.5):
		self.environment.sky = GameManager.NORMAL_SKY
	
