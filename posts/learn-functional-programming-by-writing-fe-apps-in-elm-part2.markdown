---
title: Learn functional programming by writing FE apps in Elm (pt.2)
date: 2017-07-23
disqus: True
---


## QuizWizard & Quiz List
In part 2, we can create quiz and see list of quizzes in our app. Instead of a walkthrough of coding, it will be highlights and explanations about some key changes we made. It's recommended to read the source code and play around with the apps before reading it.

```bash
git clone git@github.com:bruteforcecat/quiz-maker.git
git checkout v0.0.2
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
--     |- QuizWizard
--        |- Model.elm
--        |- Update.elm
--        |- View.elm
--     |- Update
--        |- Utils.elm
--     |- Update.elm
--     |- View.elm
```

We have separated `update`, `view`, `Model` into its own module. And notice there is a folder `QuizWizard` which contain `Model.elm`, `Update.elm`, `View.elm`. Unlike React or most other JS framework, there are no reusable components in Elm but only reusable functions. And by keeping pure function, we can avoid using internal state in component.

<br></br>

## Use Html.program instead Html.beginnerProgram
```elm
-- Main.elm
main : Program Never Model Msg
main =
    Html.program
        { init = Update.init
        , view = View.view
        , update = Update.update
        , subscriptions = Update.subscriptions
        }

```
We can ignore `subscriptions` function for now. The main difference is the `update` function return a tuple of `Model` and `Cmd Msg`. A command is a description of an effect that Elm Runtime help us to perform so our code can
stay pure in Elm.

<br></br>

## Thinking in Model
Because of being the state of the whole application, it is very common to think about data structure in `Model` before we make any change.
```elm
-- Model.elm
module Model exposing (..)

import QuizWizard.Model as QuizWizardModel

type alias Model =
    { quizzes : List Quiz
    , quizWizard : QuizWizardModel.Model
    , notification : Maybe String
    }

-- QuizWizard/Model.elm
module QuizWizard.Model exposing (..)

type alias Model =
    { title :
        String
    , questions : List Question
    , currentQuestionField :
        QuestionField
    , error : Maybe Error
    , currentStep : Step
    }

type alias QuestionField =
    { title : String
    , correctAnswer : String
    , prevWrongAnswers : List String
    , lastWrongAnswer : String
    }

-- Model/Quiz.elm
module Model.Quiz exposing (..)


type alias Quiz =
    { title : String
    , questions : List Question
    }


type alias Question =
    { title : String
    , correctAnswer : String
    , wrongAnswers : List String
    }
```

The model type is record coding field `quizzes`, `quizWizard` and `notification` which explicitly define our data and we can also easily
know what this application does just by reading the `Model` type.

<br></br>

## Impossible State
Let's look at the `QuestionField` which is a Record with title, correctAnswer, prevWrongAnswers and lastWrongAnswer. You might wonder why don't we just simplify it to as following:

```elm
type alias QuestionField =
    { title : String
    , correctAnswer : String
    , wrongAnswers : List String
    }
```

If we simplify the QuestionField type as this, what if we see the questionField as the following during our runtime?

```elm
questionField = {
  title = "Question 1"
  , correctAnswer : "Correct Answer"
  , wrongAnswers : []
}
```

This is not what we want because we want the `wrongAnswers` to have at least one element. And if we explicitly saprate the `lastWrongAnswer` as its own field, we can guarantee there will be at least one element without the need in writing defensive code which also save us from writing unnecessary test.

<br></br>

## Changing Applicaiton State
```elm
-- QuizWizard/Model.elm

type Msg
    = UpdateQuizTitle String
    | UpdateCurrentQuestionFieldMsg UpdateCurrentQuestionFieldMsg
    | StartAddQuestion
    | AddCurrentQuestion
    | CreateQuizRequest
    | CreateQuiz Quiz
    | BackStep


type UpdateCurrentQuestionFieldMsg
    = UpdateCurrentQuetionTitle String
    | UpdateCurrentQuestionCorrectAnswer String
    | UpdateCurrentQuestionPrevWrongAnswer Int String
    | UpdateCurrentQuestionLastWrongAnswer String
    | AddOneWrongQuestion
```

We define all the possible action or event that can happen in `Msg` Type. These messages usually come from user' interaction(Dom event), external source like websocket or runtime's response for command.

Note that we group current question field into its own sum Union type so we can have a separate function to handle it and avoid a crazily long pattern matching in update function.


```elm
-- QuizWizard/Update.elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateQuizTitle title ->
            ( { model
                | title = title
              }
            , Cmd.none
            )

        UpdateCurrentQuestionFieldMsg updateCurrentQuestionFieldMsg ->
            ( { model
                | currentQuestionField = updateCurrentQuestionField updateCurrentQuestionFieldMsg model.currentQuestionField
              }
            , Cmd.none
            )

updateCurrentQuestionField : UpdateCurrentQuestionFieldMsg -> QuestionField -> QuestionField
updateCurrentQuestionField updateCurrentQuestionFieldMsg
  case updateCurrentQuestionFieldMsg of
      UpdateCurrentQuetionTitle title ->
          { questionField
              | title = title
          }
    -- ...
 questionField =
```

Here, we can also see one of the advantage of ADT over classes is the easiness of adding a new operation on a new member in a type. No other function in update has to be changed if we modify only the function applying on one member of sum Union Type.

<br></br>

