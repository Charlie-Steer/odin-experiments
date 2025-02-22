package main

import "core:fmt"
import "core:io"
import "core:math/rand"
import "core:os"
import "core:strconv"

record_filename := "record.txt"
min := 1
max := 100

main :: proc() {
	target := rand.int_max(max) + min

	fmt.printfln("Guess a number between %d and %d!", min, max)
	record, record_ok := read_record()
	if record_ok {
		plural := record == 1 ? "" : "s"
		fmt.printfln("\nRecord: %d attempt%s.", record, plural)
		fmt.println("Write \"reset\" to delete your record.")
	}
	fmt.println("\nPress <Enter> to start.")

	buffer: [256]u8

	n_read, err := os.read(os.stdin, buffer[:])
	if err != nil {
		fmt.eprintln("Error: Couldn't read input.")
		os.exit(1)
	}

	str := string(buffer[:n_read - 1])
	if str == "reset" || str == "clear" {
		err := os.remove(record_filename)
		if err == nil {
			fmt.println("RESET RECORD")
		}
	}

	attempts := 1
	for i := 0;; i += 1 {
		fmt.printf("%d > ", attempts)
		n_read, err := os.read(os.stdin, buffer[:])
		if err != nil {
			fmt.eprintln("Error: Couldn't read input.")
			os.exit(1)
		}

		str := string(buffer[:n_read - 1])

		guess, number_ok := strconv.parse_int(str)
		if !number_ok {
			fmt.println("Only numbers, please!")
		} else if guess < min || guess > max {
			fmt.println("Invalid number! Only from %d to %d.", min, max)
		} else if guess < target {
			fmt.println("Too low!")
			attempts += 1
		} else if guess > target {
			fmt.println("Too high!")
			attempts += 1
		} else if guess == target {
			fmt.printfln("The answer was %d!", target)
			fmt.printfln("You won in %d guesses!", attempts)
			if !os.exists(record_filename) {
				update_record(attempts)
			} else if record, ok := read_record(); ok && attempts < record {
				fmt.printfln("NEW RECORD!: %d", attempts)
				update_record(attempts)
			}
			os.exit(0)
		} else do assert(false)
	}
}

read_record :: proc() -> (record: int, ok: bool) {
	buf := os.read_entire_file_from_filename(record_filename, context.temp_allocator) or_return
	record = strconv.parse_int(string(buf)) or_return

	return record, true
}

update_record :: proc(attempts: int) {
	buf: [64]u8
	str := strconv.itoa(buf[:], attempts)

	ok := os.write_entire_file(record_filename, transmute([]u8)str)
	if ok do fmt.println("RECORD UPDATED")
	else do fmt.eprintln("Error: Couldn't update record.")
}
