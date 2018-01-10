---
title: 2017 Recap & 2018 Focus
date: 2018-01-08
disqus: True
---

## 2017

Back in 2014 Summer, I made my best decision ever of learning programming and found my first programming job, writing Ruby on Rails an Ionic hybrid mobile apps. This year, I had learnt so much things in new area and decided to start this blog to record what I learnt.

## Functional Programming

I started learning functional programming in Javascript. While some people think functional programming is anti-pattern in javascript because of mutable data-structure, lack of purity in function, I think it is excellent choice of starting functional programming journey.

First, it has enough features for FP, including first class functions, lambda(anonymous function), closure(lexical closure). Lacking of purity is actually an advantage for beginner learning FP, it's just too daunting for most people to learn Monad before having ability to log or manipulate DOM.

Second, its very easy to slowly apply FP concept in their daily work, especially with library like Redux, Rambda.

Apart from Javascript, I also wrote a small Elm Widget in production and had the oppournity to write Clojure and Clojurescript in production.

### Things I like about Clojure/Clojurescript
* Immutable Data Structure. Although side-effect is still allowed in Clojure, immutable data structure already help us to minimize a lot of bug and reasoning code become much easier.
* Conciseness. With Lisp syntax, its very simple and allow you to write declarative and expressive code in stead of imperative.
* MetaProgramming. Meta-programming in Clojure is mostly done by macro which basically allow you to suppress evaluation and transform your code in compile time (thanks to code as data in clojure). The most useful case is defining your DSL and other use cases are probably better to handle them by high-order functions.

```clojure
(defmacro unless [test then else]
  `(if (not ~test) ~then) ~else)
 
(unless false (println "negative") (println "positive")
=> "negative"

;; this can be achived by simple high order function
(def unless [test then]
  (if (not test)
    (then)
    (else))
) 

(unless false #(println "negative") #(println "positive"))
=> "negative"


(defmacro deftag [name]
  (list 'defn name ['& 'inner]
    (list 'str "<" (str name) ">"
      '(apply str inner)
      "</" (str name) ">")))

(deftag html)
(deftag body)
(deftag h1)
(deftag p)

(html
  (body
    (h1 "Yo")))
```

### Things I like about Elm
* Strongly Static Typed FP is awesome. It saves you so much time for making careless mistake, espespecially during refactoring or adding features.
* Algebraic Data Type. [my previoust post related to this](/learn-functional-programming-by-writing-fe-apps-in-elm-part1.html)
* TEA. [A very simple but effective frontend architecture](https://guide.elm-lang.org/architecture/)

* [Javascript Allonge](https://leanpub.com/javascriptallongesix)
* [Mostly Adequate Guide to Functional Programming](https://drboolean.gitbooks.io/mostly-adequate-guide/)
* [The introduction to Reactive Programming you've been missing](https://gist.github.com/staltz/868e7e9bc2a7b8c1f754)

### Other thing
Reading [Haskell Programming](http://haskellbook.com/) (not yet finish)
Learning Elixir, understanding OTP

## Deep Learning
Coming from a statistics background, I finally spent some time learning Deep Learning and it has been fascinating how powerful it is even though the basic idea of DL is very simple which is just a universal approximation.

* [Udacity Deep Learning Nano Degree](https://www.udacity.com/course/deep-learning-nanodegree-foundation--nd101)
* [Deeplearning.ai](https://www.deeplearning.ai/) (first two courses)
* [Neural Network and Deep Learning](http://neuralnetworksanddeeplearning.com/) (half-way done)

## BlockChain
I still can't believe myself of ignoring bitcoin, ethererum or other blockchain-related tech untill this year April. This technology is accelerating so fast and difficult to keep pace with.

* [Bitcoin White Paper](https://bitcoin.org/bitcoin.pdf)
* [Cryptocurrency course in Coursera](https://www.coursera.org/learn/cryptocurrency/)
* Learning how to build Dapps in Ethereum using Truffle


## Focus in 2018
* Build Dapps
* Learn more about Kubernetes
* Learn how to deploy deep learning application using Tensorflow, Keras.
* Keep learning FP, Haskell, ReasonML.
* Write more than 12 blogs
* Learn more Elixir, OTP
