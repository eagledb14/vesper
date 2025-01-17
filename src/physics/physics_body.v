module physics

import math.vec

pub struct PhysicsBody implements IHit {
	Body
pub mut:
	velocity vec.Vec2[f32]
	size vec.Vec2[f32] = vec.Vec2[f32]{1000, 1000}

	steps []Step
}

pub fn (mut p PhysicsBody) update_velocity(bodies []&IHit, timestep f64) {
	g := f32(0.2)
	starting_velocity := p.velocity
	// dump("physics body")

	for body in bodies {
		displacement := body.get_position(timestep) - p.get_position(timestep)

		sqr_dst := displacement.x * displacement.x + displacement.y * displacement.y

		force_magnitude := g * p.mass * body.get_mass() / sqr_dst

		// Calculate the unit vector in the direction of the force
		force_direction := displacement.normalize()

		// Calculate the gravitational force vector
		force := force_direction * vec.Vec2[f32]{force_magnitude, force_magnitude}
		p.velocity += force

		mut next_step := p.clone()
		next_step.x += p.velocity.x
		next_step.y += p.velocity.y

		collision := do_collide(next_step.get_hitbox(timestep), body.get_hitbox(timestep), timestep)

		if collision {
			p.velocity = starting_velocity
			return
		} else {
			p.velocity += force
		}
	}
	p.x  += p.velocity.x
	p.y  += p.velocity.y
}

pub fn (p PhysicsBody) clone() PhysicsBody {
	return PhysicsBody{
		Body: p.Body.clone()
		velocity: p.velocity
	}
}

pub struct Step {
pub mut:
	body PhysicsBody
	timestep f64
}

pub fn (mut p PhysicsBody) get_steps(bodies []&IHit, timestep f64) {
	mut step := []Step{}
	mut ts := timestep

	mut next_body := p.clone()

	for _ in 0 .. 10_000 {
		ts += 1/60.0
		next_body.update_velocity(bodies, ts)
		step << Step{next_body.clone(), ts}
	}

	step.reverse_in_place()

	p.steps = step
}

pub fn (mut p PhysicsBody) step_next(bodies []&IHit) {
	mut last_step := p.steps.pop()
	last_step.body = p.steps[0].body.clone()
	last_step.timestep = p.steps[0].timestep + 1/60.0

	last_step.body.update_velocity(bodies, last_step.timestep)
	p.steps.prepend(last_step)
}

pub fn (p PhysicsBody) get_hitbox(timestep f64) HitBox {
	return HitBox(SquareHit {
		pos: p.Body.Vec2
		size: p.size
	})
}
