// Generated by CoffeeScript 1.8.0

/*

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
 */

(function() {
  var reactevents, test;

  reactevents = require("./react-events");

  test = function() {
    var a_x, a_y, a_z, assert, b_x_i, b_x_j, b_y_i, b_y_j, b_y_k, b_z, ret;
    ret = [];
    a_x = reactevents.h("a.x");
    a_y = reactevents.h("a.y");
    a_z = reactevents.h("a.z");
    b_x_i = reactevents.h("b.x.i");
    b_x_j = reactevents.h("b.x.j");
    b_y_i = reactevents.h("b.y.i");
    b_y_j = reactevents.h("b.y.j");
    b_y_k = reactevents.h("b.y.k");
    b_z = reactevents.h("b.z");
    reactevents.on("a.x", function(p, e, m) {
      return ret.push(p);
    });
    reactevents.on("a.*", function(p, e, m) {
      return ret.push(m);
    });
    reactevents.on("b.*.i", function(p, e, m) {
      return ret.push(m);
    });
    reactevents.on("b.x.*", function(p, e, m) {
      return ret.push(m);
    });
    reactevents.on("b.*.*", function(p, e, m) {
      return ret.push(m);
    });
    reactevents.on("b.*", function(p, e, m) {
      return ret.push(m);
    });
    assert = require('assert');
    a_x();
    assert(ret.slice(-2)[0] === 'a.x' && ret.slice(-2)[1] === 'x');
    a_z();
    assert(ret.slice(-1)[0] === 'z');
    b_x_i();
    assert(ret.slice(-3)[0] === 'i' && ret.slice(-3)[1] === 'x' && ret.slice(-3)[2] === 'x.i');
    b_y_i();
    assert(ret.slice(-2)[0] === 'y' && ret.slice(-2)[1] === 'y.i');
    b_z();
    assert(ret.slice(-1)[0] === 'z');
    return console.log('test done');
  };

  if (typeof module !== 'undefined' && typeof require !== 'undefined' && require.main === module) {
    test();
  }

}).call(this);

//# sourceMappingURL=react-events-test.js.map
