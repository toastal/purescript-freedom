module Main where

import Prelude

import Effect (Effect)
import Freedom as Freedom
import Freedom.Markup as H
import Freedom.TransformF.Simple (VQueryF, transformF)
import Freedom.VNode (VNode)

type State = Unit

type Html = VNode VQueryF State

main :: Effect Unit
main = Freedom.run
  { selector: "#app"
  , initialState: unit
  , subscriptions: []
  , transformF
  , view
  }

view :: State -> Html
view _ =
  H.el $ H.tag "svg"
    # H.css cssSVG
    # H.prop "viewBox" "0 0 1000 600"
    # H.kids
        [ H.el $ H.tag "symbol" # H.id "s-text" # H.kids
            [ H.el $ H.tag "text"
                # H.prop "text-anchor" "middle"
                # H.prop "x" "50%"
                # H.prop "y" "68%"
                # H.kids [ H.t "Freedom" ]
            ]
        , H.el $ H.tag "g" # H.kids
            [ H.el $ H.tag "use" # H.css cssUse # H.prop "xlink:href" "#s-text"
            , H.el $ H.tag "use" # H.css cssUse # H.prop "xlink:href" "#s-text"
            , H.el $ H.tag "use" # H.css cssUse # H.prop "xlink:href" "#s-text"
            , H.el $ H.tag "use" # H.css cssUse # H.prop "xlink:href" "#s-text"
            , H.el $ H.tag "use" # H.css cssUse # H.prop "xlink:href" "#s-text"
            ]
        ]
  where
    cssSVG =
      """
      html, body { height: 100%; }
      body {
        background: #082330;
        background-size: .12em 100%;
        font: 16em/1 Arial;
      }
      .& {
        position: absolute;
        width: 100%;
        height: 100%;
      }
      """
    cssUse =
      """
      .& {
        fill: none;
        stroke: white;
        stroke-dasharray: 7% 28%;
        stroke-width: 3px;
        animation: & 9s infinite cubic-bezier(.48,1.45,.86,1.15);
      }
      .&:nth-child(1) { stroke: #360745; stroke-dashoffset: 7%; }
      .&:nth-child(2) { stroke: #D61C59; stroke-dashoffset: 14%; }
      .&:nth-child(3) { stroke: #E7D84B; stroke-dashoffset: 21%; }
      .&:nth-child(4) { stroke: #EFEAC5; stroke-dashoffset: 28%; }
      .&:nth-child(5) { stroke: #1B8798; stroke-dashoffset: 35%; }
      @keyframes & {
        50% {
          stroke-dashoffset: 35%;
          stroke-dasharray: 0 87.5%;
        }
      }
      """
