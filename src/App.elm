module App exposing (main)

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
type Minutes = Minutes Int
type Hours = Hours Float
type DollarsPerHour = DollarsPerHour Float


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
  { mileageTime = Minutes 0
  , mileageRate = DollarsPerHour 0.00
  , hourlyRate  = DollarsPerHour 0.00
  }


convertToHours: Minutes -> Hours
convertToHours (Minutes minutes) =
  Hours ((toFloat minutes) / 60.0)


calculateRateRatio: DollarsPerHour -> DollarsPerHour -> Float
calculateRateRatio (DollarsPerHour rate1) (DollarsPerHour rate2) =
  rate1 / rate2


calculateHours: Model -> Hours
calculateHours model =
  let
    (Hours mileageHours) = convertToHours model.mileageTime
    rateRatio = calculateRateRatio model.mileageRate model.hourlyRate
  in
    Hours (mileageHours * rateRatio)

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
    ChangeDriveMinutes strValue -> {model | mileageTime = Minutes (strToInt strValue)}
    ChangeDriveRate    strValue -> {model | mileageRate = DollarsPerHour (strToFloat strValue)}
    ChangeHourlyRate   strValue -> {model | hourlyRate  = DollarsPerHour (strToFloat strValue)}
    Reset                       -> defaultModel


strToFloat: String -> Float
strToFloat str =
  Result.withDefault 0.0 (String.toFloat str)


strToInt: String -> Int
strToInt str =
  Result.withDefault 0 (String.toInt str)


-- *****************************************************************************
-- View
-- *****************************************************************************
minutesToString: Minutes -> String
minutesToString (Minutes m) =
  toString m

formatFloat: Float -> Float -> String
formatFloat value precision =
  let
    unit = 10.0^precision
    expand = value * unit
    rounded = round expand
    result = toFloat rounded / unit
  in
    toString result

dphToString: DollarsPerHour -> String
dphToString (DollarsPerHour dph) =
  toString dph


hoursToString: Hours -> String
hoursToString (Hours h) =
  formatFloat h 5


calculateResultAsString: Model -> String
calculateResultAsString model =
  calculateHours model
  |> hoursToString


view: Model -> Html Msg
view model =
      div [class "row column"]
      [
        div [] [ h1 [class "text-center"] [text "Mileage to Hours Converter"] ]
      , div [] [ viewForm model ]
      , div [class "callout success"]
            [ h4 [] [ text "Calculated Hours: ", text <| calculateResultAsString model] ]
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
               value (minutesToString model.mileageTime), onInput ChangeDriveMinutes] []
      , label [for "mileage-rate"] [text "Driving Hourly Rate ($/hr)"]
      , input [id "mileage-rate", type' "number", Html.Attributes.min "0",
               value (dphToString model.mileageRate), onInput ChangeDriveRate] []
      , label [for "hourly-rate"] [text "Base Hourly Rate ($/hr)"]
      , input [id "hourly-rate",  type' "number", Html.Attributes.min "0",
               value (dphToString model.hourlyRate), onInput ChangeHourlyRate] []
      ]
