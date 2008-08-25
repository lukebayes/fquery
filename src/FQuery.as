package {
	import flash.display.Stage;
	import flash.display.DisplayObjectContainer;
	import fquery.errors.FQueryError;
	
	dynamic public class FQuery {
		public static var stage:Stage;

		private var context:DisplayObjectContainer;
		
		public function FQuery(query:*=null, context:*=null) {
			context = validateContext(query, context);
		}
		
		private function validateContext(query:*, context:*):DisplayObjectContainer {
			if(stage == null) {
				if(query is Stage) {
					stage = query;
				}
				else if(context is Stage) {
					stage = context;
				}
			}
			
			if(stage == null && context == null && query == null) {
				throw new FQueryError("FQuery has no context, either send in a context by reference with your query like: $('Sprite', anyDisplayObjectContainer), or send in the reference to Stage from your Document Root like $(stage)");
			}
			
			return stage;
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
			return FQuery.stage;
		}
		
		/*
		 * The number of elements found with this query
		 */
		public function get length():int {
			return 1;
		}
	}
}
