package fquery.collection {
	import flash.display.DisplayObjectContainer;
	
	public class DisplayObjectIterator implements Iterator {
		protected var context:DisplayObjectContainer;
		protected var index:int;
		
		public function DisplayObjectIterator(context:DisplayObjectContainer) {
			this.context = context;
		}

		public function next():Object {
			return context.getChildAt(index++);
		}
		
		public function hasNext():Boolean {
			return index < context.numChildren;
		}
		
		public function reset():void {
			index = 0;
		}
		
	}
}
