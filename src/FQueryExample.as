package {
	import flash.display.Sprite;
	
	public class FQueryExample extends Sprite {
		
		public function FQueryExample() {
			var sprite:Sprite = new Sprite();
			addChild(sprite);

			$('Sprite', stage).each(function(index:Number, item:Sprite):void {
				trace("child called with: " + index + " item: " + item);
			});
		}
	}
}
