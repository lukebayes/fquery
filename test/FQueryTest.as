package  {

	import asunit.framework.TestCase;
	import flash.display.Sprite;
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

		// Ensure that we can instantiate FQuery with no args
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
			assertEquals(1, result.length);
		}
	}
}