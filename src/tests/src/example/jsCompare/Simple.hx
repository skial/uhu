package ;

class Simple {
	
	var name:String;
	
	function new(name:String) {
		this.name = name;
	}
	
	function greet(who:String) {
		return 'Greetings $who, I\'m $name!';
	}
	
	static function main() {
		var s = new Simple("Flynn");
		trace( s.greet("Program") );
	}
	
}