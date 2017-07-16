---
title: Let's talk functors in Javascript.
date: 2017-07-16
preview_image: /images/pipe.jpeg
---

This article is targeted for any Javascript developer to get a brief understanding in functor.

## What is a functor?
A Functor is a way to apply a function over some structure that we don't want to alter.

Any Javascript developer must have already used functor in their daily works. A good example is `Array`. Consider the following example.

```js
const plus1 = val => val + 1
const plus2 = val => val + 2

map(plus1)[1,2,3] // => [2, 3, 4]
map(plus2)[1,2,3] // => [3, 4, 5]
```

Here the good thing of `map` is we can transform the element inside Array one by one by any arbitrary function and return a new Array which mean the structure is maintained.


In Haskell, just as all algebras, it is implemented with typeclasses.

```haskell
class Functor f where
  fmap :: (a -> b) -> f a -> f b
```

## Functor Laws
There are two laws that every functor has to obey. They are identity & composition.

### Identity
```haskell
fmap id == id # id is the identity function. i.e. id x = x
```
The implication is if we didn't change the outer structure and f is identity. The output will be just same as input.

### Composition
```haskell
fmap (f . g) == fmap f . fmap g
```
The implication is thatfmap is composable which means composing two functions and then mapping the resulting function over a functor is the same as first mapping one function over the functor and then mapping the other one.

In language that's strictly evaluated, it brings us advantage by avoiding loop over the data structure twice.

## Example
### Maybe
If you tried using flow-typed or typescript, you will know how useful `Maybe ` or `Optional` is. The idea of `Maybe` type is to handle the possibility of absence of proper value(like `undefined` or `null` in JS). Consider the following example,

```javascript
@flow
const user: {name: ?string, age: ?number} = {
  name: null,
  age: 10
}
// the following code will not pass type check because it is not safe.
if (user.name.length < 10) {
  // doing crazy stuff
}

// this will pass type check
if (user.name !== null || user.name !== undefined) {
  if (user.name.length < 10) {
    // doing crazy stuff
  }
}
```

So the `Maybe` type allows us to model and handle cases of non-existing values explicitely because by lifting it to type level, the compiler or type-checker will require us to handle two possible case and error in runtime can be avoided.

A naive implementation of writing Maybe functor in JS is as follow
```javascript
const Just = val => ({
  map: f => Just(f(val)),
  value: val
}),
const Nothing = {
  map: Nothing,
  value: Nothing
}

const Maybe = {
  Just, Nothing
}

// So we can use them like the following
const user = {
  name: Maybe.Nothing,
  age: Maybe.Just(10)
}

userAfter10Years =  user.age.map(age => age + 10)
userAfter10Years.age.value // => 20

userChangeName = user.name.map(name => name + 'Choi')
userChangeName.name.value // => Maybe.Nothing
```

See there is no if statement checking anywhere. Our program become more declarative and explicitly handling error case.

### Function
Functions are functors too!

Now, lets get back to Haskell syntax because it is conciser.
```haskell
fmap :: Functor f => (a -> b) -> f a -> f b

# and the maximally polymorphic version is (a -> b) -> a -> b
# and this is function application

($) :: (a -> b) -> a -> b
```

```javascript
const compose = f => g => x => f(g(x))
Function.prototype.map = function(f) {
  return compose(f)(this)
}  
```

So now as long as we can prove thie map implementation obey identity and composition, Function is an instance of Functor as well.

```javascript
// Identity
const id = x => x
f.map(id)
// compose(id)(f)
// x => id(f(x))
// x => f(x)
// f

// example
const plus1 = x => x + 1
resultF = plus1.map(id)
resultF(2) // => 3
resultF(3) // => 4
```

```javascript
// Composition
f.map(compose(f2, f1))
// f.map(x => f1(f2(x)))
// compose(x => f1(f2(x)))(f)
// y => f((x => f1(f2(x)))(y))
// y => f((f1(f2(y))))

f.map(f1).map(f2)
// compose(f1)(f).map(f2)
// (x => f1(f(x))).map(f2)
// compose(f2)(x => f1(f(x)))
// y => f2(x => f1(f(x))(y))
// y => f2((f1(f(y))))

// example
const plus1 = x => x + 1
const plus3 = x => x + 3
const time4 = x => x * 4
const resultF1 = plus1.map(compose(plus3)(time4))
const resultF2 = plus1.map(time4).map(plus3)
resultF1(3) // => 19
resultF2(3) // => 19
```

Now you see we can turn function into functor by assign compose as fmap. By making our type as functor, we can use the same abstraction from functor to transform value regardless of any value in side the functor without altering the outer structure.



### References & Resources
[Functors, Applicatives, And Monads In Pictures](http://adit.io/posts/2013-04-17-functors,_applicatives,_and_monads_in_pictures.html)

[Ramda-Fantasy](https://github.com/ramda/ramda-fantasy)

[Functors - FunFunFunction #10](https://www.youtube.com/watch?v=YLIH8TKbAh4)
