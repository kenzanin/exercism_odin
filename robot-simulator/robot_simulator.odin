package robot_simulator

Heading :: enum {
	North,
	East,
	South,
	West,
}

Position :: struct {
	x: int,
	y: int,
}

Robot :: struct {
	pos: Position,
	hd:  Heading,
}

create_robot :: proc(x, y: int, dir: Heading) -> Robot {
	return {pos = {x, y}, hd = dir}
}

follow_commands :: proc(r: ^Robot, cmds: string) {
	deltas := [4]Position{{0, 1}, {1, 0}, {0, -1}, {-1, 0}}

	for c in cmds {
		switch c {
		case 'R':
			r.hd = Heading((int(r.hd) + 1 + 4) % 4)
		case 'L':
			r.hd = Heading((int(r.hd) - 1 + 4) % 4)
		case 'A':
			d := deltas[int(r.hd)]
			r.pos.x += d.x
			r.pos.y += d.y
		}
	}
}
