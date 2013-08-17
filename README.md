# Uhu & Uhx _(Experimental Uhu)_

* [Klas](#klas) : Global macro helper.

## Klas

Klas is a macro auto build `interface` giving you access to a wide range of experimental features.
Just add `implements Klas` to your class, then follow the instructions for any of the following
metadata.

+ [@:cmd](#cmd) : Create CLI applications.
+ ~~[@:tem](#tem) : Just plain Haxe, HTML and CSS.~~
+ [@:wait](#wait) : Async helper.
+ ~~[@:arg](#named arg) : Named arguments.~~
+ ~~[@:pub](#pubsub) : Marks field as a publisher.~~
+ ~~[@:sub](#pubsub) : Marks field as a subscriber.~~

## Cmd

The `@:cmd` metadata allows you to use your class to build a command line interface. 
Inspired by [mcli](https://github.com/waneck/mcli) by [Cauê Waneck](https://github.com/waneck).

#### Syntax

+ The `@:cmd` metadata is added to your class.
+ The class constructor must have an `args:Array<String>` parameter.
+ Add `@alias('f')` to any field, where `f` is the short flag identifer.
+ If a field has documentation, it is used in the generated help message.
+ You can optional add `@:usage('cmd [options] <file>')` to your class, which is included in the generated
help message.

#### Example

``` Shell
Person

Options :
	-a, --age	The persons age.
	-n, --name	The persons full name.
	-l, --numLimbs	How many limbs the person has.
	--limbs	
	--r	Does nothing.
	-h, --help	Show this message.
```

``` Haxe
@:cmd
class Person implements Klas {
	
	/**
	 * The persons age.
	 */
	@alias('a')
	public var age:Int;
	
	/**
	 * The persons full name.
	 */
	@alias('n')
	public var name:String;
	
	/**
	 * How many limbs the person has.
	 */
	@alias('l')
	public function numLimbs(v:Int) {
		limbs = v;
	}
	
	public var limbs:Int;
	
	/**
	 * Does nothing.
	 */
	public function r(a:String, b:String, c:Int) {
		// nothing
	}
	
	public function new(args:Array<String>) {
		
	}
	
}
```
	
## Tem

Tem allows you to bind your HTML directly to you classes, using only CSS as the glue.

## Wait

The `@:wait` metadata helps you reduce callback hell. It should work for any target, but it was originally built for the Javascript target.

#### Syntax

+ The `@:wait` metadata has to be defined before the aysnc method being called.
+ The async method has to define each callback using square brackets.
+ Each callback defined has to list all the required arguments. The macro will figure out the arguments type.
 
Each argument defined will be available to you after the defined `@:wait` metadata.

``` Javascript
@:wait Some.asyncMethod( [success], [error] );
var a = 1;
var b = 2;
if (success != null) a = 99;
if (error != null) b = -99;
```

In both cases, `success` and `error` are replaced by a function 
whose body includes every expression defined after the `@:wait` metadata.

#### Limitation's

Currently `@:wait` only take's all the code after it and put's them into
a function, which is called for any of the callbacks defined.

You can't return a value and `for` loop's are untested.

#### Example

Take a look at the code taken [WaitSpec.hx](https://github.com/skial/uhu/blob/experimental/src/tests/src/uhx/macro/WaitSpec.hx) for a working example.

``` Haxe
class WaitSpec implements Klas {

	public function new() {
		
	}
	
	public function testSingle() {
		@:wait Timer.delay( Assert.createAsync( [] ), 100 );
		Assert.equals('Hello', 'Hello');
	}
	
	public function testNested() {
		@:wait Timer.delay( Assert.createAsync( [] ), 100 );
		Assert.equals('Waiting...', 'Waiting...');
		
		@:wait Timer.delay( Assert.createAsync( [] ), 100 );
		Assert.equals('Waiting...', 'Waiting...');
		
		@:wait Timer.delay( Assert.createAsync( [] ), 100 );
		Assert.equals('Waiting...', 'Waiting...');
		
		@:wait Timer.delay( Assert.createAsync( [] ), 100 );
		Assert.equals('Waiting...', 'Waiting...');
	}
	
	public function testDeep() {
		@:wait Timer.delay( Assert.createAsync( Assert.createAsync( Assert.createAsync( Assert.createAsync( [] ) ) ) ), 100 );
		Assert.equals('Hello', 'Hello');
	}
	
}
```
