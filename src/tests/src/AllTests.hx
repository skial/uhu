package ;

import haxe.unit.TestRunner;
import haxe.Utf8Spec;
import sys.net.HostSpec;
import sys.net.SocketSpec;
import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;
import uhx.oauth.Oauth10aSpec;
import uhx.util.URLParserSpec;

/**
 * ...
 * @author Skial Bainn
 */

class AllTests {

	public static function main() {
		
		var runner = new TestRunner();
		
		runner.add( new Utf8Spec() );
		
		runner.add( new Base64Spec() );
		runner.add( new MD5Spec() );
		runner.add( new HMACSpec() );
		
		runner.add( new URLParserSpec() );
		
		#if sys
		
		runner.add( new Oauth10aSpec() );
		
		runner.add( new HostSpec() );
		runner.add( new SocketSpec() );
		
		#end
		
		runner.run();
		
	}
	
}