## Views is just purely functions
```elm
-- QuizWizard/View.elm
view : Model -> Html Msg
view model =
    div [ class "panel" ]
        [ div [ class "panel-heading" ] [ text "Create your own quiz" ]
        , div [ class "panel-block" ]
            [ div [ class "section" ]
                [ div [ class "title" ] [ p [] [ model |> title |> text ] ]
                , div []
                    [ notification model
                    , form model
                    ]
                , footer model
                ]
            ]
        ]

notification : Model -> Html Msg
notification { error } =
    case error of
        Nothing ->
            div [] []

        Just error_ ->
            div [ class "notification is-danger" ]
                [ text error_
                ]

form : Model -> Html Msg
form { title, currentQuestionField, currentStep } =
    let
        formContent =
            case currentStep of
                AddTitle ->
                    quizTitleForm title

                AddQuestion ->
                    quizQuestionForm currentQuestionField |> Html.map UpdateCurrentQuestionFieldMsg
    in
        Html.form []
            [ formContent
            ]

quizTitleForm : String -> Html Msg
quizTitleForm title =
    div [ class "field" ]
        [ div [ class "control" ]
            [ input
                [ class "input"
                , type_ "text"
                , placeholder "Quiz Title"
                , onInput UpdateQuizTitle
                , value title
                ]
                []
            ]
        ]

```
Because view is just elm function, you can compose them by applying other view function. And it's generally good practice to only require minimal argument in view function instead of the whole `Model` and so we can scale
the application easily in the future.

<br></br>

## Child-parent communication
In our quiz-maker application, when the user click create in quiz wizard, we
will need to add the quiz into our list. However, it cannot be done in `QuizWizard.Update` because the `quizzes` field belongs in the `Model` in `main.elm`. And this is the time that the parent need to respond to some event happen inside the children. There are three ways to do that in elm which are NoMap, OutMsg and Translator.

And in pt2, we will only use the most naive and intuitive way to handle child-parent communication.

```elm
-- Update.elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        QuizWizardMsg quizWizardMsg ->
            case quizWizardMsg of
                QuizWizardModel.CreateQuiz quiz ->
                    ( { model
                        | quizWizard = QuizWizardModel.initialModel
                        , quizzes = quiz :: model.quizzes
                        , notification = Just "Your quiz is created"
                      }
                    , Cmd.none
                    )

                _ ->
                    let
                        ( quizWizard, cmd ) =
                            QuizWizardUpdate.update quizWizardMsg model.quizWizard
                    in
                        ( { model
                            | quizWizard = quizWizard
                          }
                        , Cmd.map QuizWizardMsg cmd
                        )
```

So the update function in `Main.elm` will pattern match the msg `QuizWizardModel.CreateQuiz` and response to it instead of delegating the message to update function in `QuizWizard.Update`. We will discuss the other better three approach later in the series.

<br></br>

## Higher-kinded types
There will be validation checking when use try to add new question to the quiz. If some question is empty, a error notification will be shown.

```elm
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
      -- ....
      AddCurrentQuestion ->
          case getCurrentQuestion model.currentQuestionField of
              Err err ->
                  { model | error = Just err } ! [ Cmd.none ]

              Ok question ->
                  { model
                      | questions = model.questions ++ [ question ]
                      , currentQuestionField = defaultQuestionField
                      , error = Nothing
                  }
                      ! [ Cmd.none ]



getCurrentQuestion : QuestionField -> Result Error Question
getCurrentQuestion ({ title, correctAnswer, prevWrongAnswers, lastWrongAnswer } as questionField) =
  Result.map3
      (\title correctAnswer wrongAnswers ->
          { title = title
          , correctAnswer = correctAnswer
          , wrongAnswers = wrongAnswers
          }
      )
      (if title == "" then
          Err "Question Title cannnot be empty"
       else
          Ok title
      )
      (if correctAnswer == "" then
          Err "Correct Answer cannot be empty"
       else
          Ok correctAnswer
      )
      (getWrongAnswers questionField)

-- using map3 instead of nested pattern matching
-- case title of
--     "" ->
--         Err "Question Title cannot be empty"
--
--     title_ ->
--         case correctAnswer of
--             "" ->
--                 Err "Correct Answer cannot be empty"
--
--             correctAnswer_ ->
--                 case getWrongAnswers questionField of
--                     Err err_ ->
--                         Err err_
--
--                     Ok wrongAnswers ->
--                         Ok
--                             { title = title_
--                             , correctAnswer = correctAnswer_
--                             , wrongAnswers = wrongAnswers
--                             }

```
`Result` is a type constructor that take two types. Here the return type of `getCurrentQuestion` is `Result Error Question` which means the value of that type might be either `Error` or `Question`. So now the caller have to handle both error and success case when we try to apply this function. And the difference of `Either` and `Maybe` is we can pass the error info instead of `Nothing`.

We use `Result.map3` here by turning title and correctAnswer to Result type. So we can avoid three level nested pattern matching which might be hard to read.

And that's all for the part two. In the next part, we will actually save the data to firebase and create a sharable link for user to give the quiz to friends.
<br></br>

## Reference
- [why-are-haskell-algebraic-data-types-closed](https://stackoverflow.com/questions/870919/why-are-haskell-algebraic-data-types-closed)
- [Make impossible state impossible](https://www.youtube.com/watch?v=IcgmSRJHu_8)
