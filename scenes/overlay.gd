extends ColorRect
"""
Shader modifiers
"""

func set_shader(effect_strength = 500, mix_color = Color(0.01, 0.01, 0.01, 1)) -> void:
	material.set_shader_parameter("effect_strength", effect_strength)
	material.set_shader_parameter("mix_color", mix_color)
