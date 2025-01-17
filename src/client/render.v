module client

import gg
import math.vec
import math


fn frame(mut client Client) {
	client.timestep += 1/60.0
	// client.timestep += 1
	client.follow_selected()
	client.update_movables()


	client.gg.begin()

	client.render_stars()
	client.render_planets()
	client.render_movables()
	client.gg.end()
}

fn do_event(e &gg.Event, mut client Client) {
	match e.typ {
		.mouse_move {
			if client.gg.mouse_buttons == .right {
				client.follow = false
				client.camera.x += 10 * client.gg.mouse_dx * (client.zoom / 2)
				client.camera.y += 10 * client.gg.mouse_dy * (client.zoom / 2)
			}
		}
		.mouse_scroll {
			if client.gg.scroll_y > 0 {
				client.zoom -= 0.5
			} else if client.gg.scroll_y < 0 {
				client.zoom += 0.5
			}
		}
		.key_down {
			match e.key_code {
				.w {
					client.camera.y += 100 * (client.zoom / 2)
					client.follow = false
				}
				.s {
					client.camera.y -= 100 * (client.zoom / 2)
					client.follow = false
				}
				.a {
					client.camera.x += 100 * (client.zoom / 2)
					client.follow = false
				}
				.d {
					client.camera.x -= 100 * (client.zoom / 2)
					client.follow = false
				}
				.space {
					client.follow = !client.follow
				}
				._1 {
					client.follow = false
					client.camera = vec.Vec2[f32]{0,0}
				}
				.left {
					client.selected = (math.abs(client.selected - 1)) % client.movables.len
				}
				.right {
					client.selected = (client.selected + 1) % client.movables.len
				}
				else {}
			}
		}
		.resized {
			client.generate_stars()
		}
		else{}
	}
}
