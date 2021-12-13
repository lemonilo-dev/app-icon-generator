const puppeteer = require('puppeteer');

const URL = 'https://lemonilo.github.io/android-asset-studio/icons-launcher.html';

const delay = (time) => {
  return new Promise(function (resolve) {
    setTimeout(resolve, time);
  });
};

(async () => {
  const browser = await puppeteer.launch({
    headless: true,
  });

  const page = await browser.newPage();

  try {
    await page._client.send('Page.setDownloadBehavior', {
      behavior: 'allow',
      downloadPath: 'download',
    });

    await page.goto(URL);

    const elementHandle = await page.$('#_frm-iconform-foreground[type=file]');

    await elementHandle.uploadFile('icon.png');

    await page.waitForSelector('.form-image-preview', { visible: true });
    await delay(5000);

    /* Generate Square Icons */
    await page.focus('a[download="ic_launcher.zip"]');
    await page.keyboard.type('\n');
    await delay(5000);

    /* Generate Circle Icons */
    await (await page.$('label[for="_frm-iconform-backgroundShape-circle"]')).click();
    await page.keyboard.type('\n');
    await delay(5000);

    await page.$eval('a[download="ic_launcher.zip"]', e => e.setAttribute('download', 'ic_launcher_circle.zip'));
    await page.focus('a[download="ic_launcher_circle.zip"]');
    await page.keyboard.type('\n');
    await delay(2000);

    await browser.close();
  } catch (e) {
    console.log(e.message);
    process.exit(64);
  }
})();
