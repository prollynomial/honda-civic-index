const yql = require('yql');
const fs = require('fs');
const PAGE_LIMIT = 23;

const urls = {
	'mtl': [ 'b-autos-camions/ville-de-montreal', 'c174l1700281a54a1000054' ],
	'tor': [ 'b-cars-trucks/city-of-toronto', 'c174l1700273a54a1000054' ],
	'cgy': [ 'b-cars-trucks/calgary', 'c174l1700199a54a1000054' ],
	'edm': [ 'b-cars-trucks/edmonton', 'c174l1700203a54a1000054' ],
	'ott': [ 'b-cars-trucks/ottawa', 'c174l1700185a54a1000054' ],
	'wpg': [ 'b-cars-trucks/winnipeg', 'c174l1700192a54a1000054' ]
};

function scrape(city, cb) {
	// Scrape pages until we
	// TODO a) find a page that we've seen all of
	// b) hit PAGE_LIMIT
	let scraper = p => scrapePage(urls[city], p, cb);
	for (let page = 1; page <= PAGE_LIMIT; page++) {
		scraper(page);
	}
}

const opts = { ssl: true };
function scrapePage(cityUrl, page, cb) {
	const url = 'http://www.kijiji.ca/' + cityUrl[0] + '/honda-civic/page-' + page + '/' + cityUrl[1] + '?ad=offering';

	yql('select * from html where url=@url and xpath=@path', opts)
		.setParam('url', url)
		.setParam('path', '//*[@data-ad-id and not(contains(@class, "top-feature"))]//*[@class="title"]/a')
		.exec(processResults);

	function processResults(err, res) {
		if (err) {
			cb([err], null);
		} else if (!res.query.results) {
			cb(['no content']);
		} else {
			const ads = res.query.results.a.map(toAd);
			scrapeAllAdContent(ads, cb);
		}
	}
}

function toAd(anchor) {
	return {
		href: 'http://kijiji.ca' + anchor.href,
		title: cleanText(anchor.content)
	};
}

function scrapeAllAdContent(ads, cb) {
	const max = ads.length,
		results = [],
		errors = [];
	let count = 0;

	// every time an ad gets scraped, increase count, if count === max, call cb
	ads.forEach(scrapeAdContent);

	function scrapeAdContent(ad) {
		yql('select * from html where url=@url and xpath=@path')
			.setParam('url', ad.href)
			.setParam('path', '//table[@class="ad-attributes"]//tr[not(@class="divider")]')
			.exec(mapAdContent(ad));
	}

	function mapAdContent(ad) {
		return function (err, res) {
			if (err) {
				errors.push(err);
			} else if (!res.query.results) {
				errors.push('no content');
			} else {
				results.push(scrapeFullAd(ad, res.query.results));
			}

			count += 1;
			if (count === max) {
				cb(errors, results);
			}
		}
	}
}

function scrapeFullAd(ad, results) {
	const rows = results.tr;
	rows.forEach(function (row) {
		if (!row.th || typeof row.th !== 'string') {
			return;
		}

		switch (cleanText(row.th)) {
		case 'price':
		case 'prix':
			if (row.td.div) {
				ad.price = cleanPrice(row.td.div.span.strong);
			} else {
				ad.price = cleanPrice(row.td);
			}
			break;
		case 'year':
		case 'année':
			ad.year = cleanNumeric(row.td);
			break;
		case 'make':
		case 'marque':
			if (row.td.a) {
				ad.make = cleanText(row.td.a.span.content);
			} else {
				ad.make = cleanText(row.td);
			}
			break;
		case 'model':
		case 'modèle':
			if (row.td.a) {
				ad.model = cleanText(row.td.a.span.content);
			} else if (row.td.span) {
				ad.model = cleanText(row.td.span.content);
			} else {
				ad.model = cleanText(row.td);
			}
			break;
		case 'body type':
		case 'type de carrosserie':
			ad.body = cleanText(row.td);
			break;
		case 'kilometers':
		case 'kilomètres':
			ad.kms = cleanNumeric(row.td);
			break;
		}
	});
	return ad;
}

function cleanPrice(raw) {
	if (!raw.includes('.')) {
		// Handles French prices that use commas instead of decimals.
		raw = raw.replace(',', '.');
	}
	return cleanNumeric(raw.replace('$', ''));
}

function cleanNumeric(raw) {
	return Number(cleanText(raw).replace(',', '').replace(/\s+/g, ''));
}

function cleanText(raw) {
	return decodeHtmlEntity(raw.trim().toLowerCase());
}

function decodeHtmlEntity(str) {
	return str.replace(/&#(\d+);/g, function(_, dec) {
		return String.fromCharCode(dec);
	});
}

const cols = [ 'href', 'price', 'make', 'model', 'year', 'body', 'kms' ];
fs.writeFileSync('civics.csv', cols.join(',') + '\n');

scrape('mtl', (errs, ads) => {
	if (errs) {
		errs.forEach(err => console.log(err));
	}

	if (ads) {
		console.log(ads.length + ' ads found');
		ads.map(toCsv).forEach(appendToOutput);
	}
});

function toCsv(ad) {
	return cols.map(c => ad[c]).join(',') + '\n';
}

function appendToOutput(row) {
	fs.appendFile('civics.csv', row);
}
