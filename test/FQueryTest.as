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
			var query:FQuery = $();
			assertNotNull("An empty selector should not throw", query);
		}
		
		// Ensure the stage was provided
		public function testStageProvided():void {
			var query:FQuery = $();
			assertSame("An empty selector should wrap Stage", getContext().stage, query.get(0));
		}
		
		public function testNoStageProvided():void {
			$().stage = null;
			try {
				$();
				fail("FQuery should fail if no context and no stage");
			}
			catch(e:Error) {
				if(e is AssertionFailedError) {
					throw e;
				}
			}
		}
		
//		public function testSpriteSelector():void {
//			var sprite:Sprite = new Sprite();
//			var query:FQuery = $(sprite);
//			assertNotNull(query);
//			assertSame(sprite, query.get(0));
//		}
	}
}