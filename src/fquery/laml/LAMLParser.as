package fquery.laml {
	import flash.utils.getDefinitionByName;
	
	import flash.display.Sprite;
	
	public class LAMLParser {
		
		public function parse(node:*, context:*=null):Object {
			var xml:XML = cleanNode(node);
			var clazz:Class = getDefinitionByName(xml.name()) as Class;
			var instance:Object = new clazz();
			parseAttributes(instance, xml);
			parseChildren(xml, context);
			return instance;
		}
		
		private function parseChildren(xml:XML, context:*=null):void {
			var children:XMLList = xml.children();
			var child:Object;
			for each(child in children) {
				
			}
		}
		
		private function parseAttributes(instance:Object, node:XML):void {
			var attr:Object;
			for each(attr in node.@*) {
				instance[attr.name().toString()] = attr;
			}
		}
		
		private function cleanNode(node:*):XML {
			if(node is XML) {
				return node;
			}
			else {
				return new XML(node);
			}
		}
	}
}
