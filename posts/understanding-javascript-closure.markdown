---
title: Understanding Javascript Closure
date: 2015-08-14
disqus: True
---

Before talking about closures in Javascript, it is essential to understand Execution Context, Lexical Scope and Variables Environment first.

Execution Context

The first execution context, called Global Context, will be created when the program start to run. Any function invocation will create another execution context and and its context will be stack upon current execution context.

Create a variable object composing of all the variables declared, function declaration and argument defined.
Initialize the Scope Chain.
Determine the value of "this".
Lexical Scoping

```js
var x = 'GLOBAL';

function outer() {
  var y = "outer";    

  function inner() {
    var x = "inner";
    console.log(x);
    console.log(y);
  }
}
```
In this example, even though variable y is defined in function outer, it can be accessed inside function inner because it is lexically, physically written inside function outer.

In contrary,
```js
function a() {
  var x = 'from a';
}
function b() {
  var y = 'from b';
  console.log(x);
  console.log(y);
}
b() //x is undefined
```
Here x is undefined in function because the function b is not lexically sit inside a. (In some languages, dynamic scoping is supported and the variable can be influenced by looking up the calling stack of the function).

Closure

A closure is like a side effect of lexical scoping and it is created when a function returned reference local variables in lexically outer functions in its creation.

Consider the example below.

```js
function createAccumulator(initVal) {
  return function () {
    initVal += 1;
    return initVal;
  };
}

var accumulator = createAccumulator(100);
accumulator(); // 101
```
Here, the returned function can still has access to variable in createAccumulator. Guess what, it is all because of lexical scoping. The function returned can still have access to all the local variables of its outer function where it is created.

Functional Javascript

Closures makes it possible to write functional programming in JavaScript.

A simple example is currying. Currying is a technique to break down a function that takes multiple arguments into a series of function that take one or less argument.

```js
function add(a, b) {
  if (arguments.length < 1) {
    return add;
  } else if (arguments.length < 2) {
    return function(c) { return a + c }
  } else {
    return a + b;
  }
}

var add5 = add(5);
var add5(10) //return 15
```
Learning Closure is a key to master in javascript. It helps you write better small composable function and understand some design patterns like Module Pattern which provider both private and public encapsulation.
