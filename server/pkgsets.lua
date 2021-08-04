local pkgsets = pkgsets or {}

pkgsets.pkgsets = {
	{name = "base", name_human = "Base", vital = true},
	{name = "kernel", name_human = "Kernel", vital = true},
	{name = "debug", name_human = "Debug"},
	{name = "lib32", name_human = "Lib32"},
	{name = "development", name_human = "Development"},
}

return pkgsets 
