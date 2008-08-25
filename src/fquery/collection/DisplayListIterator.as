package fquery.collection {
	import flash.display.DisplayObjectContainer;
	import flash.display.DisplayObject;
	import fquery.errors.FQueryError;
	
	public class DisplayListIterator implements Iterator {
		private var context:DisplayObjectContainer;
		
		private var currentIterator:DisplayObjectIterator;
		private var currentItem:Object;
		private var parents:Array;
		
		public function DisplayListIterator(context:DisplayObjectContainer) {
			this.context = context;
			parents = new Array();
			currentIterator = createCurrentIterator(context);
		}

		public function hasNext():Boolean {
			return (currentIterator.hasNext() || currentItem && currentItem.numChildren > 0 || hasNextFromParents());
		}
		
		public function reset():void {
			throw new FQueryError('Reset not yet implemented');
		}
		
		public function next():Object {
			if(shouldStepIn()) {
				currentItem = stepIn();
			}
			else if(shouldStepOut()) {
				currentItem = stepOut();
			}
			else if(shouldContinue()) {
				currentItem = currentIterator.next();
			}
			
			return currentItem;
		}
		
		private function hasNextFromParents():Boolean {
			var len:Number = parents.length;
			for(var i:Number = 0; i < len; i++) {
				if(parents[i].hasNext()) {
					return true;
				}
			}
			return false;
		}
		
		private function shouldStepIn():Boolean {
			return (currentItem is DisplayObjectContainer && currentItem.numChildren > 0);
		}
		
		private function stepIn():Object {
			parents.push(currentIterator);
			currentIterator = createCurrentIterator(currentItem as DisplayObjectContainer);
			return currentIterator.next();
		}
		
		private function shouldStepOut():Boolean {
			return (parents.length > 0 && !currentIterator.hasNext())
		}
		
		private function stepOut():Object {
			currentIterator = parents.pop() as DisplayObjectIterator;
			while(!currentIterator.hasNext() && parents.length > 0) {
				currentIterator = parents.pop();
			}
			if(currentIterator.hasNext()) {
				return currentIterator.next();
			}
			return null;
		}
		
		private function shouldContinue():Boolean {
			return currentIterator.hasNext();
		}
		
		protected function createCurrentIterator(context:DisplayObjectContainer):DisplayObjectIterator {
			return new DisplayObjectIterator(context);
		}
	}
}
