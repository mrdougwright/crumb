(function () {
  function init(options) {
    console.log("[Crumb SDK] init called with:", options);
    window.__crumb_config = {
      apiKey: options.apiKey,
      serverUrl: options.serverUrl,
      userId: options.userId,
    };
  }

  function send(path, payload) {
    const { apiKey, serverUrl } = window.__crumb_config;
    console.log(`[Crumb SDK] sending to /${path}:`, payload);

    return fetch(`${serverUrl}/${path}`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${apiKey}`,
      },
      body: JSON.stringify(payload),
    })
      .then((res) => {
        console.log("[Crumb SDK] response:", res.status);
        return res;
      })
      .catch((err) => {
        console.error("[Crumb SDK] error:", err);
        throw err;
      });
  }

  function track({ event, properties = {} }) {
    return send("track", {
      type: "track",
      event,
      properties,
      userId: window.__crumb_config.userId,
    });
  }

  function identify({ traits = {} }) {
    return send("identify", {
      type: "identify",
      traits,
      userId: window.__crumb_config.userId,
    });
  }

  const crumb = { init, track, identify };

  if (typeof window !== "undefined") {
    window.crumb = crumb;
  }

  if (typeof module !== "undefined") {
    module.exports = crumb; // CommonJS support
  }
})();
