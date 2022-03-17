module Util exposing (..)

filterEmpty: List (Maybe a) -> List a
filterEmpty maybes = List.filterMap identity maybes