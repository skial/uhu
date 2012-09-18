import massive.munit.TestSuite;

import CommentTest;
import DelimiterTest;
import InterpolationTest;
import InvertedTest;
import MustacheTest;
import PartialTest;
import SectionTest;
import WalkContextTest;

/**
 * Auto generated Test Suite for MassiveUnit.
 * Refer to munit command line tool for more information (haxelib run munit)
 */

class TestSuite extends massive.munit.TestSuite
{		

	public function new()
	{
		super();

		add(CommentTest);
		add(DelimiterTest);
		add(InterpolationTest);
		add(InvertedTest);
		add(MustacheTest);
		add(PartialTest);
		add(SectionTest);
		add(WalkContextTest);
	}
}
