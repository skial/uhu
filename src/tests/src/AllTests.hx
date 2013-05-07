package ;

import haxe.Utf8Spec;
import uhx.fmt.ASCIISpec;
import uhx.metadata.BindSpec;
import uhx.web.URISpec;
import uhx.oauth.GithubSpec;
import haxe.unit.TestRunner;
import uhx.http.impl.t.TRequest;

#if !js
import uhu.mu.CommentSpec;
import uhu.mu.DelimiterSpec;
import uhu.mu.InterpolationSpec;
import uhu.mu.InvertedSpec;
import uhu.mu.MustacheSpec;
import uhu.mu.PartialSpec;
import uhu.mu.SectionSpec;
import uhu.mu.WalkContextSpec;
#end

#if sys
import sys.net.HostSpec;
import sys.net.SocketSpec;
import uhx.oauth.OAuth10aSpec;
#end

#if js
import uhx.http.RequestSpec;
#end

import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;

/**
 * ...
 * @author Skial Bainn
 */

#if !disable_macro_tests
//@:build( MacroTests.run() )
#end
class AllTests {
	
	@:isVar public static var something(default, set):Int = 666;
	private static function set_something(v:Int):Int {
		something = v;
		return v;
	}

	public static function main() {
		something = 666;
		var runner = new TestRunner();
		
		runner.add( new BindSpec() );
		
		//runner.add( new ASCIISpec() );
		runner.add( new Utf8Spec() );
		
		runner.add( new Base64Spec() );
		runner.add( new MD5Spec() );
		runner.add( new HMACSpec() );
		
		runner.add( new URISpec() );
		
		#if sys
		
		runner.add( new OAuth10aSpec() );
		
		runner.add( new HostSpec() );
		//runner.add( new SocketSpec() );	// temp disabled - neko cant start echo socket
		
		#end
		
		#if !js
		// Mustache Tests
		runner.add( new CommentSpec() );
		runner.add( new DelimiterSpec() ); //
		runner.add( new InterpolationSpec() );
		runner.add( new InvertedSpec() );
		runner.add( new MustacheSpec() ); //
		runner.add( new PartialSpec() ); //
		runner.add( new SectionSpec() ); 
		runner.add( new WalkContextSpec() ); 
		#end
		
		#if js
		// Request Tests
		runner.add( new RequestSpec() );
		#end
		
		// Github OAuth Tests
		runner.add( new GithubSpec() );
		
		runner.run();
		
	}
	
}