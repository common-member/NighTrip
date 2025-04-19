document.addEventListener("turbo:load", function () {
  const noticeAlert = document.getElementById("notice-alert");
  const alertAlert = document.getElementById("alert-alert");

  const fadeOut = (element) => {
    if (!element) return;
    setTimeout(() => {
      element.style.transition = "opacity 0.5s ease-out";
      element.style.opacity = "0";
      setTimeout(() => {
        element.style.display = "none";
      }, 500);
    }, 5000);
  };

  fadeOut(noticeAlert);
  fadeOut(alertAlert);
});
