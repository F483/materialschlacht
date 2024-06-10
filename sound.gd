extends Node

@export var master_bus_mute: bool = false

func _ready():
    AudioServer.set_bus_mute(AudioServer.get_bus_index("Master"), true)
