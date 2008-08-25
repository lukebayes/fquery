package fquery.collection {

	import asunit.framework.TestCase;
	import flash.display.Sprite;

	public class DisplayObjectIteratorTest extends TestCase {

		public function DisplayObjectIteratorTest(methodName:String=null) {
			super(methodName)
		}

		public function testNoChildren():void {
			var sprite:Sprite = new Sprite();
			var itr:Iterator = new DisplayObjectIterator(sprite);
			assertFalse(itr.hasNext());
		}
		
		public function testWithAChild():void {
			var sprite:Sprite = new Sprite();
			var child:Sprite = new Sprite();
			sprite.addChild(child);
			var itr:Iterator = new DisplayObjectIterator(sprite);
			assertTrue("Iterator should have a child", itr.hasNext());
			var result:Object = itr.next();
			assertSame(result, child);
			assertFalse(itr.hasNext());
		}
	}
}