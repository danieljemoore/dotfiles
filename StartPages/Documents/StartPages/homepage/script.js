// Note: having length != 4 will mess with layout based on how the site is styled
const bookmarks = [
  {
    title: "Daily",
    links: [
      { name: "Inbox", url: "https://inbox.google.com" },
      { name: "GitHub", url: "https://github.com" },
      { name: "Drive", url: "https://drive.google.com" },
    ],
  },
  {
    title: "Media",
    links: [
      { name: "Youtube", url: "https://youtube.com" },
      { name: "Paramount", url: "https://www.paramountplus.com/home/" },
      { name: "FMovies", url: "https://fmovies24.to/" },
    ],
  },
  {
    title: "Learning",
    links: [
      { name: "deeplearning.ai", url: "https://learn.deeplearning.ai/" },
      {
        name: "O'Reilly",
        url: "https://learning.oreilly.com/home/",
      },
      {
        name: "MDN Web Docs",
        url: "https://developer.mozilla.org/en-US/",
      },
      { name: "leetcode", url: "https://leetcode.com/problemset/" },
    ],
  },
  {
    title: "Social",
    links: [
      { name: "X", url: "https://twitter.com" },
      { name: "Facebook", url: "https://facebook.com" },
    ],
  },
];

const searchUrl = "https://google.com/search?q=";
// Search on enter key event
function search(e) {
  if (e.keyCode == 13) {
    var val = document.getElementById("search-field").value;
    window.open(searchUrl + val);
  }
}
// Get current time and format
function getTime() {
  let date = new Date(),
    min = date.getMinutes(),
    sec = date.getSeconds(),
    hour = date.getHours();

  return (
    "" +
    (hour < 10 ? "0" + hour : hour) +
    ":" +
    (min < 10 ? "0" + min : min) +
    ":" +
    (sec < 10 ? "0" + sec : sec)
  );
}
// Handle Weather request
function getWeather() {
  let xhr = new XMLHttpRequest();
  // Request to open weather map
  xhr.open(
    "GET",
    "http://api.openweathermap.org/data/2.5/weather?q=Rolla,mo,us&units=imperial&appid=e5b292ae2f9dae5f29e11499c2d82ece"
  );
  xhr.onload = () => {
    if (xhr.readyState === 4) {
      if (xhr.status === 200) {
        let json = JSON.parse(xhr.responseText);
        document.getElementById("temp").innerHTML =
          json.main.temp.toFixed(0) + " F";
        document.getElementById("weather-description").innerHTML =
          json.weather[0].description;
      } else {
        console.log("error msg: " + xhr.status);
      }
    }
  };
  xhr.send();
}
// Handle writing out Bookmarks
function setupBookmarks() {
  const bookmarkContainer = document.getElementById("bookmark-container");
  bookmarkContainer.innerHTML = bookmarks
    .map((b) => {
      const html = ["<div class='bookmark-set'>"];
      html.push(`<div class="bookmark-title">${b.title}</div>`);
      html.push('<div class="bookmark-inner-container">');
      html.push(
        ...b.links.map(
          (l) =>
            `<a class="bookmark" href="${l.url}" target="_blank">${l.name}</a>`
        )
      );
      html.push("</div></div>");
      return html.join("");
    })
    .join("");
}

window.onload = () => {
  setupBookmarks();
  getWeather();
  // Set up the clock
  document.getElementById("clock").innerHTML = getTime();
  // Set clock interval to tick clock
  setInterval(() => {
    document.getElementById("clock").innerHTML = getTime();
  }, 100);
};

document.addEventListener("keyup", (event) => {
  if (event.keyCode == 32) {
    // Spacebar code to open search
    document.getElementById("search").style.display = "flex";
    document.getElementById("search-field").focus();
  } else if (event.keyCode == 27) {
    // Esc to close search
    document.getElementById("search-field").value = "";
    document.getElementById("search-field").blur();
    document.getElementById("search").style.display = "none";
  }
});
