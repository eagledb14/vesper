module physics

import math.vec

pub struct Body implements IBody {
	vec.Vec2[f32]
pub:
	mass f32
}

pub fn (b Body) get_position(timestep f64) vec.Vec2[f32] {
	return b.Vec2
}

pub fn (b Body) get_mass() f32 {
	return b.mass
}

pub fn (b Body) clone() Body {
	return Body{
		Vec2: b.Vec2
		mass: b.mass
	}
}

pub interface IMass {
	get_mass() f32
}

pub interface IPosition {
	get_position(timestep f64) vec.Vec2[f32]
}

pub interface IBody {
	IPosition
	IMass
}


