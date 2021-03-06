module View.PostEdit
  ( view
  ) where

import Prelude

import Action.PostEdit (fetchPost, updatePost)
import Data.Maybe (Maybe(..), isNothing)
import Data.Symbol (SProxy(..))
import Effect.Class (liftEffect)
import Entity.Post (updateTitle, updateBody)
import Freedom.Markup as H
import Freedom.Router (link)
import Record as R
import State.PostEdit (State)
import TransformF (reduce)
import Type (Html, Action)
import View.Common (withRequest)
import View.NotFound as NotFound
import Web.Event.Event (Event, target)
import Web.HTML.HTMLInputElement as Input
import Web.HTML.HTMLTextAreaElement as TextArea

-- View

view :: Int -> State -> Html
view postId { request, update, post } =
  withRequest request (fetchPost postId)
    case post of
      Nothing -> NotFound.view
      Just post' ->
        H.el $ H.div # H.kids
          [ if isNothing update.statusCode
              then H.el $ H.span
              else H.el $ H.p
                      # H.css cssErr
                      # H.kids [ H.t "Sorry..., something went wrong." ]
          , H.el $ H.h2 # H.kids
              [ H.el $ H.input
                  # H.onChange changeTitle
                  # H.css cssInput
                  # H.type_ "text"
                  # H.value post'.title
              ]
          , H.el $ H.textarea
              # H.onChange changeBody
              # H.css cssTextarea
              # H.kids [ H.t post'.body ]
          , H.el $ H.div
              # H.css cssBottom
              # H.kids
                  [ H.el $ link ("/posts/" <> show post'.id)
                      # H.css cssCancel
                      # H.kids [ H.t "CANCEL" ]
                  , H.el $ H.button
                      # H.onClick (const updatePost)
                      # H.kids [ H.t if update.requesting then "SENDING..." else "SAVE" ]
                  ]
          ]
  where
    cssErr = ".& { color: #ED6D46; }"
    cssInput =
      """
      .& {
        font-size: 24px;
        font-weight: bold;
        width: 100%;
      }
      """
    cssTextarea =
      """
      .& {
        font-size: 16px;
        width: 100%;
        height: 50vh;
      }
      """
    cssCancel =
      """
      .& { margin-right: 8px; }
      .&:hover { color: #898989; }
      """
    cssBottom =
      """
      .& {
        display: flex;
        justify-content: flex-end;
        align-items: center;
        padding: 16px 0;
      }
      """

-- Action

changeTitle :: Event -> Action
changeTitle evt =
  case Input.fromEventTarget <$> target evt of
    Just (Just el) -> do
      title <- liftEffect $ Input.value el
      reduce
        $ R.modify (SProxy :: _ "postEdit")
        $ R.modify (SProxy :: _ "post")
        $ map (updateTitle title)
    _ -> pure unit

changeBody :: Event -> Action
changeBody evt =
  case TextArea.fromEventTarget <$> target evt of
    Just (Just el) -> do
      body <- liftEffect $ TextArea.value el
      reduce
        $ R.modify (SProxy :: _ "postEdit")
        $ R.modify (SProxy :: _ "post")
        $ map (updateBody body)
    _ -> pure unit
