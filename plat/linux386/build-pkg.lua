include("plat/build.lua")

ackfile {
	name = "boot",
	srcs = { "./boot.s" },
	vars = { plat = "linux386" }
}

build_plat_libs {
	name = "libs",
	arch = "i386",
	plat = "linux386",
}

installable {
	name = "pkg",
	map = {
		"+tools",
		"+libs",
		["$(PLATIND)/linux386/boot.o"] = "+boot"
	}
}

