(function(window) {
Megasapi_For_Export_instance_1 = function() {
	this.initialize();
}
Megasapi_For_Export_instance_1._SpriteSheet = new SpriteSheet({images: ["megasapi.png"], frames: [[1,1,158,282,0,71.35,279.2],[159,1,155,264, 0,70.35,260.2],[314,1,142,285,  0  ,47.349999999999994,282.2],[456,1,154,286,0,59.349999999999994,283.2],[610,1,174,287,0,79.35,285.2],[784,1,187,288,0,92.35,283.2],[1,289,174,289,0,78.35,282.2],[175,289,143,292,0,47.349999999999994,282.2],[318,289,141,293,0,45.349999999999994,283.2],[459,289,170,293,0,75.35,285.2],[629,289,183,286,0,87.35,283.2],[812,289,191,290,0,95.35,282.2],[1,582,160,292,0,64.35,282.2],[161,582,162,290,0,67.35,284.2],[323,582,166,280,0,71.35,284.2],[489,582,192,246,0,91.35,277.2],[681,582,236,170,0,118.35,225.2],[1,874,294,104,0,157.35,62.19999999999999],[295,874,169,287,0,55.349999999999994,280.2],[464,874,194,277,0,65.35,274.2]]});
var Megasapi_For_Export_instance_1_p = Megasapi_For_Export_instance_1.prototype = new BitmapAnimation();
Megasapi_For_Export_instance_1_p.BitmapAnimation_initialize = Megasapi_For_Export_instance_1_p.initialize;
Megasapi_For_Export_instance_1_p.initialize = function() {
	this.BitmapAnimation_initialize(Megasapi_For_Export_instance_1._SpriteSheet);
	this.paused = false;
}
window.Megasapi_For_Export_instance_1 = Megasapi_For_Export_instance_1;
}(window));

