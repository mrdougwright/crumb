let config = {};

function init(options) {
  config = {
    serverUrl: options.serverUrl || "",
    userId: options.userId || null,
  };
}

function track(event, properties = {}) {
  if (!config.serverUrl) {
    console.warn("[Crumb] serverUrl not set. Did you call init()?");
    return;
  }

  const payload = {
    event,
    properties,
    userId: config.userId,
  };

  fetch(`${config.serverUrl}/track`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  }).catch((err) => {
    console.error("[Crumb] Failed to send event:", err);
  });
}

export default {
  init,
  track,
};
