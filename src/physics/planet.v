module physics

import gx
import math
import math.vec

pub struct Planet implements IHit {
pub:
	radius f32 = 1000
	color gx.Color = gx.magenta

	parent IBody = &Body{}
	offset int
	speed f32 = 10
	a f32
	b f32
}

pub fn (p Planet) get_mass() f32 {
	return f32(math.pow(p.radius * 3.14, 2))
}

pub fn (p Planet) get_position(timestep f64) vec.Vec2[f32] {
	angle := f32((timestep + p.offset) * (p.speed / 100))
	parent_position := p.parent.get_position(timestep)

	return vec.Vec2[f32]{
		x: parent_position.x + (p.a * math.cosf(angle))
		y: parent_position.y + (p.b * math.sinf(angle))
	}
}

pub fn (p Planet) get_hitbox(timestep f64) HitBox {
	return HitBox(CircleHit {
		pos: p.get_position(timestep)
		radius: p.radius
	})
}
