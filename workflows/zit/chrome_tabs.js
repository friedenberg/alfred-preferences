#! /usr/bin/osascript -l JavaScript

function run(argv) {
  const chrome = Application("Google Chrome");

  tabs = [];

  for (let tab in chrome.windows.tabs.) {
      tabs.push({ title: tabInfo.title(), url: tab.url() });
  }

  return JSON.stringify(tabs);
}
