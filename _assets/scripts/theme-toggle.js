(function () {
  const storageKey = "theme";
  const className = "theme-toggle";

  const root = document.documentElement;
  const toggle = document.querySelector("." + className);
  if (!toggle) return;

  const prefersDark = window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches;
  const saved = localStorage.getItem(storageKey);
  const initial = saved || (prefersDark ? "dark" : "light");
  root.setAttribute("data-theme", initial);

  const setIcon = (theme) => {
    const icon = toggle.querySelector("i");
    if (!icon) return;
    icon.className = "fas fa-adjust";
    toggle.setAttribute("aria-label", theme === "dark" ? "Switch to light mode" : "Switch to dark mode");
  };

  setIcon(initial);

  toggle.addEventListener("click", () => {
    const next = root.getAttribute("data-theme") === "dark" ? "light" : "dark";
    root.setAttribute("data-theme", next);
    localStorage.setItem(storageKey, next);
    setIcon(next);
  });
})();
