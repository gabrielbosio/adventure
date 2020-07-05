function doc() {
	return fl.getDocumentDOM();
}

function timeline() {
	return doc().getTimeline();
}

function frames() {
	return timeline().layers[timeline().currentLayer].frames;
}

function currentFrame() {
	return frames()[timeline().currentFrame];
}

function selection() {
	return doc().selection[0];
}

function frameInstance(frame) {
	return currentFrame().elements[frame].libraryItem.timeline.layers[0].frames[frame].elements[0];
}

function frameShape(frame) {
	return frameInstance(frame).libraryItem.timeline.layers[0].frames[frameInstance(frame).firstFrame].elements[0];
}

var border = 10;
var width = 2048;
var spritesLayerName = "Sprites";
var backLayerName = "Back";

doc().exitEditMode();
var frameCount = timeline().frameCount;
timeline().setSelectedLayers(0);
timeline().setSelectedFrames(frameCount, frameCount);
timeline().insertBlankKeyframe();
var lastFrame = timeline().frameCount - 1;
var pivotX = 0;
var pivotY = 0;
var maxHeight = 0;
var docWidth = 0;
var docHeight = 0;
var spritesFile = "sprites = {\n";

timeline().setSelectedFrames(0, 0);
doc().clipCopy();
var instanceFrames = currentFrame().elements[0].libraryItem.timeline.frameCount
timeline().setSelectedFrames(lastFrame, lastFrame);

for (var i = 0; i < instanceFrames; i++) {
	doc().clipPaste();
	selection().firstFrame = i;
	var shape = frameShape(i);
	selection().setTransformationPoint({x: shape.left, y: shape.top});
	selection().transformX = pivotX + border;
	selection().transformY = pivotY + border;
	pivotX = selection().transformX + shape.width;

	if (pivotX >= width) {
		docWidth = Math.max(pivotX + border, docWidth);
		pivotX = 0;
		pivotY += maxHeight + border;
		docHeight += pivotY;
	}

	maxHeight = Math.max(shape.height, maxHeight);
	spritesFile += "\t{" + selection().transformX + ", " +
						 selection().transformY + ", " +
						 shape.width + ", " +
						 shape.height + ", " +
						 (-shape.left) + ", " +
						 (-shape.top) + "},\n";
}

spritesFile += "}"
docHeight += border;
timeline().setSelectedLayers(1);
timeline().setSelectedFrames(lastFrame, lastFrame);
timeline().insertBlankKeyframe();
doc().addNewRectangle({left:0, top:0, right:docWidth, bottom:docHeight}, 0, true);
fl.outputPanel.clear();
fl.trace(spritesFile);
