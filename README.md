# Uhu & Uhx _(Experimental Uhu)_

* [Klas](#klas) : Global macro helper.

## Klas

Klas is a macro auto build `interface` giving you access to a wide range of experimental features.

+ [@:cmd](#cmd) : Create CLI applications.
+ [@:tem](#tem) : Just plain Haxe, HTML and CSS.
+ [@:wait](#wait) : Async helper.
+ [@:arg](#named arg) : Named arguments.
+ [@:pub](#pubsub) : Marks field as a publisher.
+ [@:sub](#pubsub) : Marks field as a subscriber.

## Cmd

The `@:cmd` metadata allows you to use your class to build a command line interface. Inspired by [mcli](https://github.com/waneck/mcli) by [Cauê Waneck](https://github.com/waneck).
	
## Tem

Tem allows you to bind your HTML directly to you classes, using only CSS as the glue.

## Wait

The `@:wait` metadata helps you reduce callback hell. It should work for any target, but it was originally built for the Javascript target.