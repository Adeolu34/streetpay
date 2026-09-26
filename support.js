(function () {
  'use strict';

  // ── DCLogic base class ───────────────────────────────────────────────────
  window.DCLogic = class DCLogic {
    setState(updater) {
      var delta = typeof updater === 'function' ? updater(this.state) : updater;
      this.state = Object.assign({}, this.state, delta);
      _schedule();
    }
  };

  var _comp = null;
  var _raf  = 0;

  function _schedule() {
    if (_raf) return;
    _raf = requestAnimationFrame(function () {
      _raf = 0;
      if (_comp) doRender(_comp.renderVals());
    });
  }

  // ── Binding stores ───────────────────────────────────────────────────────
  var textBindings = []; // { node, tpl }
  var attrBindings = []; // { el, name, tpl }
  var scIfBindings = []; // { el, key }

  function collect(root) { walk(root); }

  function walk(node) {
    if (node.nodeType === 3) {
      if (node.textContent.indexOf('{{') !== -1)
        textBindings.push({ node: node, tpl: node.textContent });
      return;
    }
    if (node.nodeType !== 1) return;

    if (node.tagName.toLowerCase() === 'sc-if') {
      var m = (node.getAttribute('value') || '').match(/\{\{\s*(\w+)\s*\}\}/);
      if (m) scIfBindings.push({ el: node, key: m[1] });
    }

    var attrs = node.attributes;
    for (var i = 0; i < attrs.length; i++) {
      var a = attrs[i];
      if (a.value.indexOf('{{') === -1) continue;
      var an = a.name.toLowerCase();
      if (an === 'onclick' || an === 'value' || an === 'style-hover' || an === 'hint-placeholder-val') continue;
      attrBindings.push({ el: node, name: a.name, tpl: a.value });
    }

    for (var j = 0; j < node.childNodes.length; j++) walk(node.childNodes[j]);
  }

  function interp(tpl, vals) {
    return tpl.replace(/\{\{\s*(\w+)\s*\}\}/g, function (_, k) {
      var v = vals[k];
      return v == null ? '' : v;
    });
  }

  var _vals = {};

  function doRender(vals) {
    _vals = vals;
    for (var i = 0; i < scIfBindings.length; i++) {
      var b = scIfBindings[i];
      if (vals[b.key]) b.el.removeAttribute('data-dc-hidden');
      else             b.el.setAttribute('data-dc-hidden', '');
    }
    for (var j = 0; j < textBindings.length; j++) {
      var tb = textBindings[j];
      var tv = interp(tb.tpl, vals);
      if (tb.node.textContent !== tv) tb.node.textContent = tv;
    }
    for (var k = 0; k < attrBindings.length; k++) {
      var ab = attrBindings[k];
      var av = interp(ab.tpl, vals);
      if (ab.el.getAttribute(ab.name) !== av) ab.el.setAttribute(ab.name, av);
    }
  }

  // ── Boot ────────────────────────────────────────────────────────────────
  document.addEventListener('DOMContentLoaded', function () {

    // 1. Inject base styles
    var css = document.createElement('style');
    css.textContent =
      'sc-if{display:block}' +
      'sc-if[data-dc-hidden]{display:none!important}' +
      'x-dc,x-import,helmet{display:block}';
    document.head.appendChild(css);

    // 2. Promote <helmet> children into <head>
    var helmets = document.querySelectorAll('helmet');
    for (var h = 0; h < helmets.length; h++) {
      var hel = helmets[h];
      while (hel.firstChild) document.head.appendChild(hel.firstChild);
      hel.parentNode.removeChild(hel);
    }

    // 3. Replace <x-import> with a phone frame + scroll container
    var xImport = document.querySelector('x-import');
    if (xImport) {
      var frame = document.createElement('div');
      frame.style.cssText =
        'width:412px;border-radius:44px;overflow:hidden;background:#0B2018;' +
        'box-shadow:0 36px 100px rgba(0,0,0,.65),0 0 0 1px rgba(255,255,255,.06);' +
        'border:8px solid #1c1c1e;flex-shrink:0';

      var sb = document.createElement('div');
      sb.style.cssText =
        'height:50px;background:#0B2018;display:flex;align-items:flex-end;' +
        'justify-content:space-between;padding:0 22px 10px;position:relative;flex-shrink:0';
      sb.innerHTML =
        '<span style="color:#fff;font-size:12px;font-weight:700;font-family:\'Plus Jakarta Sans\',sans-serif">9:41</span>' +
        '<div style="position:absolute;left:50%;transform:translateX(-50%);top:0;width:110px;height:30px;background:#111;border-radius:0 0 18px 18px"></div>' +
        '<span style="color:#fff;font-size:11px;font-family:\'Plus Jakarta Sans\',sans-serif;letter-spacing:1px">●●● ▮</span>';

      var scroll = document.createElement('div');
      scroll.id = 'dc-root';
      scroll.style.cssText = 'height:842px;overflow-y:auto;overflow-x:hidden;-webkit-overflow-scrolling:touch';

      while (xImport.firstChild) scroll.appendChild(xImport.firstChild);
      frame.appendChild(sb);
      frame.appendChild(scroll);
      xImport.parentNode.replaceChild(frame, xImport);
    }

    // 4. Wire click delegation from every onClick="{{ onTap }}" element
    var clickRoots = document.querySelectorAll('[onClick]');
    for (var c = 0; c < clickRoots.length; c++) {
      (function (el) {
        el.removeAttribute('onClick');
        el.addEventListener('click', function (e) { if (_vals.onTap) _vals.onTap(e); });
      }(clickRoots[c]));
    }

    // 5. Hover-style support
    var hovered = (typeof WeakSet !== 'undefined') ? new WeakSet() : null;

    document.addEventListener('mouseover', function (e) {
      var el = e.target && e.target.closest ? e.target.closest('[style-hover]') : null;
      if (!el) return;
      if (hovered && hovered.has(el)) return;
      if (hovered) hovered.add(el);
      if (el._origStyle === undefined) el._origStyle = el.getAttribute('style') || '';
      var base = el._origStyle.trim();
      if (base && base[base.length - 1] !== ';') base += ';';
      el.style.cssText = base + el.getAttribute('style-hover');
    });

    document.addEventListener('mouseout', function (e) {
      var el = e.target && e.target.closest ? e.target.closest('[style-hover]') : null;
      if (!el) return;
      if (hovered && !hovered.has(el)) return;
      if (el.contains(e.relatedTarget)) return;
      if (hovered) hovered.delete(el);
      el.style.cssText = el._origStyle || '';
    });

    // 6. Collect template bindings
    var root = document.getElementById('dc-root');
    if (root) collect(root);

    // 7. Eval the component (indirect eval → global scope so class is reachable)
    var scriptEl = document.querySelector('script[type="text/x-dc"]');
    if (!scriptEl) return;
    try {
      // eslint-disable-next-line no-eval
      (0, eval)(scriptEl.textContent);
    } catch (err) {
      console.error('[DC] Component error:', err);
      return;
    }

    if (typeof Component === 'undefined') return; // eslint-disable-line no-undef

    _comp = new Component(); // eslint-disable-line no-undef
    if (_comp.componentDidMount) _comp.componentDidMount();
    doRender(_comp.renderVals());
  });

}());
