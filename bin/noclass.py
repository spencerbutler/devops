"""No Class, No Way!
Loads helpful tools.
Loads bullshit tools.
Hopefully it fucking loads ...
"""
from urllib import parse
from urllib.parse import quote,unquote
import os, pathlib, glob, time, json
import requests
import rich
import subprocess
import re
"""
to avoid:
>> os.rename('../test.file', '/mnt/c/spencer/')
   [Errno 18] Invalid cross-device link: '../test.file' -> '/mnt/c/spencer/'
>> shutil.move('file', '/mnt/c/spencer/')
"""
import shutil


class Tools:
    def __init__(self, name='Unknown'):
        def ipinfo():

            ipinfo_url = "https://ipinfo.io"
            ipinfo = requests.get(ipinfo_url).json()
            return ipinfo

        def dns_ip():

            DNS_CMD = 'dig +short TXT o-o.myaddr.l.google.com @ns1.google.com'.split(' ')
            dns_ip = json.loads(subprocess.run(DNS_CMD, capture_output=True).stdout)
            return dns_ip

        self.idx = 0
        self.name = name
        self.ipinfo = ipinfo()
        self.dns_ip = dns_ip()


    def __str__(self):
        return f"{self.name}"


    def __iter__(self):
        return iter((self.name, self.ipinfo, self.dns_ip))


def pp(data, indent=2):
    if isinstance(data, (str, dict, list, int, float, tuple)):
        return rich.print_json(json.dumps(data, indent=indent))
    else:
        return rich.print(type(data), "is not printable.")


def binary_code_to_text(bits):
    bitlist = bits.split(' ')
    chrlist = []
    for i in bitlist:
        chrlist.append(chr(int(i,2)))
    return "".join(chrlist)


def text_to_binary_code(string):
    return " ".join(map(bin,bytearray(string.encode('utf-8'))))


def foo(url='https://httpbin.org/json'):
    s = requests.Session()
    try:
        r = s.get(url)
    except Exception as e:
        return e
    ct = str(r.headers.get('content-type', 'NO'))

    if 'json' in ct:
        return r.json()
    elif 'html' in ct:
        return r.text
    elif 'NO' in ct:
        return ct
    else:
        return ct


def urlencode(string):
    return quote(string)


def urldecode(string):
    return unquote(string)


def dict_generator(indict, pre=None):
    pre = pre[:] if pre else []
    if isinstance(indict, dict):
        for key, value in indict.items():
            if isinstance(value, dict):
                for d in dict_generator(value, pre + [key]):
                    yield d
            elif isinstance(value, list) or isinstance(value, tuple):
                for v in value:
                    for d in dict_generator(v, pre + [key]):
                        yield d
            else:
                yield pre + [key, value]
    else:
        yield pre + [indict]


def get_target_stores(area='554'):
    from TargetAPI import Target
    target = Target(api_key=target_api_key)
    stores = target.stores
    mystores = []
    tstores = []
    for store in stores:
        d = {
                "name": store.name,
                "id": int(store.id),
                "active": store.active,
                "city": store.city,
                "phone_number": format_phone(store.phone_number),
                "type": store.type,
                "zipcode": store.zipcode,
            }
        if store.zipcode.startswith(area):
            mystores.append(d)
        else:
            tstores.append(d)
    return mystores, tstores

class nothing():
    def __init__(self):
        self.name = 'nothing'

def sort_uniq_list(alist):
    if isinstance(alist, list):
        return set(alist)
    else:
        return f"{type(alist)} is not a list."

def touch_file(filename):
    s = filename.split('/') # split the filename to get the directory name.
    sl = len(s) # get the length of the list to build the directory path.
    d = "/".join(s[:sl-1]) # join the dir path.

    if os.path.isdir(d):
        # the quick python 3.4+ way
        #pathlib.Path(filename).touch()

        # the old-school way
        with open(filename, 'a'):
            os.utime(filename, times=None)

    else:
        print(f"The directory, {d}, does not exist.")

class URLs:
    def __init__(self):
        urls = [
                "http://api.worldbank.org/countries/USA/indicators/NY.GDP.MKTP.CD?per_page=5000&format=json",
                "http://api.worldbank.org/countries/CHN/indicators/NY.GDP.MKTP.CD?per_page=5000&format=json",
                "https://api.opensource.org/licenses/",
                "http://api.worldbank.org/countries/USA/indicators/SP.POP.TOTL?per_page=5000&format=json",
                "https://www.reddit.com/r/todayilearned.json",
                "http://services.faa.gov/airport/status/JFK?format=application/json",
                ]
        self.urls = urls
        self.url_info = {}
    
    def make_url_info(self, urls: list):
        for url in urls:
            obj = parse.urlparse(url)
            self.url_info.update({
                url: {
                    "scheme": obj.scheme,
                    "hostname": obj.hostname,
                    "path": obj.path,
                    "params": obj.params,
                    "query": obj.query,
                    }
                })

    
class MakeSoup:
    def __init__(self, url):
        from bs4 import BeautifulSoup

        self.url = url
        req = requests.get(self.url)
        if req.ok:
            content = req.content
            self.soup = BeautifulSoup(content)
        else:
            self.content = None


def time_execution(COMMAND):
    """Print the execution time of `COMMAND`.
    """
    start = time.time()
    COMMAND
    end = time.time()
    # TODO(spencer): the output is in ms
    # fix formating.
    print(end, 'seconds')


def example():
    """Examples:
    https://scrapfly.io/blog/web-scraping-with-python-beautifulsoup/
    """
    html = """
    <div class="product">
      <h2>Product Title</h2>
      <div class="price">
        <span class="discount">12.99</span>
        <span class="full">19.99</span>
      </div>
    </div>
    """
    from bs4 import BeautifulSoup
    
    soup = BeautifulSoup(html, "lxml")
    product = {
        "title": soup.find(class_="product").find("h2").text,
        "full_price": soup.find(class_="product").find(class_="full").text,
        "price": soup.select_one(".price .discount").text,
    }
    print(product)

    return soup
