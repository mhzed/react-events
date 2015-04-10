react-events
--------

A react mix-in for handling/routing events.

Event can be specified with ip address like name, using . to separate tokens.

Handler can then be registered to listen of event by exact match, or a simple pattern where * match
any single token.

Coffee-script Example:


    {div} = React.DOM
    
    module.exports = MyReactComponent = React.createClass
    
      mixins : [require "react-events"]
    
      render: ()->
        div
          div { onClick : @h('button.new') }
          div { onClick : @h('button.open') }
          div { onClick : @h('cb.x.y') }
          div { onClick : @h('cb.z.y') }
  
      componentDidMount : ()->
      
        @on "button.new" (p,e,m)->  # p is 'button.new', e is react event, m is ''
        @on "button.*" (p,e,m)->    # p is 'button.new' or 'button.open', e is react event, m is 'new' or 'open'
        @on "cb.*.y" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x or z
        @on "cb.*.*" (p,e,m)->      # p is 'cb.x.y' or 'cb.z.y', e is react event, m is x.y or z.y
        @on "cb.*" (p,e,m)->        # no match, never called, * matches a single token only

