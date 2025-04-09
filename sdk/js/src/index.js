(function () {
  function init(options) {
    console.log("[Crumb SDK] init called with:", options);
    window.__crumb_config = {
      apiKey: options.apiKey,
      serverUrl: options.serverUrl,
      userId: options.userId,
    };
  }

  function track(event, properties = {}) {
    const config = window.__crumb_config || {};
    if (!config.apiKey) {
      console.warn("[Crumb SDK] apiKey not set");
      return;
    }
    if (!config.serverUrl) {
      console.warn("[Crumb SDK] serverUrl not set");
      return;
    }

    const payload = {
      event,
      properties,
      userId: config.userId,
    };

    fetch(`${config.serverUrl}/track`, {
      method: "POST",
      headers: {
        Authorization: `Bearer ${config.apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    })
      .then((res) => {
        console.log("[Crumb SDK] response:", res.status);
      })
      .catch((err) => {
        console.error("[Crumb SDK] error:", err);
      });
  }

  const crumb = { init, track };

  if (typeof window !== "undefined") {
    window.crumb = crumb;
  }

  if (typeof module !== "undefined") {
    module.exports = crumb; // CommonJS support
  }
})();
