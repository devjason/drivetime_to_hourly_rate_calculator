module App exposing (..)

import Html exposing (Html, a, div, form, h1, h2, h3, h4, input, label, text)
import Html.App
import Html.Attributes exposing (id, type', for, value, class, href, min)
import Html.Events exposing (onClick, onInput)
import String

main =
  Html.App.beginnerProgram { model = model, view = view, update = update }

-- *****************************************************************************
-- Model
-- *****************************************************************************
type alias Minutes = Float
type alias DollarsPerHour = Float
type alias Model =
  { mileageTime: Minutes
  , mileageRate: DollarsPerHour
  , hourlyRate: DollarsPerHour
  }

model : Model
model =
  defaultModel

defaultModel : Model
defaultModel =
  { mileageTime = 0.0
  , mileageRate = 0.00
  , hourlyRate  = 0.00
  }


-- *****************************************************************************
-- Update
-- *****************************************************************************
type Msg
  = ChangeDriveMinutes String
  | ChangeDriveRate String
  | ChangeHourlyRate String
  | Reset


update: Msg -> Model -> Model
update msg model =
  case msg of
    ChangeDriveMinutes strValue -> {model | mileageTime = strToFloat strValue}
    ChangeDriveRate    strValue -> {model | mileageRate = strToFloat strValue}
    ChangeHourlyRate   strValue -> {model | hourlyRate  = strToFloat strValue}
    Reset                       -> defaultModel


strToFloat: String -> Float
strToFloat str =
  Result.withDefault 0.0 (String.toFloat str)

minutesPerHour : Minutes
minutesPerHour =
  60.0


calculateHours: Model -> Float
calculateHours model =
  let
    mileageHours = (model.mileageTime / minutesPerHour)
    rateRatio = (model.mileageRate / model.hourlyRate)
  in
    mileageHours * rateRatio


formatFloat: Float -> Float
formatFloat float =
  let
    first = float * 100
    sec = round first
    third = toFloat sec / 100.0
  in
    third


resultAsString: Model -> String
resultAsString model =
  (calculateHours model) |> formatFloat |> toString


-- *****************************************************************************
-- View
-- *****************************************************************************
view: Model -> Html Msg
view model =
      div [class "row column"]
      [
        div [] [ h1 [class "text-center"] [text "Mileage to Hours Converter"] ]
      , div [] [ viewForm model ]
      , div [class "callout success"]
            [ h4 [] [ text "Calculated Hours: ", text (resultAsString model)] ]
      , div []
            [ a [href "#", class "button alert expanded", onClick Reset]
                [text "Reset"]
            ]
      ]


viewForm: Model -> Html Msg
viewForm model =
    form [id "calculation-form"]
      [ label [for "mileage-time"] [text "Minutes Driving (minutes)"]
      , input [id "mileage-time", type' "number", Html.Attributes.min "0",
               value (toString model.mileageTime), onInput ChangeDriveMinutes] []
      , label [for "mileage-rate"] [text "Driving Hourly Rate ($/hr)"]
      , input [id "mileage-rate", type' "number", Html.Attributes.min "0",
               value (toString model.mileageRate), onInput ChangeDriveRate] []
      , label [for "hourly-rate"] [text "Base Hourly Rate ($/hr)"]
      , input [id "hourly-rate",  type' "number", Html.Attributes.min "0",
               value (toString model.hourlyRate), onInput ChangeHourlyRate] []
      ]
