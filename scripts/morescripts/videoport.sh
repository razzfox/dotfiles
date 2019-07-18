nc -kl $1 << HTML
<html><head><meta name="viewport" content="width=device-width"></head><body><video controls="" autoplay="" name="media"><source src="$2" type="video/${1##*\.}"></video></body></html>
HTML
