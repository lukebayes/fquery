package fquery.laml {
	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.DisplayObject;

	public class LAMLParserTest extends TestCase {
		private var parser:LAMLParser;

		public function LAMLParserTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			parser = new LAMLParser();
		}

		override protected function tearDown():void {
			super.tearDown();
			parser = null;
		}

		public function testInstantiated():void {
			assertTrue("parser is LAMLParser", parser is LAMLParser);
		}

		public function testParseSprite():void {
			var sprite:Sprite = parser.parse('<flash.display.Sprite />') as Sprite;
			assertTrue(sprite is Sprite);
		}
		
		public function testParseDisplayObject():void {
			var item:DisplayObject = parser.parse('<flash.display.MovieClip />') as Sprite;
			assertTrue(item is DisplayObject);
		}
		
		public function testParseXMLSprite():void {
			var xml:XML = new XML('<flash.display.Sprite />');
			var sprite:Sprite = parser.parse(xml) as Sprite;
			assertTrue(sprite is Sprite);
		}
		
		public function testParseWithNamespace():void {
			var sprite:Sprite = parser.parse('<fl:Sprite xmlns:fl="flash.display" />') as Sprite;
			assertTrue(sprite is Sprite);
		}
		
		public function testParseParams():void {
			var item:MovieClip = parser.parse('<fl:MovieClip xmlns:fl="flash.display" id="some-clip" styles="custom unique" />') as MovieClip;
			assertTrue(item is DisplayObject);
			assertEquals('some-clip', item.id);
		}
		
		public function testParseChildren():void {
			var item:MovieClip = parser.parse('<fl:MovieClip xmlns:fl="flash.display" id="some-clip" styles="custom unique"><fl:MovieClip id="child-clip" /></fl:MovieClip>') as MovieClip;
			assertTrue(item is DisplayObject);
			assertEquals('some-clip', item.id);
			assertEquals(1, item.numChildren);
		}
	}
}