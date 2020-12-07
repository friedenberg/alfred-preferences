JsOsaDAS1.001.00bplist00�Vscript_>var main = function(chrome) {
	const bookmarkFolders = chrome.bookmarkFolders();
	
	const nodes = arrayFromObject(bookmarkFolders);
	const bookmarks = [];

	while (nodes.length > 0) {
		const currentNode = nodes.shift();
		nodes.push(...arrayFromObject(currentNode.bookmarkFolders()));
		const titles = currentNode.bookmarkItems.title();
		const urls = currentNode.bookmarkItems.url();
		bookmarks.push(...zip({title: titles, url: urls}));
	}
	
	return bookmarks;
};

var zip = function(obj) {
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

var arrayFromObject = function (object, extractor = el => el) {
	const nodes = [];
	const length = object.length;

	for (let i = 0; i < length; i++) {
		const element = object[i];
		nodes.push(extractor(element));
	}
	
	return nodes;
};

JSON.stringify(main(Application("Google Chrome")));                              Tjscr  ��ޭ