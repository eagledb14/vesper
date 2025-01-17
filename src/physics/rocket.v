module physics

import math.vec
import math


pub struct Rocket implements IHit {
	PhysicsBody
pub:
	engine Engine
pub mut:
	rotation f32
	engine_on bool
}

type Engine = vec.Vec2[f32]

pub fn (e &Engine) rotate(angle f32) vec.Vec2[f32] {
    // x' = x cos θ − y sin θ
    // y' = x sin θ + y cos θ
	return vec.Vec2[f32]{
		x: e.x * math.cosf(angle) - e.y * math.sinf(angle)
		y: e.x * math.sinf(angle) + e.y * math.cosf(angle)
	}
}

pub fn new_rocket() Rocket {
	return Rocket {
		size: vec.Vec2[f32]{100, 100}
		x: 100_000
		y: 100_000
		engine: Engine{x:10, y:10}
		rotation: 100
	}
}


pub fn (mut r Rocket) run_engines(bodies []&IHit, timestep f64) {
	if r.engine_on {
		rotated_engine := r.engine.rotate(r.rotation)
		r.velocity.x += rotated_engine.x
		r.velocity.y += rotated_engine.y
	}

	r.PhysicsBody.update_velocity(bodies, timestep)
}



