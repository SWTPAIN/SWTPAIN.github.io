---
title: Learn functional programming by writing FE apps in Elm (pt.1)
date: 2017-07-20
preview_image: /images/coffee-beginning.jpeg
isIndex: False
---

## Foreword
As a self-taught programmer who had worked in the industry for 3 years, I always
hear a lot of good thing about functional programming while there are lots of criticism about it like it's too academia and hard to learn. Nonetheless, there are lots of concept inspired by FP already widely used in our day-to-day work, for example, higher-order function in Javascript like map, reduce and list comprehension.

Also with the rise of redux as a predictable state container in FE,
it's amazing to see how simple but powerful is redux and the core ceonpt in redux are immutability of data and pure functions.

Javascript is a great language especially EC39 made the decision to move to a yearly model for defining new standards, and the new features in es6 are already very appealing.

However, due to its dynamic typed and imperative nature, it's very easy for developer to make mistake causing runtime exception, bug that take days to solve it and high complexity of codebase that no one want to touch it.

So this trigger to me to go deeper into learning FP. And Elm is my first choice because of its simplicity and the pureness in FP. So in this series, we will learn FP by building an apps in Elm.

### What's Elm?
Elm is a pure functional programming language that compile to JS and CSS. Elm is very friendly for functional programming beginner and its more like a framework with a language attached.

### What are we going to build
We will build a quiz-maker single page application where anyone can create quiz and allow people to do the quiz.

### Project Setup
To start with, we will use [elm-webpack-start](https://github.com/elm-community/elm-webpack-starter) as our boilerplate.

Let's have a quick look in to folder structure
```
- src
  |- elm
      |- Components
          |- Hello.elm
      |- Main.elm
  |- static
      |- img
      |- styles
      |- index.html
      |- index.js
```

`index.js` will be our app entry point which basically only mount our elm application in DOM.

More interesting is inside `src/elm/Main.elm`. The entry point of elm application will be the `main` function.

#### The Elm Architecture aka TEA
As said before, elm is more like a programming language designed for a framework.
Every developer who has experience in Redux will find its pattern so familiar.

There will be three most important parts which are model, update and view.

```elm
type alias Model = Int
model : number
model = 0
```
The model will usually be a more complicated record. Yet in the boilerplate example, the model is simply an integer. And its initial value is set as 0. The model will be the state of your application. And you will notice that there is type annotation. Although it's not necessary to type annotation by yourself cause Elm compiler is usually smart enough doing type inference, it's generally encouraged to declare annotation yourself and usually you will find it's easier to write program by thinking in type first.

```
-- UPDATE
type Msg = NoOp | Increment

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Increment -> model + 1
```
For the update part, `type Msg = NoOp | Increment` is an example of union type.

##### Union Types
Union types are also called Algebraic data type which is a composite type.
You will soon find union types are very expressive way to create your custom datatype to describe the date our application process.

##### What? Algebraic?
This just meant it's a kind of composite type. In elm, you have sum or product type. A product type mean the number of different value is the Cartesian product of different value of each types in the data constructors.
A sum type mean the value is a set of value that is the sum of value in data constructors.

```elm
-- Example of Sum Type
type Boolean' = False' | True'
-- Example of Product Type
type Point = Point Integer Integer

-- We can also have sum of product types
type Guest = Guest
type User = User String Integer
type VIP = VIP String Integer String
type Animal = Guest | User | VIP
```


Let's break down `type Msg = NoOp | Increment`.
1. `type Msg = ` mean we declare a new type called `Msg`
2. `NoOp | Increment` Two Data Constructor. One is `NoOp` and another is `Increment`. `|` logical disjunction you can think it as `or` which also imply this is a sum type.

In Javascript, we will probably use string `msg = 'NoOp'; msg = 'Increment'` or
slight better an object emulating Enum `const MSG = {NoOp: 'NoOp', Increment: 'Increment'}` or es6 Symbol. But all these thing cannot guarantee developer to match all possible case of msg and it's not easy to compose them.

However, with pattern matching and compiler in Elm, we can enforce developer to handle all possible case. In update function, we use `case msg of` and we have to specify what will we return in all possible case of Msg and this is called pattern matching which is the only way to do operation on ADT data. If we miss `Increment` in `case of`, compiler will throw error.

So back to boilerplate example, the update function will take 2 arguments, a message and a model and return a new model. So the its basically  a reducer. And update function will be called by Elm runtime whenever there is Cmd from either DOM event or other external source like websocket.

```
-- View
view : Model -> Html Msg
view model =
  div [ class "container", style [("margin-top", "30px"), ( "text-align", "center" )] ][    -- inline CSS (literal)
    div [ class "row" ][
      div [ class "col-xs-12" ][
        div [ class "jumbotron" ][
          img [ src "static/img/elm.jpg", style styles.img ] []                             -- inline CSS (via var)
          , hello model                                                                     -- ext 'hello' component (takes 'model' as arg)
          , p [] [ text ( "Elm Webpack Starter" ) ]
          , button [ class "btn btn-primary btn-lg", onClick Increment ] [                  -- click handler
            span[ class "glyphicon glyphicon-star" ][]                                      -- glyphicon
            , span[][ text "FTW!" ]
          ]
        ]
      ]
    ]
  ]
```
It might look lots of thing going on here but view is actually the simplest thing in TEA. The return type of view function is `Html Msg` which means the only responsibility of view is to return HTML(not exactly, Elm is virtual-dom behind the scene). We can think of it as pure function in React Component. There is no lifecycle. And because it's just a function in Elm, you can have full power instead of limited capability in template languages.

In `button [ class "btn btn-primary btn-lg", onClick Increment ] [...]`, the `onClick` function will take a message and the message will create a command Msg will eventually cause Elm runtime apply update function and get a new state which lead to UI re-render.

So that's long walkthrough will the boilerplate. We will start building a dummy UI for our quiz maker in the second part.

### References
[Algebraic Data Type](https://en.wikipedia.org/wiki/Algebraic_data_type)
