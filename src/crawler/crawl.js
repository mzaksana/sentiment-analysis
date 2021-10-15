var gplay = require('google-play-scraper');
require('dotenv').config({ path: '/home/mza/Documents/Pro/protwm/.env' })

var args = [];

if (process.argv.length >= 2) {
	switch (process.argv[2]) {
		case "category": console.log(Object.keys(gplay.category))
			break;
		case "getAppsByCate": getAppsByCate(process.argv[3], process.argv[4]);
			break;
		case "getIdApps": getIdApps(process.argv[3], process.argv[4]);
			break;
		case "getReviewsById": getReviewsById(process.argv[3], process.argv[4]);
			break;
		default:
			break;
	}
}

/**
 * 
 * @param {*} cate categori params to crawl
 * @param {*} start position page to crawl
 */
function getAppsByCate(cate, start) {
	gplay.list({
		category: cate,
		collection: gplay.collection.TOP_FREE,
		start: start,
		num: 100,
		lang: 'id'
	}).then(jsonLog);
}


/**
 *
 * @param {*} id app id to crawl
 * @param {*} start position page to crawl
 */
function getIdApps(id, start) {
	gplay.app({ appId: id, lang: 'id' })
		.then(console.log);
}

/**
 *
 * @param {*} id app id to crawl
 * @param {*} start position page to crawl
 */
function getReviewsById(id, start) {
	gplay.reviews({
		appId: id,
		page: start,
		sort: gplay.sort.RATING,
		lang: 'id'
	}).then(jsonLog);
}
function jsonLog(params) {
	console.log(JSON.stringify(params))
}

// main section
// Object.keys(gplay.category).forEach(getAppsByCate);
