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
		
		public function FQuery(query:*=null, context:*=null) {
			found = beginExecuteQuery(query, context);
		}
		
		private function beginExecuteQuery(query:*, context:*):Array {
			if(query is FQuery) {
				return searchWithFQueryQuery(query);
			}
			
			if(context is FQuery) {
				return searchWithFQueryContext(query, context);
			}
			
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
			
			return finishExecuteQuery(query, context || stage);
		}
		
		private function finishExecuteQuery(query:*, context:*):Array {
			if(query is Array) {
				return query as Array;
			}
			else if(query is String) {
				return executeQueryString(query, context);
			}
			else if(query is DisplayObject) {
				return [query];
			}
			else if(query == null) {
				// do nothing?
				return [];
			}
			return null;
		}
		
		private function searchWithFQueryQuery(query:FQuery):Array {
			var found:Array = new Array();
			var len:Number = query.length;
			for(var i:Number = 0; i < len; i++) {
				found.push(query.get(i));
			}
			return found;
		}
		
		private function searchWithFQueryContext(query:*=null, context:*=null):Array {
			var found:Array = new Array();
			var len:Number = context.length;
			var result:Array;
			for(var i:Number = 0; i < len; i++) {
				result = beginExecuteQuery(query, context.get(i));
				result.forEach(function(item:Object, index:Number, arr:Array):void {
					found.push(item);
				});
			}
			return found;
		}
		
		private function executeQueryString(query:String, context:*):Array {
			if(query.indexOf(' ') > -1) {
				var parts:Array = query.split(' ');
				var result:FQuery = $(parts.shift(), context);
				$(parts).each(function(index:Number, part:String):void {
					// Step into each result passing it as the context,
					// return only the deepest result - if any
					result = $(part, result);
				});
				var found:Array = new Array();
				result.each(function(index:Number, result:Object):void {
					found.push(result);
				});
				return found;
			}
			else if(query.match(/^#/)) {
				return searchById(query, context);
			}
			else if(query.match(/^\./)) {
				return searchByStyleName(query, context);
			}
			else {
				return searchByDefinition(query, context);
			}
		}

		private function searchById(id:String, context:*):Array {
			id = id.replace(/^#/, '');
			var itr:DisplayListIterator = new DisplayListIterator(context);
			var item:Object;
			while(itr.hasNext()) {
				item = itr.next();
				if(item.id == id) {
					return [item];
				}
			}
			return [];
		}

		private function searchByStyleName(clazz:String, context:*):Array {
			var found:Array = new Array();
			var itr:DisplayListIterator = new DisplayListIterator(context);
			var item:Object;
			while(itr.hasNext()) {
				item = itr.next();
				if(hasClass(clazz, item, found)) {
					found.push(item);
				}
			}
			return found;
		}
		
		public function hasClass(style:String, item:Object=null, found:Array=null):Boolean {
			style = style.replace(/^\./, '');
			var i:int;
			var len:int;
			
			if(item != null && item.styles) {
				if(item.styles is String) {
					// Update the styles string to something more easily
					// managed and searched
					var parts:Array = item.styles.split(' ');
					item.styles = {};
					while(parts.length > 0) {
						item.styles[parts.shift()] = true;
					}
				}
				
				if(item.styles[style]) {
					return true;
				}
			}
			
			if(item == null && found == null) {
				found = this.found;
			}
			if(found == null) {
				found = [];
			}
			len = found.length;
			for(i = 0; i < len; i++) {
				if(found[i] !== item && !hasClass(style, found[i])) {
					return false;
				}
			}

			return (found.length > 0);
		}
		
		private function searchByDefinition(clazz:String, context:*):Array {
			var found:Array = new Array();
			var itr:DisplayListIterator = new DisplayListIterator(context);
			var item:Object;
			while(itr.hasNext()) {
				item = itr.next();
				if(isA(item, clazz)) {
					found.push(item);
				}
			}
			return found;
		}
		
		private function isA(item:Object, clazz:String):Boolean {
			var reflection:Reflection = Reflection.create(item);
			if(typeMatchesString(reflection.name, clazz)) {
				return true;
			}
			var types:Array = reflection.types;
			var len:Number = types.length;
			for(var i:Number = 0; i < len; i++) {
				if(typeMatchesString(types[i], clazz)) {
					return true;
				}
			}
			return false;
		}
		
		private function typeMatchesString(type:String, str:String):Boolean {
			return type.match(str + '$') != null;
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
		
		public function find(selector:String):FQuery {
			return $(selector, this);
		}
		
		public function append(str:String):FQuery {
			var parsed:DisplayObject = parseLAML(str) as DisplayObject;
			if(parsed) {
				for(var i:Number = 0; i < length; i++) {
					get(i).addChild(parsed);
				}
				return $(parsed);
			}
			return null;
		}
		
		private function parseLAML(str:String):Object {
			var xml:XML = new XML(str);
			trace("laml: " + xml);
			var result:Object = new flash.display.Sprite();
			return result;
		}
	}
}
