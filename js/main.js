/* ==========================================================================
   Yihang Chen — portfolio behaviour
   Vanilla JS, no dependencies. Everything is progressive enhancement:
   with JS off the site still reads and navigates fine.
   ========================================================================== */
(function () {
  "use strict";

  var doc = document;
  var root = doc.documentElement;

  /* --- Theme -------------------------------------------------------------
     The <head> of every page sets data-theme before first paint, so there is
     no flash. This part only handles the toggle and keeps the button honest. */
  var themeToggle = doc.querySelector("[data-theme-toggle]");
  var themeMeta = doc.querySelector('meta[name="theme-color"]');

  function applyTheme(theme, persist) {
    root.setAttribute("data-theme", theme);
    if (themeToggle) {
      themeToggle.setAttribute("aria-pressed", theme === "dark" ? "true" : "false");
      themeToggle.setAttribute(
        "aria-label",
        theme === "dark" ? "Switch to light theme" : "Switch to dark theme"
      );
    }
    if (themeMeta) {
      themeMeta.setAttribute("content", theme === "dark" ? "#121619" : "#f7f4ed");
    }
    if (persist) {
      try {
        localStorage.setItem("theme", theme);
      } catch (err) {
        /* private mode — ignore */
      }
    }
  }

  applyTheme(root.getAttribute("data-theme") === "dark" ? "dark" : "light", false);

  if (themeToggle) {
    themeToggle.addEventListener("click", function () {
      var next = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
      applyTheme(next, true);
    });
  }

  /* Follow the OS only while the visitor has not made an explicit choice. */
  var mq = window.matchMedia("(prefers-color-scheme: dark)");
  if (mq.addEventListener) {
    mq.addEventListener("change", function (event) {
      var saved = null;
      try {
        saved = localStorage.getItem("theme");
      } catch (err) {
        /* ignore */
      }
      if (!saved) {
        applyTheme(event.matches ? "dark" : "light", false);
      }
    });
  }

  /* --- Mobile navigation -------------------------------------------------- */
  var navToggle = doc.querySelector("[data-nav-toggle]");
  var siteNav = doc.getElementById("site-nav");

  function closeNav() {
    if (!siteNav || !navToggle) return;
    siteNav.classList.remove("is-open");
    navToggle.setAttribute("aria-expanded", "false");
    navToggle.setAttribute("aria-label", "Open menu");
  }

  if (navToggle && siteNav) {
    navToggle.addEventListener("click", function () {
      var open = siteNav.classList.toggle("is-open");
      navToggle.setAttribute("aria-expanded", open ? "true" : "false");
      navToggle.setAttribute("aria-label", open ? "Close menu" : "Open menu");
    });

    siteNav.addEventListener("click", function (event) {
      if (event.target.closest("a")) closeNav();
    });

    doc.addEventListener("keydown", function (event) {
      if (event.key !== "Escape") return;
      if (!siteNav.classList.contains("is-open")) return;
      closeNav();
      navToggle.focus();
    });

    doc.addEventListener("click", function (event) {
      if (!siteNav.classList.contains("is-open")) return;
      if (siteNav.contains(event.target) || navToggle.contains(event.target)) return;
      closeNav();
    });
  }

  /* --- Header shadow on scroll ------------------------------------------- */
  var header = doc.querySelector(".site-header");
  var toTop = doc.querySelector("[data-to-top]");

  function onScroll() {
    var y = window.scrollY || 0;
    if (header) header.classList.toggle("is-scrolled", y > 8);
    if (toTop) toTop.classList.toggle("is-visible", y > 600);
  }

  onScroll();
  window.addEventListener("scroll", onScroll, { passive: true });

  if (toTop) {
    toTop.addEventListener("click", function () {
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }

  /* --- Project filter -----------------------------------------------------
     Buttons are real buttons with aria-pressed; cards are <li> with a
     data-category. The visible count is announced through aria-live. */
  var filterBar = doc.querySelector("[data-filter-bar]");
  var projectList = doc.querySelector("[data-project-list]");

  if (filterBar && projectList) {
    var buttons = Array.prototype.slice.call(
      filterBar.querySelectorAll("[data-filter]")
    );
    var cards = Array.prototype.slice.call(
      projectList.querySelectorAll("[data-category]")
    );
    var countEl = doc.querySelector("[data-result-count]");
    var emptyEl = doc.querySelector("[data-empty-state]");

    function applyFilter(value) {
      var shown = 0;
      cards.forEach(function (card) {
        var cats = (card.getAttribute("data-category") || "").split(/\s+/);
        var match = value === "all" || cats.indexOf(value) !== -1;
        card.hidden = !match;
        if (match) shown += 1;
      });

      buttons.forEach(function (btn) {
        btn.setAttribute(
          "aria-pressed",
          btn.getAttribute("data-filter") === value ? "true" : "false"
        );
      });

      if (countEl) {
        countEl.textContent = "Showing " + shown + " / " + cards.length + " projects";
      }
      if (emptyEl) emptyEl.hidden = shown !== 0;
    }

    buttons.forEach(function (btn) {
      btn.addEventListener("click", function () {
        applyFilter(btn.getAttribute("data-filter"));
      });
    });

    /* Keyboard: arrow keys move between filters, like a radio group. */
    filterBar.addEventListener("keydown", function (event) {
      if (event.key !== "ArrowRight" && event.key !== "ArrowLeft") return;
      var index = buttons.indexOf(doc.activeElement);
      if (index === -1) return;
      event.preventDefault();
      var delta = event.key === "ArrowRight" ? 1 : -1;
      var next = buttons[(index + delta + buttons.length) % buttons.length];
      next.focus();
      next.click();
    });
  }

  /* --- Copy to clipboard -------------------------------------------------- */
  Array.prototype.forEach.call(
    doc.querySelectorAll("[data-copy]"),
    function (button) {
      button.addEventListener("click", function () {
        var value = button.getAttribute("data-copy");
        var original = button.textContent;

        function done(ok) {
          button.textContent = ok ? "Copied" : "Copy manually";
          window.setTimeout(function () {
            button.textContent = original;
          }, 1800);
        }

        if (navigator.clipboard && window.isSecureContext) {
          navigator.clipboard.writeText(value).then(
            function () {
              done(true);
            },
            function () {
              done(false);
            }
          );
        } else {
          var field = doc.createElement("textarea");
          field.value = value;
          field.setAttribute("readonly", "");
          field.style.position = "fixed";
          field.style.opacity = "0";
          doc.body.appendChild(field);
          field.select();
          try {
            done(doc.execCommand("copy"));
          } catch (err) {
            done(false);
          }
          doc.body.removeChild(field);
        }
      });
    }
  );

  /* --- Contact form -------------------------------------------------------
     No backend on a static site. Validate in the browser, then hand the
     message to the visitor's mail client via a mailto: link. */
  var form = doc.querySelector("[data-contact-form]");

  if (form) {
    var statusEl = form.querySelector("[data-form-status]");
    var email = form.getAttribute("data-mailto") || "";

    function setError(field, message) {
      var error = doc.getElementById(field.id + "-error");
      field.setAttribute("aria-invalid", message ? "true" : "false");
      if (error) {
        error.textContent = message || "";
        error.classList.toggle("is-visible", Boolean(message));
      }
    }

    form.addEventListener("submit", function (event) {
      event.preventDefault();
      var name = form.elements.name;
      var from = form.elements.email;
      var message = form.elements.message;
      var valid = true;

      if (!name.value.trim()) {
        setError(name, "Tell me what to call you.");
        valid = false;
      } else {
        setError(name, "");
      }

      if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(from.value.trim())) {
        setError(from, "That email doesn't look complete.");
        valid = false;
      } else {
        setError(from, "");
      }

      if (message.value.trim().length < 10) {
        setError(message, "At least 10 characters, so I know what you mean.");
        valid = false;
      } else {
        setError(message, "");
      }

      if (!valid) {
        if (statusEl) {
          statusEl.textContent = "A few fields need fixing.";
          statusEl.className = "form-status is-error";
        }
        var firstBad = form.querySelector('[aria-invalid="true"]');
        if (firstBad) firstBad.focus();
        return;
      }

      var subject = encodeURIComponent("[Portfolio] " + name.value.trim());
      var body = encodeURIComponent(
        message.value.trim() + "\n\n— " + name.value.trim() + "\n" + from.value.trim()
      );
      window.location.href = "mailto:" + email + "?subject=" + subject + "&body=" + body;

      if (statusEl) {
        statusEl.textContent = "Opening your email client…";
        statusEl.className = "form-status is-ok";
      }
    });

    Array.prototype.forEach.call(form.querySelectorAll("input, textarea"), function (field) {
      field.addEventListener("input", function () {
        if (field.getAttribute("aria-invalid") === "true") setError(field, "");
      });
    });
  }

  /* --- Reveal on scroll --------------------------------------------------- */
  var reveals = Array.prototype.slice.call(doc.querySelectorAll(".reveal"));

  if ("IntersectionObserver" in window && reveals.length) {
    var observer = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add("is-visible");
            observer.unobserve(entry.target);
          }
        });
      },
      { rootMargin: "0px 0px -8% 0px", threshold: 0.05 }
    );
    reveals.forEach(function (el) {
      observer.observe(el);
    });
  } else {
    reveals.forEach(function (el) {
      el.classList.add("is-visible");
    });
  }

  /* --- Footer year -------------------------------------------------------- */
  Array.prototype.forEach.call(doc.querySelectorAll("[data-year]"), function (el) {
    el.textContent = String(new Date().getFullYear());
  });
})();
