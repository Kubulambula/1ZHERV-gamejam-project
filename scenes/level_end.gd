extends CanvasLayer


func evaluate_level1(timeout: bool = false):
	if (
		BlackBoard.required_loot_table["Klíče"] and
		BlackBoard.required_loot_table["Peněženka"] and
		BlackBoard.required_loot_table["Telefon"] and
		not timeout
	):
		$Success.visible = true
		$Failure.visible = false
		$RichTextLabel.text = "Stihl jsi koupit mléko dříve, než manželka přijela domů."
		await BlackBoard.any_key_pressed
		BlackBoard.start_level_2()
	else:
		$Success.visible = false
		$Failure.visible = true
		$RichTextLabel.text = "Nedokázal jsi včas najít všechny potřebné předměty na nakoupení mléka."
		await BlackBoard.any_key_pressed
		BlackBoard.start_level_1()


func evaluate_level2(timeout: bool = false):
	if (
		BlackBoard.required_loot_table["Klíče"] and
		BlackBoard.required_loot_table["Peněženka"] and
		BlackBoard.required_loot_table["Telefon"] and
		not timeout
	):
		BlackBoard.required_loot_table.erase("Klíče")
		BlackBoard.required_loot_table.erase("Peněženka")
		BlackBoard.required_loot_table.erase("Telefon")
		var present: String = BlackBoard.required_loot_table.keys()[0]
		if not present.begins_with("ANY_"):
			present = present.substr(19)
			$Success.visible = true
			$Failure.visible = false
			$RichTextLabel.text = "Stihl jsi dojet na babiččinu narozeninovou oslavu.\n"
			match present:
				"Vidlička":
					$RichTextLabel.text += "Babička samotnou vidličku jako dárek moc neocenila."
				"Chleba":
					$RichTextLabel.text += "Babička bochník chleba moc neocenila."
				"Instantní ramen":
					$RichTextLabel.text += "Babička tvůj instantní ramen vůbec neocenila."
				"Talíř":
					$RichTextLabel.text += "Babička samostatný talíř moc neocenila."
				"Toaletní papír":
					$RichTextLabel.text += "Babička toaletní papír jako dárek neocenila. Covidový nedostatek je už dávno pryč."
				"Prášky na spaní":
					$RichTextLabel.text += "Babičce prášky na spaní udělali radost, protože jí zrovna včera její došly."
				"Vodítko na psa":
					$RichTextLabel.text += "Babička vodítko na psa jako dárek neocenila, protože Alík předevčírem umřel."
				"Akční figurka":
					$RichTextLabel.text += "Babička akční figurku, jako dárek moc neocenila."
				"Časopis":
					$RichTextLabel.text += "Babička časopis, jako dárek ocenila. Celou dobu oslavy si vněm listovala."
				"Rodinná fotografie":
					$RichTextLabel.text += "Babička rodinnou fotografii, jako dárek ocenila, hlavně díky vnoučatům."
				"Čaj":
					$RichTextLabel.text += "Babička čaj z termosky, jako dárek moc neocenila."
				"Kafe":
					$RichTextLabel.text += "Babička kafe z termosky, jako dárek moc neocenila."
				"Myš":
					$RichTextLabel.text += "Babička myš jako dárek vůbec neocenila. S jekotem jsi byl z její narozeninové oslavy vyhozen."
				"Plechovka":
					$RichTextLabel.text += "Babička plechovku, jako dárek moc neocenila."
				"Knížka":
					$RichTextLabel.text += "Babička knížku, jako dárek velmi ocenila. Náhodou jsi se trefil do jejího oblíbeného žánru."
				"Křížovka":
					$RichTextLabel.text += "Babička křížovku, jako dárek velmi ocenila."
				"Modlitební knížka":
					$RichTextLabel.text += "Babička modlitebí knížku, jako dárek velmi ocenila."
				"Pohlednice":
					$RichTextLabel.text += "Babička pohlednici, jako dárek ocenila."
				"Fotoalbum":
					$RichTextLabel.text += "Babička fotoalbum, jako dárek velmi ocenila. Fotky vnoučat se hned staly oblíbenými."
				var given:
					$RichTextLabel.text += "Babička %s, jako dárek moc neocenila." % given.to_lower()
			
			await BlackBoard.any_key_pressed
			BlackBoard.start_level_3()
			return
	
	$Success.visible = false
	$Failure.visible = true
	$RichTextLabel.text = "Nedokázal jsi včas najít všechny potřebné předměty na babiččinu narozeninovou oslavu."
	await BlackBoard.any_key_pressed
	BlackBoard.start_level_2()


