import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="theme"
export default class extends Controller {
  update() {
    // Retrieve the selected theme from localStorage
    let savedTheme = localStorage.getItem("selectedTheme");
    console.log(savedTheme)

    if(savedTheme == "dark")
    {
      localStorage.setItem("selectedTheme", 'dracula');
      applyTheme(localStorage.getItem("selectedTheme"));
    }
    else
    {
      localStorage.setItem("selectedTheme", 'dark');
      applyTheme(localStorage.getItem("selectedTheme"));
    }

      // Function to apply the selected theme
  function applyTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    console.log(theme)
  }
  }
}
