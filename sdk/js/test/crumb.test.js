import { describe, test, expect, vi, beforeEach } from "vitest";
import crumb from "../src/index";

describe("Crumb SDK", () => {
  beforeEach(() => {
    global.fetch = vi.fn().mockResolvedValue({ status: 200 });
    window.__crumb_config = undefined;
  });

  test("init sets window config", () => {
    crumb.init({
      apiKey: "test-key",
      serverUrl: "http://localhost:4000",
      userId: "abc123",
    });

    expect(window.__crumb_config).toEqual({
      apiKey: "test-key",
      serverUrl: "http://localhost:4000",
      userId: "abc123",
    });
  });

  test("track calls fetch with event payload", async () => {
    crumb.init({
      apiKey: "test-key",
      serverUrl: "http://localhost:4000",
      userId: "abc123",
    });

    crumb.track("Test Event", { foo: "bar" });

    expect(fetch).toHaveBeenCalledWith(
      "http://localhost:4000/track",
      expect.objectContaining({
        method: "POST",
        headers: {
          Authorization: "Bearer test-key",
          "Content-Type": "application/json",
        },
        body: expect.stringContaining(`"event":"Test Event"`),
      }),
    );
  });
});
