#! /usr/bin/osascript -l JavaScript
# ---
# description: print the list of chrome tabs
# ...

function run(argv) {
  const chrome = Application("Google Chrome");
  const windows = chrome.windows();

  tabs = [];

  for (let idxWindow in windows) {
    for (let idxTab in windows[idxWindow].tabs) {
      const tab = windows[idxWindow].tabs[idxTab].get();
      tabs.push({title: tab.title(), url: tab.url()});
    }
  }

  return JSON.stringify(tabs);
}

