###

A react mix-in for handling/routing events.
Event can be specified with ip address like name, using . to separate tokens.
Handler can then be registered to listen of event by exact match name, or a simple pattern where * match
any single token.

Example:

  render : ()->
    React.DOM.div
      React.DOM.div { onClick : @h('button.new') }
      React.DOM.div { onClick : @h('button.open') }
      React.DOM.div { onClick : @h('cb.x.y') }
      React.DOM.div { onClick : @h('cb.z.y') }

  myComp.on "button.new" (p,e,m)->  # p is 'button.new', e is react event, m is ''
  myComp.on "button.*" (p,e,m)->    # p is 'button.new' or 'button.open', e is react event, m is new or open
  myComp.on "cb.*.y" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x or z
  myComp.on "cb.*.*" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x.y or z.y
  myComp.on "cb.*" (p,e,m)->        # no match, never called, * matches a single token only

###

reactevents = require "./react-events"

test = ()->
  ret = []
  a_x = reactevents.h("a.x")
  a_y = reactevents.h("a.y")
  a_z = reactevents.h("a.z")

  b_x_i = reactevents.h("b.x.i")
  b_x_j = reactevents.h("b.x.j")
  b_y_i = reactevents.h("b.y.i")
  b_y_j = reactevents.h("b.y.j")
  b_y_k = reactevents.h("b.y.k")
  b_z = reactevents.h("b.z")

  reactevents.on "a.x", (p,e,m)->ret.push p
  reactevents.on "a.*", (p,e,m)->ret.push m

  reactevents.on "b.*.i", (p,e,m)->ret.push m
  reactevents.on "b.x.*", (p,e,m)->ret.push m
  reactevents.on "b.*.*", (p,e,m)->ret.push m
  reactevents.on "b.*", (p,e,m)->ret.push m

  assert = require 'assert'
  #
  a_x()
  assert ret[-2..][0] == 'a.x' && ret[-2..][1] == 'x'

  a_z()
  assert ret[-1..][0] == 'z'

  b_x_i()
  assert ret[-3..][0] == 'i' && ret[-3..][1] == 'x' && ret[-3..][2] == 'x.i'

  b_y_i()
  assert ret[-2..][0] == 'y' && ret[-2..][1] == 'y.i'

  b_z()
  assert ret[-1..][0] == 'z'

  console.log 'test done'

if typeof module != 'undefined' and typeof require != 'undefined' and require.main == module
  test()