func evaluate_level3(timeout: bool = false):
	if (
		BlackBoard.required_loot_table["Klíče"] and
		BlackBoard.required_loot_table["Peněženka"] and
		BlackBoard.required_loot_table["Telefon"] and
		not timeout
	):
		BlackBoard.required_loot_table.erase("Klíče")
		BlackBoard.required_loot_table.erase("Peněženka")
		BlackBoard.required_loot_table.erase("Telefon")
		
		var presents: Array = BlackBoard.required_loot_table.keys()
		if presents.any(func(present): return present.begins_with("ANY_")):
			$Success.visible = false
			$Failure.visible = true
			$RichTextLabel.text = "Nedokázal jsi včas najít všechny potřebné předměty na rodinnou vánoční oslavu."
			await BlackBoard.any_key_pressed
			BlackBoard.start_level_3()
			return
		
		$Success.visible = true
		$Failure.visible = false
		$RichTextLabel.text = "Dokázal jsi najít všechny potřebné předměty na rodinnou vánoční oslavu.\n"
		
		for present: String in presents:
			var person = present.substr(10, 6)
			print(person)
			var person_whom: String
			var suffix: String
			present = present.substr(18)
			if person == "bratra":
				person = "Bratr"
				person_whom = "Bratrovi"
				suffix = ""
			elif person == "sestru":
				person = "Sestra"
				person_whom = "Sestře"
				suffix = "a"
			else:
				person = "Tchýně"
				person_whom = "Tchýni"
				suffix = "a"
			
			$RichTextLabel.text += get_reaction(present, person, person_whom, suffix)
			$RichTextLabel.text += "\n"
		await BlackBoard.any_key_pressed
		get_tree().quit()
		return
	
	$Success.visible = false
	$Failure.visible = true
	$RichTextLabel.text = "Nedokázal jsi včas najít všechny potřebné předměty na rodinnou vánoční oslavu."
	await BlackBoard.any_key_pressed
	BlackBoard.start_level_3()


func get_reaction(present: String, person_name: String, whom: String, suffix: String) -> String:
	match present:
		"Vidlička":
			return "%s samotnou vidličku jako dárek moc neocenil%s." % [person_name, suffix]
		"Chleba":
			return "%s bochník chleba moc neocenil%s." % [person_name, suffix]
		"Instantní ramen":
			return "%s tvůj instantní ramen vůbec neocenil%s." % [person_name, suffix]
		"Talíř":
			return "%s samostatný talíř moc neocenil%s." % [person_name, suffix]
		"Toaletní papír":
			return "%s toaletní papír jako dárek neocenil%s. Covidový nedostatek je už dávno pryč." % [person_name, suffix]
		"Prášky na spaní":
			return "%s prášky na spaní udělali radost, protože %s zrovna včera došly." % [whom, "mu" if suffix.is_empty() else "jí"]
		"Vodítko na psa":
			return "%s vodítko na psa jako dárek neocenil%s.." % [person_name, suffix]
		"Akční figurka":
			return "%s akční figurku, jako dárek moc neocenil%s." % [person_name, suffix]
		"Časopis":
			return "%s časopis, jako dárek ocenil%s." % [person_name, suffix]
		"Rodinná fotografie":
			return "%s rodinnou fotografii, jako dárek ocenil%s." % [person_name, suffix]
		"Čaj":
			return "%s čaj z termosky, jako dárek moc neocenil%s." % [person_name, suffix]
		"Kafe":
			return "%s kafe z termosky, jako dárek moc neocenil%s." % [person_name, suffix]
		"Myš":
			return "%s myš jako dárek vůbec neocenil%s. S jekotem jsi byl z oslavy vyhozen." % [person_name, suffix]
		"Plechovka":
			return "%s plechovku, jako dárek moc neocenil%s." % [person_name, suffix]
		"Knížka":
			return "%s knížku, jako dárek velmi ocenil%s." % [person_name, suffix]
		"Křížovka":
			return "%s křížovku, jako dárek velmi ocenil%s." % [person_name, suffix]
		"Modlitební knížka":
			return "%s modlitebí knížku, jako dárek velmi ocenil%s." % [person_name, suffix]
		"Pohlednice":
			return "%s pohlednici, jako dárek ocenil%s." % [person_name, suffix]
		"Fotoalbum":
			return "%s fotoalbum, jako dárek velmi ocenil%s." % [person_name, suffix]
		var given:
			return "%s %s, jako dárek moc neocenil%s." % [person_name, given.to_lower(), suffix]
	
