#! /usr/bin/osascript -l JavaScript

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

function zip(obj) {
  const arr = [];
  const entries = Object.entries(obj);
  const anchor = entries[0][1];

  for (const idx in anchor) {
    const newObj = {};

    for (const entry of entries) {
      const key = entry[0];
      const value = entry[1][idx];
      newObj[key] = value;
    }

    arr.push(newObj);
  }

  return arr;
}

function arrayFromObject(object, extractor = el => el) {
  const nodes = [];
  const length = object.length;

  for (let i = 0; i < length; i++) {
    const element = object[i];
    nodes.push(extractor(element));
  }

  return nodes;
};
