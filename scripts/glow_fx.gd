class_name GlowFx
extends RefCounted

const GLOW_SIZE = 15.0     # how far the glow spreads, in pixels
const LAYERS = 15          # more layers = smoother falloff
const LAYER_ALPHA = 0.015   # brightness of each layer

static func build(glow: Polygon2D):	
	glow.color = Color(1, 1, 1, 0)
	glow.z_index = 10

	var outline = glow.get_node_or_null("Outline")
	if outline:
		outline.hide()

	if glow.has_meta("glow_built"):
		glow.hide()
		return
	glow.set_meta("glow_built", true)

	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItemMaterial.BLEND_MODE_ADD

	for i in range(1, LAYERS + 1):
		var extent = GLOW_SIZE * float(i) / float(LAYERS)
		var shapes = Geometry2D.offset_polygon(glow.polygon, extent / 2.0, Geometry2D.JOIN_ROUND)

		for shape in shapes:
			var line = Line2D.new()
			line.points = shape
			line.closed = true
			line.width = extent
			line.default_color = Color(1, 1, 1, LAYER_ALPHA)
			line.joint_mode = Line2D.LINE_JOINT_ROUND
			line.antialiased = true
			line.material = mat
			glow.add_child(line)

	glow.hide()
