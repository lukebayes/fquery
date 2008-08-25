package {
	import flash.display.Stage;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import fquery.errors.FQueryError;
	import fquery.collection.DisplayListIterator;
	import fquery.reflect.Reflection;
	
	dynamic public class FQuery {
		public static var stage:Stage;

		private var found:Array;
		private var context:DisplayObjectContainer;
		
		public function FQuery(query:*=null, context:*=null) {
			found = new Array();
			validateContext(query, context);
			executeQuery(query);
		}
		
		private function validateContext(query:*, context:*):void {
			if(query is Stage) {
				stage = query;
			}

			if(context is Stage) {
				stage = context;
			}
			
			if(query is DisplayObjectContainer && context == null) {
				context = query;
			}
			
			if(stage == null && context == null && query == null) {
				throw new FQueryError("FQuery has no context, either send in a context by reference with your query like $(anyDisplayObjectContainer) or $('Sprite', anyDisplayObjectContainer), or at some earlier point in time, send in the reference to Stage from your Document Root like $(stage)");
			}
			
			this.context =  context || stage;
		}
		
		private function executeQuery(query:*):void {
			if(query is Array) {
				found = query as Array;
			}
			else if(query is String) {
				executeQueryString(query);
			}
			else if(query is DisplayObject) {
				found.push(query);
			}
			else if(query == null) {
				// do nothing?
			}
			else {
				trace(">> Not yet implemented query: " + query);
			}
		}
		
		private function executeQueryString(query:String):void {
			if(query.match(/^\./)) {
				searchByStyleName(query);
			}
			else {
				searchByClass(query);
			}
		}

		private function searchByStyleName(clazz:String):void {
			var itr:DisplayListIterator = new DisplayListIterator(context);
			var item:Object;
			while(itr.hasNext()) {
				item = itr.next();
				if(hasClass(clazz, item)) {
					found.push(item);
				}
			}
		}
		
		public function hasClass(style:String, item:Object=null):Boolean {
			style = style.replace(/^\./, '');
			var len:Number;
			var i:Number;
			if(item != null && item.styles && item.styles.length > 0) {
				len = item.styles.length;
				for(i = 0; i < len; i++) {
					if(item.styles[i] == style) {
						return true;
					}
				}
			}
			else {
				len = found.length;
				for(i = 0; i < len; i++) {
					if(!hasClass(style, found[i])) {
						return false;
					}
				}
				return true;
			}
			return false;
		}
		
		private function searchByClass(clazz:String):void {
			var itr:DisplayListIterator = new DisplayListIterator(context);
			var item:Object;
			while(itr.hasNext()) {
				item = itr.next();
				if(isA(item, clazz)) {
					found.push(item);
				}
			}
		}
		
		private function isA(item:Object, clazz:String):Boolean {
			var reflection:Reflection = Reflection.create(item);
			var types:Array = reflection.types;
			var len:Number = types.length;
			for(var i:Number = 0; i < len; i++) {
				if(types[i].match(clazz + '$')) {
					return true;
				}
			}
			return false;
		}
		
		/*
		 * Iterate over the found items, calling handler with 
		 * each index and item.
		 */
		public function each(handler:Function):void {
			var len:Number = length;
			for(var i:Number = 0; i < len; i++) {
				handler(i, get(i));
			}
		}
		
		/*
		 * Set the global stage reference
		 */
		public function set stage(stage:Stage):void {
			FQuery.stage = stage;
		}
		
		/*
		 * Retrieve the global stage reference
		 */
		public function get stage():Stage {
			return FQuery.stage;
		}
		
		/*
		 * Retrieve the display list element by index
		 */
		public function get(index:int):* {
			return found[index];
		}
		
		/*
		 * The number of elements found with this query
		 */
		public function get length():int {
			return found.length;
		}
	}
}
