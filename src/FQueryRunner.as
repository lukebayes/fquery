package {
	import asunit.textui.TestRunner;
	import fquery.laml.LAMLParserTest;
	
	public class FQueryRunner extends TestRunner {
		
		public function FQueryRunner() {
			// start(clazz:Class, methodName:String, showTrace:Boolean)
			// NOTE: sending a particular class and method name will
			// execute setUp(), the method and NOT tearDown.
			// This allows you to get visual confirmation while developing
			// visual entities
			start(AllTests, null, TestRunner.SHOW_TRACE);
		}
	}
}
