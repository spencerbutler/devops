## Work in progress
[Create](https://www.debian.org/releases/stable/amd64/apb.en.html) a very minimal debian image from the [https://www.debian.org/CD/netinst/#netinst-stable](latest) debian netinstall release.

### TODO
- Fix the preseed, it currently needs user interaction and fails at the end
- Make a proper template for the preseed
- migrate serve.sh to serve.py and have it handle the variables

### Notes
- Don't add comments to the top of the file. [The file should start with #\_preseed_V1](https://www.debian.org/releases/stable/amd64/apbs03.en.html)
- To check if the format of your preconfiguration file is valid before performing an install, you can use the command debconf-set-selections -c preseed.cfg.


### Resources
