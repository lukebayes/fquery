package {
	/**
	 * This file has been automatically created using
	 * #!/usr/bin/ruby script/generate suite
	 * If you modify it and run this script, your
	 * modifications will be lost!
	 */

	import asunit.framework.TestSuite;
	import fquery.utils.ReflectionTest;
	import FQueryTest;

	public class AllTests extends TestSuite {

		public function AllTests() {
			addTest(new fquery.utils.ReflectionTest());
			addTest(new FQueryTest());
		}
	}
}
