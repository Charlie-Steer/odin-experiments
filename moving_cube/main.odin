package main

import "core:fmt"
import rl "vendor:raylib"

v2 :: [2]f32
Vector2 :: [2]f32

Color :: enum {
	Red,
	Green,
	Blue,
	Black,
	White,
	Purple,
	Pink,
	Yellow,
	Orange,
}

Colors :: #partial [Color]rl.Color {
	.Red    = {255, 0, 0, 255},
	.Green  = {0, 255, 0, 255},
	.Blue   = {0, 0, 255, 255},
	.Black  = {0, 0, 0, 255},
	.White  = {255, 255, 255, 255},
	.Purple = {100, 0, 100, 0},
}

win_start_dimensions := [2]i32{800, 450}
rect_dimensions := [2]i32{50, 50}
speed: f32 = 250
position: [2]f32

main :: proc() {
	rl.InitWindow(800, 450, "my_game")
	rl.SetWindowPosition(1064, 42)
	rl.SetTargetFPS(60)
	position = {
		f32((win_start_dimensions.x - rect_dimensions.x) / 2),
		f32((win_start_dimensions.y - rect_dimensions.y) / 2),
	}
	for !rl.WindowShouldClose() {
		// Frame Start
		delta_time := rl.GetFrameTime()
		win_pos := rl.GetWindowPosition()

		// Drawing
		rl.BeginDrawing()

		rl.ClearBackground(Colors[.Purple])
		win_dimensions := [2]i32{rl.GetScreenWidth(), rl.GetScreenHeight()}
		if rl.IsKeyDown(rl.KeyboardKey.W) do position.y -= speed * delta_time
		if rl.IsKeyDown(rl.KeyboardKey.A) do position.x -= speed * delta_time
		if rl.IsKeyDown(rl.KeyboardKey.S) do position.y += speed * delta_time
		if rl.IsKeyDown(rl.KeyboardKey.D) do position.x += speed * delta_time
		rl.DrawRectangle(
			i32(position.x),
			i32(position.y),
			rect_dimensions.x,
			rect_dimensions.y,
			Colors[.Blue],
		)

		rl.EndDrawing()
	}
	rl.CloseWindow()
}
