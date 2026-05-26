(function () {
  "use strict";

  var TEXT_NODE = 3;
  var ACCENT_TOKEN_NORMALIZATIONS = {
    "\u0307": "\u02d9"
  };

  function hasTrueAttr(element, name) {
    return (element.getAttribute(name) || "").toLowerCase() === "true";
  }

  function isSingleTextToken(element, localName) {
    return (
      element &&
      element.localName === localName &&
      element.childNodes.length === 1 &&
      element.firstChild &&
      element.firstChild.nodeType === TEXT_NODE
    );
  }

  function normalizeAccentContainer(element) {
    var accent = element.children[1];

    if (!isSingleTextToken(accent, "mo")) {
      return;
    }

    var normalized = ACCENT_TOKEN_NORMALIZATIONS[accent.firstChild.nodeValue];

    if (normalized) {
      accent.firstChild.nodeValue = normalized;
    }
  }

  function normalizeElement(element) {
    if (
      element.localName === "mover" &&
      hasTrueAttr(element, "accent")
    ) {
      normalizeAccentContainer(element);
      return;
    }

    if (
      element.localName === "munder" &&
      hasTrueAttr(element, "accentunder")
    ) {
      normalizeAccentContainer(element);
    }
  }

  function normalizeRoot(root) {
    var elements;
    var i;

    if (!root || root.nodeType !== 1) {
      return;
    }

    normalizeElement(root);

    elements = root.querySelectorAll("mover[accent],munder[accentunder]");
    for (i = 0; i < elements.length; i += 1) {
      normalizeElement(elements[i]);
    }
  }

  function normalizeDocument() {
    normalizeRoot(document.documentElement);
  }

  function observeMathML() {
    if (!window.MutationObserver || !document.body) {
      return;
    }

    new MutationObserver(function (mutations) {
      var i;
      var j;
      var nodes;

      for (i = 0; i < mutations.length; i += 1) {
        nodes = mutations[i].addedNodes;
        for (j = 0; j < nodes.length; j += 1) {
          normalizeRoot(nodes[j]);
        }
      }
    }).observe(document.body, { childList: true, subtree: true });
  }

  if (document.readyState === "loading") {
    document.addEventListener(
      "DOMContentLoaded",
      function () {
        normalizeDocument();
        observeMathML();
      },
      { once: true }
    );
  } else {
    normalizeDocument();
    observeMathML();
  }
})();
