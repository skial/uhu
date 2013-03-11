package ;

import haxe.unit.TestRunner;
import uhx.oauth.GithubSpec;
import haxe.Utf8Spec;

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

import uhx.crypto.Base64Spec;
import uhx.crypto.HMACSpec;
import uhx.crypto.MD5Spec;
import uhx.web.URISpec;

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
		
		// Github OAuth Tests
		//runner.add( new GithubSpec() );
		
		runner.run();
		
	}
	
}