#! /usr/bin/env /Users/sasha/Zettelkasten/1630272875.js

const lib = require("~/Zettelkasten/1630272891.js");

function main(argv) {
  const things = Application("Things3");
  things.includeStandardAdditions = true

  const todos = things.toDos.id();
  let names = [];

  for (const t of todos) {
    const todo = things.toDos.byId(t);
    names.push({
      id: todo.id(),
      name: todo.name(),
    });

    if (names.length > 3) {
      break;
    }
  }

  //when iterating via for..in, arrays are 1-indexed
  //when accessing via [] syntax, arrays are 0-indexed
  lib.log(JSON.stringify(names));
}

exports.main = main;

