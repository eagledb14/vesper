module client

import gg
import gx
import physics
import rand
import math
import math.vec

pub struct Client {
mut:
	camera vec.Vec2[f32]
	zoom f32 = 1000
	timestep f64 = 1
	planets []&physics.Planet
	movables []&physics.PhysicsBody
	selected int
	follow bool
pub mut:
	stars []vec.Vec2[f32]
	gg &gg.Context = unsafe { nil }
}

pub fn new_client() &Client {
	sun := &physics.Planet{color: gx.yellow, radius: 5000}
	p := &physics.Planet{a: 50000, b: 50000, offset: 1000, speed: 10}
	m := &physics.Planet{a: 10000, b: 20000, parent: p, speed: 100}
	p1 := &physics.Planet{a: 100_000, b: 100_000, offset: 30000, speed: 20}
	p2 := &physics.Planet{a: 250_000, b: 400_000, speed: 15}

	r := &physics.PhysicsBody{x:100_000, y:100_000, mass: 1000, velocity: vec.Vec2[f32]{-10, 1_000}}
	r1 := &physics.PhysicsBody{x:-100_000, y:100_000, mass: 1000, velocity: vec.Vec2[f32]{700, 850}}
	r2 := &physics.PhysicsBody{x:-200_000, y:200_000, mass: 1000, velocity: vec.Vec2[f32]{-400, -400}}
	// r := new_rocket()

	mut client := &Client{
		planets: [
			sun,
			&physics.Planet{a: 20000, b: 20000},
			p,
			m,
			p1,
			&physics.Planet{a: 20000, b: 20000, parent: p1, speed: 100},
			&physics.Planet{a: 5000, b: 10000, parent: p1, speed: -50},
			p2,
			&physics.Planet{a: 5_000, b: 10_000, parent: p2, speed: -50},
			&physics.Planet{a: 17_000, b: 15_000, parent: p2, speed: 50},
		]
		movables: [
			r
			r1
			r2
		]
		selected: 0
	}
	client.gg = gg.new_context(
		bg_color: gx.black
		width:        1000
		height:       1000
		window_title: 'Little Space Game'
		frame_fn:     frame
		event_fn: do_event
		user_data: client
	)


	client.generate_stars()

	planets := client.planets.map(&physics.IHit(it))
	for mut move in client.movables {
		move.get_steps(planets, client.timestep)
	}
	client.gg.run()


	return client
}

pub fn (c &Client) render_planets() {
	for planet in c.planets {
		mut orbit_position := planet.parent.get_position(c.timestep)
		orbit_position = orbit_position.transform(c.camera, c.zoom)
		if c.movables[c.selected].get_position(c.timestep) == planet.get_position(c.timestep) {
			c.gg.draw_ellipse_empty(orbit_position.x, orbit_position.y, planet.a / c.zoom, planet.b / c.zoom, gx.green)
		} else {
			c.gg.draw_ellipse_empty(orbit_position.x, orbit_position.y, planet.a / c.zoom, planet.b / c.zoom, gx.white)
		}

		mut planet_position := planet.get_position(c.timestep)
		planet_position = planet_position.transform(c.camera, c.zoom)
		c.gg.draw_circle_filled(planet_position.x, planet_position.y, planet.radius / c.zoom, planet.color)
	}
}

pub fn (c &Client) render_stars() {
	size := c.gg.window_size()
	for star in c.stars {
		// x := math.abs(f32(math.fmod((star.x  * size.width) + (c.camera.x * 0.001), size.width)))
		// y := math.abs(f32(math.fmod((star.y * size.height) + (c.camera.y * 0.001), size.height)))
		x := math.fmod((star.x * size.width) + (c.camera.x * 0.001), size.width)
		y := math.fmod((star.y * size.height) + (c.camera.y * 0.001), size.height)
		c.gg.draw_rect_filled(f32(x), f32(y), 2, 2, gx.white)
	}
}

pub fn (mut c Client) render_movables() {
	for mut move in c.movables {
		mut movable_position := move.get_position(c.timestep)
		movable_position = movable_position.transform(c.camera, c.zoom)
		c.gg.draw_rect_filled(movable_position.x, movable_position.y, move.size.x / c.zoom, move.size.y / c.zoom, gx.cyan)

		path := move.steps
		for i in 0.. path.len - 1 {
			point1 := path[i].body.get_position(c.timestep).transform(c.camera, c.zoom)
			point2 := path[i + 1].body.get_position(c.timestep).transform(c.camera, c.zoom)

			if c.movables[c.selected].get_position(c.timestep) == move.get_position(c.timestep) {
				c.gg.draw_line(point1.x, point1.y, point2.x, point2.y, gx.green)
			} else {
				c.gg.draw_line(point1.x, point1.y, point2.x, point2.y, gx.yellow)
			}
		}
	}
}

pub fn (mut c Client) update_movables() {
	planets := c.planets.map(&physics.IHit(it))

	for mut move in c.movables {
		move.update_velocity(planets, c.timestep)
		move.step_next(planets)
	}
}

pub fn (mut c Client) generate_stars() {
	c.stars.clear()

	for _ in 0 .. 200 {
		c.stars << vec.Vec2[f32] {
			x: rand.f32()
			y: rand.f32()
		}
	}
}

pub fn (mut c Client) follow_selected() {
	if !c.follow {
		return
	}
	size := c.gg.window_size()
	mut selected_pos := c.movables[c.selected].get_position(c.timestep)

	x := -selected_pos.x + (size.width / 2 * c.zoom)
	y := -selected_pos.y + (size.height / 2 * c.zoom)

	c.camera = vec.Vec2[f32]{x: x, y: y}
}

pub fn (v vec.Vec2[f32]) transform(camera vec.Vec2[f32], zoom f32) vec.Vec2[f32] {
	return vec.Vec2 {
		x: (v.x + camera.x) / zoom
		y: (v.y + camera.y) / zoom
	}
}
