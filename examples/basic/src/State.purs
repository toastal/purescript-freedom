module State where

import State.Route as Route
import State.PostsIndex as PostsIndex
import State.PostShow as PostShow
import State.PostEdit as PostEdit

-- NOTE: This state is simplified. For production, you should consider state shape.
type State =
  { route :: Route.State
  , postsIndex :: PostsIndex.State
  , postShow :: PostShow.State
  , postEdit :: PostEdit.State
  }

initialState :: State
initialState =
  { route: Route.initialState
  , postsIndex: PostsIndex.initialState
  , postShow: PostShow.initialState
  , postEdit: PostEdit.initialState
  }
