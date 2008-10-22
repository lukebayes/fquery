package  {

	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import asunit.errors.AssertionFailedError;

	public class FQueryTest extends TestCase {

		public function FQueryTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			$(getContext().stage);
			super.setUp();
		}

		override protected function tearDown():void {
			super.tearDown();
		}
		
		// Ensure that we can instantiate fQuery with no args
		public function testEmptySelector():void {
			var result:FQuery = $();
			assertNotNull("An empty selector should not throw", result);
		}
		
		// Ensure the stage was provided
		public function testStageProvidedBySetUp():void {
			var result:FQuery = $();
			assertSame("An empty selector should wrap Stage", getContext().stage, result.stage);
		}
		
		// Any query should throw if there is no context AND no global stage provided
		public function testNoStageProvidedAndNullStage():void {
			$().stage = null;
			try {
				$();
				fail("FQuery should fail if no context and no stage");
			}
			catch(e:Error) {
				// Forward the failure if encountered
				if(e is AssertionFailedError) {
					throw e;
				}
			}
		}

		// The result has no children, but should not throw
		public function testContextProvidedWithNullStage():void {
			$().stage = null;
			var parent:Sprite = new Sprite();
			var result:FQuery = $('Sprite', parent);
			assertEquals(0, result.length);
		}
		
		public function testContextProvidedAsQueryWithNullStage():void {
			$().stage = null;
			var sprite:Sprite = new Sprite();
			var result:FQuery = $(sprite);
			assertEquals(1, result.length);
		}
		
		public function testSpriteReferenceSelector():void {
			var sprite:Sprite = new Sprite();
			var result:FQuery = $(sprite);
			assertNotNull(result);
			assertSame(result.get(0), sprite);
		}
		
		public function testAllDisplayObjects():void {
			var result:FQuery = $('DisplayObject');
			assertEquals(4, result.length);
		}
		
		public function testStyleName():void {
			var parent:Sprite = new Sprite();
			var child:MovieClip = new MovieClip();
			child.styles = 'custom';
			parent.addChild(child);

			var result:FQuery = $('.custom', parent);
			assertEquals(1, result.length);
		}
		
		public function testStyleNameMore():void {
			var parent:Sprite = new Sprite();
			var child1:MovieClip = new MovieClip();
			child1.styles = 'custom';
			parent.addChild(child1);

			var child2:MovieClip = new MovieClip();
			child2.styles = 'custom unique';
			parent.addChild(child2);
			
			var result:FQuery = $('.custom', parent);
			assertEquals(2, result.length);
			
			result = $('.unique', parent);
			assertEquals(1, result.length);
		}
		
		public function testDisplayObjectQuery():void {
			var child:MovieClip = new MovieClip();
			assertTrue( $(child) is FQuery );
		}
		
		public function testHasClass():void {
			var child:MovieClip = new MovieClip();
			child.styles = 'custom';
			var result:Boolean = $(child).hasClass('custom');
			assertTrue('Child should have custom class', result);
		}
		
		public function testEachWithArray():void {
			var found:Array = new Array();
			$(['a', 'b', 'c']).each(function(index:Number, item:String):void {
				found.push({index:index, item:item});
			});

			assertEquals('a', found[0].item);
			assertEquals('b', found[1].item);
			assertEquals('c', found[2].item);
		}
		
		public function testEachWithFQuery():void {
			var result:FQuery = $('Sprite');
			var count:int;
			$(result).each(function(index:Number, item:Sprite):void {
				count++;
			});
			assertEquals(3, count);
		}
		
		public function testSearchByClass():void {
			var parent:Sprite = new Sprite();
			var child1:MovieClip = new MovieClip();
			var child2:MovieClip = new MovieClip();
			parent.addChild(child1);
			parent.addChild(child2);
			
			var result:FQuery = $('MovieClip', parent);
			assertEquals(2, result.length);
		}
		
		public function testFQueryContext():void {
			var parent:Sprite = new Sprite();
			var child1:MovieClip = new MovieClip();
			var child2:MovieClip = new MovieClip();
			parent.addChild(child1);
			parent.addChild(child2);
			
			var result:FQuery = $(parent);
			assertEquals(1, result.length);
			
			result = $('MovieClip', result);
			assertEquals(2, result.length);
		}
		
		public function testCompoundSelector():void {
			var parent:Sprite = new Sprite();
			var child1:MovieClip = new MovieClip();
			var child2:MovieClip = new MovieClip();
			var child3:MovieClip = new MovieClip();
			var child4:MovieClip = new MovieClip();
			parent.addChild(child1);
			parent.addChild(child4);

			child1.addChild(child2);
			child1.addChild(child3);

			child1.styles = 'custom';
			child3.styles = 'other';
			child4.styles = 'other'; // This clip should not be in result
			
			var found:FQuery = $('.custom MovieClip', parent);
			assertEquals("There are 2 MovieClips beneath the custom child", 2, found.length);
			
			found = $('.custom .other', parent);
			assertEquals("There is one item with 'other' beneath the custom child", 1, found.length);
			
			found = $('.other', parent);
			assertEquals("There are 2 other clips in the tree", 2, found.length);
		}
		
		public function testSelectById():void {
			var parent:Sprite = new Sprite();
			var child1:MovieClip = new MovieClip();
			var child2:MovieClip = new MovieClip();
			child1.id = 'some-child';
			parent.addChild(child1);
			parent.addChild(child2);
			
			var result:FQuery = $(parent).find('#some-child');
			assertEquals(1, result.length);
		}
		
		public function testAppend():void {
			var parent:Sprite = new Sprite();
			var result:FQuery = $(parent).append('<fl:Sprite xmlns:fl="flash.display.*" id="my-child" name="myChild" />');
			assertEquals(1, result.length);
		}
	}
}