extends Node

@export var select_button_index: int = 1
@export var secondary_button_index: int = 2

# MECHANICS

## Highground: Bullets will hit ledges when shot upward.
@export var m_highground: bool = true

## Concealment: Smoke prevents vision, disabeling automatic targeting.
@export var m_concealment: bool = true

## Dodge Roll iframes: Units invulnerable during dodge roll.
@export var m_dodgeroll_iframes: bool = true
