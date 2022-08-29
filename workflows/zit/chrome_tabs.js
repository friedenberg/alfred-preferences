#! /usr/bin/osascript -l JavaScript

function run(argv) {
  const chrome = Application("Google Chrome");

  urls = [];

  for (const urlsOfTab of chrome.windows.tabs.url()) {
    for (const url of urlsOfTab) {
      urls.push(url);
    }
  }

  return JSON.stringify(urls);
}
