module physics

import math.vec
import math

pub struct CircleHit {
	pos vec.Vec2[f32]
	radius f32
}

pub struct SquareHit {
	pos vec.Vec2[f32]
	size vec.Vec2[f32]
}

type HitBox = CircleHit | SquareHit


pub interface IBox {
	get_hitbox(timestep f64) HitBox
}

pub interface IHit {
	IBody
	IBox
}


pub struct Collision {
	timestep f64
	pos vec.Vec2[f32]
}


pub fn do_collide(first HitBox, second HitBox, timestep f64) bool {
	if first is CircleHit && second is CircleHit {
		return circle_circle_collision(first, second, timestep)
	} else if first is CircleHit && second is SquareHit {
		return circle_square_collision(first, second, timestep)
	} else if first is SquareHit && second is CircleHit {
		return circle_square_collision(second, first, timestep)
	} else if first is SquareHit && second is SquareHit {
		return square_square_collision(first, second, timestep)
	}

	return false
}

// Function to check collision between two circles
fn circle_circle_collision(c1 CircleHit, c2 CircleHit, timestep f64) bool {
	distance := (c1.pos - c2.pos).magnitude() // Distance between centers
	radii_sum := c1.radius + c2.radius

	return distance <= radii_sum
}

// // Function to check collision between a circle and a square
fn circle_square_collision(c CircleHit, s SquareHit, timestep f64) bool {
	// Closest point on square to the circle
	closest_x := math.max(s.pos.x, math.min(c.pos.x, s.pos.x + s.size.x))
	closest_y := math.max(s.pos.y, math.min(c.pos.y, s.pos.y + s.size.y))
	closest_point := vec.Vec2[f32]{x: closest_x, y: closest_y}

	// Distance from circle center to closest point
	distance := (c.pos - closest_point).magnitude()

	return distance <= c.radius
}

// // Function to check collision between two squares
fn square_square_collision(s1 SquareHit, s2 SquareHit, timestep f64) bool {
	return !(s1.pos.x + s1.size.x < s2.pos.x || s2.pos.x + s2.size.x < s1.pos.x ||
	     s1.pos.y + s1.size.y < s2.pos.y || s2.pos.y + s2.size.y < s1.pos.y)
}
