#! /usr/bin/osascript -l JavaScript

function run(argv) {
  const chrome = Application("Google Chrome");
  const windows = chrome.windows();

  const nodes = arrayFromObject(windows);
  const tabs = [];

  while (nodes.length > 0) {
    const window = nodes.shift();
    const ids = window.tabs.id();
    const titles = window.tabs.title();
    const urls = window.tabs.url();
    tabs.push(...zip({id: ids, title: titles, url: urls}));
  }

  return JSON.stringify(tabs);
};

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
