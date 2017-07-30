---
title: Learn functional programming by writing FE apps in Elm (pt.3)
date: 2017-07-30
preview_image: /images/greece-ocean.jpeg
isIndex: False
---


## QuizWizard & Quiz List
In part 3, we will persist our quiz created in firebase and we will add navigation to the App. So you can send the link of the quiz to let other to do it. You can play around with it [here](swtpain.github.io/quiz-maker/)

```bash
git clone git@github.com:SWTPAIN/quiz-maker.git
git checkout v0.0.3
```

<br></br>

## New Folder Structure
```elm
-- new folder structure
-- |- elm
--     |- Main.elm
--     |- Model
--        |- Quiz.elm
--        |- Shared.elm
--     |- Model.elm
--     |- Page
--        |- DoQuiz
--           |- Model.elm
--           |- Update.elm
--           |- View.elm
--        |- Home
--           |- Mode.elm
--           |- Update.elm
--           |- View.elm
--        |- Port
--           |- Utils.elm
--        |- Port.elm
--     |- QuizWizard
--        |- Model.elm
--        |- Update.elm
--        |- View.elm
--     |- Route.elm
--     |- Update
--        |- Utils.elm
--     |- Update.elm
--     |- View.elm
```

We have a new folder `Page` and file `Route.elm` which contain page-specific logic and navigation logic. And finally `Port.elm` contain the logic of talking to JS.

<br></br>

## Javascript Interop
```elm
-- Port.elm
port addQuiz : DraftQuiz -> Cmd msg


port alert : String -> Cmd msg


port addQuizResult : (ServerResult QuizFromServer -> msg) -> Sub msg

```
In Elm, we can use keyword `port` to talk to Javascript in runtime. In our quiz-maker apps, we need to call the function provide in firebase JS sdk to persist quiz and retrieve quizzes.

Just like doing other impure actions, we use `Command` to sending out value to JS. And in our javascript world, we will need to apply subscribe function on the port we are interested in.

```Javascript
app.ports.addQuiz.subscribe(addQuiz(app.ports.addQuizResult.send));
app.ports.alert.subscribe(msg => window.alert(msg));
```

To send value back to Elm world, we will need to call `send` function with the value and we will need to apply the sub port in our subscription.

```elm
-- Update.elm
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Port.addQuizResult (Port.Utils.mapServerResult >> AddQuizResult)
        ]
```

In Elm, we will use subscription to listen for some external events like web-socket, values send from JS. We have to define what `Msg` we want the runtime to apply them to the update function.

<br></br>

## Navigation
We will use [elm-lang/navigation](https://github.com/elm-lang/navigation) and [etaque/elm-route-parser](https://github.com/etaque/elm-route-parser) packages for that.
<br></br>

For our main funciton, we will use `Navigation.programWithFlags`. The major difference is we need to provide one more argument `(Location -> msg)` which is used by `Navigation` to convert the Location Record to a message.

```elm
-- Main.elm
main : Program Flags Model Msg
main =
    Navigation.programWithFlags
        (Route.parser >> Model.MountRoute)
        { init = Update.init
        , view = View.view
        , update = Update.update
        , subscriptions = Update.subscriptions
        }

-- Route.elm
parser : Navigation.Location -> Route
parser location =
    fromPath location.hash

type Route
    = Home
    | DoQuiz String
    | NotFound

-- Update.elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        MountRoute route ->
            mountRoute route model

-- Model.elm
type alias Model =
    { route : Route
    , quizzes : List Quiz
    , notification : Maybe String
    , doQuiz : DoQuizModel.Model
    , home : HomeModel.Model
    }

-- View.elm
view : Model -> Html Msg
view ({ quizzes, route } as model) =
    let
        content =
            case route of
                Route.Home ->
                    Html.map HomeMsg (PageHome.view quizzes model.home)

                Route.DoQuiz quizId ->
                    Html.map DoQuizMsg (PageDoQuiz.view model.doQuiz)

                Route.NotFound ->
                    notFoundView
    in
        renderSite model content

```

In our case, we will apply the `parser` function in Route which basically get Route from Location and then we will return a `MountRoute` Msg.

So whenever `update` function get called with `MountRoute` message, we will update route value in our model. And our view function just call page view function based on the current route.

So this is a very short part in tutorial but I do recommend you to check out the source code.

In the part 4, we will see we add random shuffling for our answer instead of putting the correct answer in the first one. This will be interesting because random number is intuitively not pure but its not referential transparent. Lets talk about it in the next part.
