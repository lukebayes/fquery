package fquery.collection {

	import asunit.framework.TestCase;
	import flash.display.Sprite;

	public class DisplayListIteratorTest extends TestCase {

		public function DisplayListIteratorTest(methodName:String=null) {
			super(methodName);
		}

		public function testNoChildren():void {
			var sprite:Sprite = new Sprite();
			var itr:Iterator = new DisplayListIterator(sprite);
			assertFalse(itr.hasNext());
		}
		
		public function testWithAChild():void {
			var sprite:Sprite = new Sprite();
			var child:Sprite = new Sprite();
			sprite.addChild(child);
			var itr:Iterator = new DisplayListIterator(sprite);
			assertTrue("Iterator should have a child", itr.hasNext());
			var result:Object = itr.next();
			assertSame(result, child);
			assertFalse(itr.hasNext());
		}
		
		public function testDeepPath():void {
			var sprite:Sprite = new Sprite();
			sprite.name = 'Parent';
			var child1:Sprite = new Sprite();
			child1.name = 'child1';
			var child2:Sprite = new Sprite();
			child2.name = 'child2';
			var child3:Sprite = new Sprite();
			child3.name = 'child3';
			var child4:Sprite = new Sprite();
			child4.name = 'child4';
			
			sprite.addChild(child1);
			child1.addChild(child2);
			child2.addChild(child3);
			child3.addChild(child4);
			
			var itr:DisplayListIterator = new DisplayListIterator(sprite);
			assertTrue('a', itr.hasNext());
			assertEquals('b', 'child1', itr.next().name);
			
			assertTrue('c', itr.hasNext());
			assertEquals('d', 'child2', itr.next().name);
			
			assertTrue('e', itr.hasNext());
			assertEquals('f', 'child3', itr.next().name);

			assertTrue('g', itr.hasNext());
			assertEquals('h', 'child4', itr.next().name);

			assertFalse('i', itr.hasNext());
		}

		public function testSingleDepth():void {
			var sprite:Sprite = new Sprite();
			var child1:Sprite = new Sprite();
			var child1_1:Sprite = new Sprite();
			var child1_2:Sprite = new Sprite();
			var child2:Sprite = new Sprite();

			sprite.addChild(child1);
			child1.addChild(child1_1);
			child1.addChild(child1_2);
			sprite.addChild(child2);

			var itr:DisplayListIterator = new DisplayListIterator(sprite);

			var result:Object;

			assertTrue(itr.hasNext());
			result = itr.next();
			assertSame("First child should be returned", result, child1);

			assertTrue("First child down should be available", itr.hasNext());
			assertSame("First child down should be same", child1_1, itr.next());
			
			assertTrue("Second child down should be available", itr.hasNext());
			assertSame("Second child down should be same", child1_2, itr.next());
			
			assertTrue("First sibling should be available", itr.hasNext());
			assertSame("First sibling should be same", child2, itr.next());
			
			assertFalse("There should be no more", itr.hasNext());
		}
	}
}
