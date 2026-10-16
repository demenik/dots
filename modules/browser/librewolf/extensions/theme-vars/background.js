const HOST = "@host@";
const ORIGIN = "user";
const RECONNECT_MS = 5000;

let css = null;

browser.webNavigation.onCommitted.addListener(({ tabId, frameId }) => {
  if (css === null || tabId < 0) return;
  browser.tabs
    .insertCSS(tabId, {
      code: css,
      frameId,
      cssOrigin: ORIGIN,
      matchAboutBlank: true,
      runAt: "document_start",
    })
    .catch(() => {});
});

async function apply(next) {
  if (typeof next !== "string" || next === css) return;
  const prev = css;
  css = next;

  // Sheets are matched by their exact code, so the old one must be removed explicitly
  const tabs = await browser.tabs.query({});
  await Promise.allSettled(
    tabs.map(async ({ id }) => {
      if (prev !== null) {
        await browser.tabs.removeCSS(id, {
          code: prev,
          allFrames: true,
          cssOrigin: ORIGIN,
        });
      }
      await browser.tabs.insertCSS(id, {
        code: next,
        allFrames: true,
        cssOrigin: ORIGIN,
        matchAboutBlank: true,
      });
    }),
  );
}

function connect() {
  const port = browser.runtime.connectNative(HOST);
  port.onMessage.addListener((msg) => apply(msg.css));
  port.onDisconnect.addListener((p) => {
    if (p.error) console.warn(`${HOST}: ${p.error.message}`);
    setTimeout(connect, RECONNECT_MS);
  });
}

connect();
