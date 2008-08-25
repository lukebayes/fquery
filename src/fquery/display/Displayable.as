package fquery.display {
	
	/*
	 * Interface to implement if you'd like to enforce
	 * fQuery compliance in your architecture.
	 * This interface is not required directly by fQuery,
	 * But should help those of you that are interested
	 * with implementing the features that you need.
	 */
	public interface Displayable {
		
		function set styles(styles:Array);
		function get styles():Array;
		
		function set id(id:String);
		function get id():String;
	}
}
