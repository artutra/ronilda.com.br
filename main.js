// Initial data passed to Elm (should match `Flags` defined in `Shared.elm`)
// https://guide.elm-lang.org/interop/flags.html
var flags = null

const elmActions = {
  ScrollTo: (req, tries = 0) => {
    if (3 < tries) return;
    const element = document.getElementById(req.data.id);
    if (!element) {
      window.requestAnimationFrame(() => elmActions.ScrollTo(req, tries + 1));
      return;
    }
    if (typeof element.scrollTo === "function") {
      element.scrollTo(req.data.config);
    } else {
      element.scrollTop = req.data.config.top;
      element.scrollLeft = req.data.config.left;
    }
    if (req.response) app.ports.toElm.send(req.response);
  }
}

// Start our Elm application
var app = Elm.Main.init({ flags: flags })

// Register elm ports
app.ports.toJavascript.subscribe((req) => {
  const action = elmActions[req.id];
  if (typeof action === "undefined") {
    console.error('elmPort invalid id', req.id);
    return;
  }
  action(req);
});

// Ports go here
// https://guide.elm-lang.org/interop/ports.html