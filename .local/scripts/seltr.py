import argparse
import urllib.request


def argparser():
    parser = argparse.ArgumentParser(description='Instant Translator')
    parser.add_argument('phrase', metavar='p', type=str,
                        help='phrase to translate')
    parser.add_argument('to_lang', metavar='tl', type=str, default='pt-BR',
                        help='language the pharase will be translated to')
    parser.add_argument('from_lang', metavar='fl', type=str, default='auto',
                        help='language the phrase will be tranlated from')
    return parser.parse_args()


def translate(to_translate, to_language="pt-BR", language="auto"):
    agents = {'User-Agent': "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/86.0.4240.111 Safari/537.36"}
    link = "http://translate.google.com/m?hl=%s&sl=%s&q=%s" % (to_language, language, to_translate.replace('-\n', '').replace('\n', '+').replace(' ', '+'))
    request = urllib.request.Request(url=link, headers=agents)
    page = urllib.request.urlopen(request).read().decode('utf-8')
    if 'class="t0"' in page:
        # print("#1")
        # print(page)
        return page.split('class="t0">')[1].split('</div>')[0]
    else:
        # print("#2")
        # print(page)
        return page.split('class="result-container">')[1].split('</div>')[0]

args = argparser()
print(translate(args.phrase, args.to_lang, args.from_lang))

# translate("The next two arguments are only of interest for correct handling of third-party HTTP cookies", "pt-BR", "en")
