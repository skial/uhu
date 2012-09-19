The method which does all the hard work.

First the ```_template``` is checked if contains the opening tag. If it fails, just push it as a ```Static``` value and exit.

If it fails to match the regular expression, its assumed that its encounted an unclosed tag.

If everything matches ok, it pulls out all the groups from the matched regular expression. But first it needs to be determined if
the matched token is standalone and on non interpolating.

_Ignore all the nasty debug traces. Helped alot during failing unit tests._

If the token is standalone then whitespace and newline characters are removed according to the [mustache specification](https://github.com/mustache/spec).
	
Once any standalone tokens have been cleaned up, any preceding text is pushed into a ```Static``` value, as well as any remaining whitespace.

Next the captured tag value is switched over, pushing the tokens content into the appropiate token type.