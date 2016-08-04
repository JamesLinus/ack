vars.cflags = {
	"-g", "-O"
}
vars.ackcflags = {
	"-O"
}
vars.plats = {
	"pc86"
}

installable {
	name = "ack",
	map = {
		"lang/cem/cemcom.ansi+pkg",
		"util/ack+pkg",
		"util/amisc+pkg",
		"util/arch+pkg",
		"util/misc+pkg",
		"plat/pc86+pkg",
	}
}
