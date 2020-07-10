function checkIfOpen(name)
{
	for (var i = 0; i < fl.documents.length; i++) {
		var doc = fl.documents[i]
		if (doc.name == name)
			break;
		doc = undefined;
	}
	if (!doc) {
		var question = '"' + name + '" not open!\nWould you like to open it?';
		var keepGoing = confirm(question);
		if (keepGoing) {
			var file = fl.browseForFileURL("open", 'Look for ' + name);
			var nameIndex = file.lastIndexOf(name);
			if (nameIndex != -1 && file.substring(nameIndex, file.length) == name)
				var doc = fl.openDocument(file);
			else
				alert('Filename does not equal "' + name + '"!');
		}
	}
	return doc;
}


function labelledFrames(doc)
{
	var result = [];
	doc.editScene(0);
	doc.selectNone();
	var layers = doc.getTimeline().layers;
	for (var i = 0; i < layers.length; i++) {
		var frames = layers[i].frames;
		for (var j = 0; j < frames.length; j++)
			if (frames[j].name != "")
				result.push(frames[j]);
	}
	if (result.length == 0)
		alert("No frame labels found. There must be at least one frame with a label"
			  + " in the timeline.");

	return result;
}


function graphicsAndClips(frames)
{
	if (frames.length > 0) {
		var result = {};
		var symbolsFound = false;
		for (var i = 0; i < frames.length; i++) {
			var frame = frames[i];
			var elements = frame.elements;
			var symbols = {};
			for (var j = 0; j < elements.length; j++) {
				var element = elements[j];
				if (element.symbolType != "graphic" && element.symbolType != "movie clip")
					continue;
				var name = element.libraryItem.name;
				var nameIndex = name.lastIndexOf("/");
				if (nameIndex == -1) {
					alert("Your library has missing folders!");
					return;
				}
				var groupName = name.substring(0, nameIndex);
				var name = name.substring(nameIndex + 1);
				if (symbols[groupName]) {
					var group = symbols[groupName];
					if (group[name])
						group[name].push(element);
					else
						group[name] = [element];
				} else {
					symbols[groupName] = {};
					symbols[groupName][name] = [element];
				}
				symbolsFound = true;
			}
			result[frame.name] = symbols;
		}
		if (symbolsFound)
			return result;
		else
			alert('No graphics or movie clips in "' + doc.getTimeline().name +'"');
	}
}


function roundNumeric(array)
{
	result = array;
	for (var i = 0; i < array.length; i++) {
		if (!isNaN(array[i]))
			result[i] = Math.round(array[i]*100)/100;
	}

	return result;
}


function getDataFromInstance(groupName, elementName, element)
{
	var result = [];
	switch (groupName) {
		case "terrain":
			var w = element.width;
			var h = element.height;
			var m = element.matrix;
			var flippedHorizontally = m.a < 0;
			var x = m.tx;
			var y = m.ty;
			switch(elementName) {
				case "boundaries":
					result.push(x - w/2, y - h/2, x + w/2, y + h/2);
					break
				case "clouds":
					result.push(x - w/2, y, x + w/2);
					break
				case "slopes":
					if (flippedHorizontally)
						result.push(x + w, y, x, y - h);
					else
						result.push(x - w, y, x, y - h);
					break
			}
			break
		case "entitiesData":
			result.push(element.matrix.tx, element.matrix.ty);
			switch(elementName) {
				case "goals":
					result.push('"' + element.name + '"');
					break
				case "medkits":
				case "player":
				case "pomodori":
					break
			}
			break
	}

	return roundNumeric(result);
}


function generateFrom(symbols, frames)
{
	if (symbols) {
		var now = new Date();
		var content = "--[[\n"
					+ "     This file was automatically generated\n"
					+ "      (on " + now + ").\n"
					+ "     You shouldn't edit this file.\n"
					+ "     Any change you make here could be overwritten.\n"
					+ "  ]]\n"
					+ 'local M = {}\n\n\n'
					+ "M.level = {\n";
		for (var levelName in symbols) {
			content += '  ["' + levelName + '"] = {\n';
			var level = symbols[levelName];
			for (var groupName in level) {
				content += "    " + groupName + " = {\n";
				var group = level[groupName];
				for (var elementName in group) {
					var elements = group[elementName];
					content += "      " + elementName + " = {\n";
					for (var i = 0; i < elements.length; i++) {
						var element = elements[i];
						var data = getDataFromInstance(groupName, elementName, element);
						content += "        {";
						for (var j = 0; j < data.length; j++) {
							content += data[j];
							if (j < data.length-1)
								content += ", ";
						}
						content += "},\n";
					}
					content += "      },\n";
				}
				content += "    },\n";
			}
			content += "  },\n";
		}
		content += "}\n\n";
		content += 'M.first = "' + frames[0].name + '"\n';
    content += '\nreturn M\n'

		return content
	}
}


function uriFrom(path)
{
	var uri = "";
	for (var i = 0; i < path.length; i++) {
		var value = path[i]
		newValue = value;
		switch(value) {
			case ":":
				newValue = "|";
				break;
			case "\\":
				newValue = "/";
				break;
		}
		uri += newValue;
	}
	return "file:///" + uri;
}


var doc = checkIfOpen("levels.fla");
if (doc) {
	var frames = labelledFrames(doc);
	var symbols = graphicsAndClips(frames);
	var fileContent = generateFrom(symbols, frames);
	if (fileContent) {
		var path = doc.path;
		var newPath = path.substring(0, path.lastIndexOf(".fla")) + ".lua";
		if (FLfile.write(uriFrom(newPath), fileContent))
			alert("File saved in " + newPath);
		else
			alert("File could not be saved in " + newPath);
	}
}