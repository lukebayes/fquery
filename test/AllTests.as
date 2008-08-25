package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import fquery.collection.DisplayListIteratorTest;
	import fquery.collection.DisplayObjectIteratorTest;
	import fquery.reflect.ReflectionTest;
	import FQueryTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new fquery.collection.DisplayListIteratorTest());
			addTest(new fquery.collection.DisplayObjectIteratorTest());
			addTest(new fquery.reflect.ReflectionTest());
			addTest(new FQueryTest());
		}
	}
}
