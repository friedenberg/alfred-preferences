#! /usr/bin/osascript -l JavaScript
# ---
# description: open a chrome tab with the passed-in url
# ...

function run(argv) {
  const urlSelected = argv[0]
  const chrome = Application("Google Chrome");
  const windows = chrome.windows();

  for (let idxWindow in windows) {
    for (let idxTab in windows[idxWindow].tabs) {
      if (windows[idxWindow].tabs[idxTab].url() == urlSelected) {
        chrome.windows[idxWindow].activeTabIndex = parseInt(idxTab) + 1;
        chrome.windows[idxWindow].index = 1;
        chrome.activate();
        return;
      }
    }
  }
}
