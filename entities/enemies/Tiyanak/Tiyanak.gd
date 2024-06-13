extends Entity

@export var vision_range: float = 96

func _ready():
    super()
    %HealthBar.health_depleted.connect(self.destroy)
    %HurtBox.damaged.connect(%HealthBar.on_damaged)
    %HurtBox.damaged.connect(%Movement.on_damaged)
