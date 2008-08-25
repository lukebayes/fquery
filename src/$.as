package {
	
	// Expose the FQuery constructor globally on the dollar-sign.
	public function $(query:*=null, context:*=null):FQuery {
		return new FQuery(query, context);
	}
}