(function() {
  var $document, $window, anchors, create, encode, handleDemoFormSubmit, local, prettify, sections, setupCode, setupLinks, setupNav, setupTracking, setupWindow, slugify, successElem, track;

  setupCode = function() {
    var insertCode;
    insertCode = function(container, pre) {
      var content, i, indentation, l, line, lines, m;
      if (container.length === 0 || pre.length === 0) {
        return;
      }
      content = container.html();
      lines = content.split("\n");
      indentation = void 0;
      content = "";
      i = 0;
      l = lines.length;
      while (i < l) {
        line = lines[i];
        if (i > 0 && i < l - 1) {
          if (indentation === undefined) {
            m = line.match(/^(\ *)/);
            if (m) {
              indentation = m[1];
            }
          }
          line = line.replace(new RegExp("^" + indentation), "");
          content += line + "\n";
        }
        ++i;
      }
      return pre.append(prettify(content));
    };
    $(".demo").each(function() {
      var demo, htmlDemo, htmlPre, scriptDemo, scriptPre;
      demo = $(this);
      htmlDemo = demo.find("div[data-html]");
      htmlPre = demo.find("pre[data-html]");
      scriptDemo = demo.find("script[data-script]");
      scriptPre = demo.find("pre[data-script]");
      insertCode(htmlDemo, htmlPre);
      return insertCode(scriptDemo, scriptPre);
    });
    return $(".highlight-col3-table tbody tr").each(function() {
      var codeCol;
      codeCol = $(this).children().eq(2);
      return codeCol.html(prettify(codeCol.html()));
    });
  };

  encode = function(value) {
    return $("<div/>").text(value).html();
  };

  prettify = function(str) {
    return prettyPrintOne(encode(str));
  };

  create = function(type) {
    return $(document.createElement(type));
  };

  slugify = function(title) {
    return title.replace(/\s/g, "-").toLowerCase();
  };

  local = function() {
    return /localhost/.test(window.location.host);
  };

  setupLinks = function() {
    var get;
    get = function(id) {
      return $("[data-anchor=" + id + "]");
    };
    $("a[data-link]").each(function() {
      var curr, id;
      curr = $(this).attr('data-link');
      if (curr && curr !== 'data-link') {
        id = curr;
      } else {
        id = slugify($.trim($(this).text()));
      }
      $(this).attr('href', '#' + id);
      if (get(id).length === 0) {
        return console.warn("missing: ", id);
      }
    });
    $("[data-anchor]").each(function() {
      var curr, id;
      curr = $(this).attr('data-anchor');
      if (curr && curr !== 'data-anchor') {
        return;
      }
      id = slugify($.trim($(this).text()));
      return $(this).attr('data-anchor', id);
    });
    $window.on('hashchange', function() {
      var elem, hash;
      hash = location.hash.substr(1);
      if (!hash) {
        return;
      }
      track('Go To', hash);
      elem = get(hash);
      if (elem.length === 0) {
        return alert("Sorry those docs are still in progress !");
      } else {
        return $('html,body').animate({
          scrollTop: elem.offset().top
        }, {
          duration: 1000,
          easing: 'easeInOutExpo'
        });
      }
    });
    return $window.trigger('hashchange');
  };

  sections = [];

  anchors = [];

  setupNav = function() {
    var activeInView, anchorTemplate, check, headerTemplate, navList, setupNavAnchor, setupNavHeading;
    setupNavHeading = function() {
      var container, first, heading, li, section, slug;
      section = $(this);
      heading = section.data("nav");
      slug = slugify(heading);
      first = section.children(":first");
      if (!first.is("h3")) {
        section.prepend(create("h3").html(heading));
      }
      section.attr("data-anchor", slug);
      li = headerTemplate({
        heading: heading
      });
      container = create("div").addClass("nav-section");
      container.append(li);
      $(this).find(".demo[data-nav]").each(function() {
        return setupNavAnchor(container, $(this));
      });
      navList.append(container);
      return sections.push({
        type: 'section',
        content: section,
        nav: container
      });
    };
    setupNavAnchor = function(container, anchor) {
      var first, li, slug, title;
      title = anchor.data("nav");
      slug = slugify(title);
      first = anchor.children(":first");
      if (!first.is("h4")) {
        anchor.prepend(create("h4").html(title));
      }
      anchor.attr("data-anchor", slug);
      li = $(anchorTemplate({
        title: title,
        slug: slug
      }));
      container.append(li);
      return anchors.push({
        type: 'anchor',
        content: anchor,
        nav: li,
        title: title
      });
    };
    headerTemplate = _.template("<li class='nav-header'><%= heading %></li>");
    anchorTemplate = _.template("<li class='nav-item'><a href='#<%= slug %>''><%= title %></a></li>");
    navList = $("#nav-list");
    $(".section[data-nav]").each(setupNavHeading);
    check = function() {
      _.each(sections, activeInView);
      return _.each(anchors, activeInView);
    };
    activeInView = function(obj) {
      var isActive;
      isActive = obj.content.is(':in-viewport');
      return obj.nav.toggleClass('active', isActive);
    };
    $document.scroll(_.throttle(check));
    return $document.trigger('scroll');
  };

  track = function(cat, act, lab, val) {
    var event;
    event = ['_trackEvent', cat, act, lab, val];
    if (!local()) {
      return _gaq.push(event);
    }
  };

  setupTracking = function() {
    var t, timers;
    $document.on('click', 'input[type=submit]', function() {
      var anchor;
      anchor = $(this).closest("[data-nav]");
      if (anchor[0]) {
        return track('Demo Submit', anchor.attr('data-nav'));
      }
    });
    timers = {};
    t = function() {
      return new Date().getTime();
    };
    return window.trackTiming = function(title, active) {
      var ms;
      if (timers[title] && !active) {
        ms = t() - timers[title];
        if (ms > 3000) {
          track('Anchor View Length', title, '', ms);
        }
        timers[title] = null;
      }
      if (!timers[title] && active) {
        return timers[title] = t();
      }
    };
  };

  setupWindow = function() {};

  $.fn.togglers = function() {
    var container, togglers;
    container = $(this);
    togglers = container.find("[data-toggle]");
    return togglers.each(function() {
      var btn, elem, selector;
      btn = $(this);
      selector = btn.attr("data-toggle");
      elem = container.find(selector);
      if (elem.length === 0) {
        return;
      }
      return btn.click(function() {
        var text, visible;
        visible = elem.is(":visible");
        text = btn.html();
        btn.html(text.replace(/hide|show/i, (visible ? "Show" : "Hide")));
        if (visible) {
          return elem.slideUp();
        } else {
          return elem.slideDown();
        }
      });
    });
  };

  handleDemoFormSubmit = function() {
    $(this).append(successElem.hide().stop().slideDown().delay(2000).slideUp());
    return false;
  };

  successElem = $("<div class=\"alert alert-success\"><strong>" + "Validation successful ! </strong> If this was a real form, " + "it would be submitting right now...</div>");

  $window = $(window);

  $document = $(document);

  $document.ready(function() {
    setupTracking();
    setupCode();
    setupNav();
    setupLinks();
    setupWindow();
    $(".loading-cover").fadeOut("fast");
    window.prettyPrint();
    return $document.on("submit", "form", handleDemoFormSubmit);
  });

}).call(this);
