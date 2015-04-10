###

A react mix-in for handling/routing events.
Event can be specified with ip address like name, using . to separate tokens.
Handler can then be registered to listen of event by exact match, or a simple pattern where * match
any single token.

Example:

  render : ()->
    React.DOM.div
      React.DOM.div { onClick : @h('button.new') }
      React.DOM.div { onClick : @h('button.open') }
      React.DOM.div { onClick : @h('cb.x.y') }
      React.DOM.div { onClick : @h('cb.z.y') }

  myComp.on "button.new" (p,e,m)->  # p is 'button.new', e is react event, m is ''
  myComp.on "button.*" (p,e,m)->    # p is 'button.new' or 'button.open', e is react event, m is 'new' or 'open'
  myComp.on "cb.*.y" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x or z
  myComp.on "cb.*.*" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x.y or z.y
  myComp.on "cb.*" (p,e,m)->        # no match, never called, * matches a single token only

###


module.exports = evRouterMixin = {

  # register callbacks on an event name, cb(param, event, match)
  # param:  the original param object provided by h(param)
  # event:  the react event
  # match:  if param.name or param contains *, then stores matched token(s) as string, see test
  on : (name, cb)->
    [path..., last] = name.split(".")
    tree = @_evRoutes ||= {}                # @_evRoutes is a tree, 1 token = 1 level
    (tree = tree[t] ||= {__ehs: []} ) for t in path  # make tree via path
    tree[last] ||= {__ehs: []}
    tree[last].__ehs.push cb                # store cb

  # return the method to be used as 'onClick' property
  # param may be an object, which then must contain property name
  # i.e. R.div { onClick: h('open') }
  #      R.div { onClick: h( {name: 'open', key:'val'} )
  h : (param)-> @_evClick.bind(@, param)

  # private call when ui action takes place, call registered handlers
  _evClick : (param, event)->
    name = if 'string' == typeof param then param else param.name
    walk = (toks, tree, match)=>
      t = toks[0]
      if toks.length == 1
        h(param, event, match[...-1]) for h in (tree[t] or @__l).__ehs
        h(param, event, match + t) for h in (tree['*'] or @__l).__ehs
      else
        if t of tree then walk(toks[1..], tree[t], match)
        if '*' of tree then walk(toks[1..], tree['*'], match + t + ".")
    if @_evRoutes then walk(name.split("."), @_evRoutes, '')

  __l : {__ehs:[]}
}
